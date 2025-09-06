import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onVoiceSearch;
  final Function(String) onRecentSearchTap;
  final List<String> recentSearches;
  final bool showSuggestions;

  const SearchBarWidget({
    Key? key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onVoiceSearch,
    required this.onRecentSearchTap,
    required this.recentSearches,
    this.showSuggestions = false,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchQuery;
    _focusNode.addListener(() {
      setState(() {
        _showDropdown = _focusNode.hasFocus && widget.recentSearches.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startVoiceRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() => _isRecording = true);
        await _audioRecorder.start(const RecordConfig(),
            path: 'voice_search.m4a');
        widget.onVoiceSearch();
      }
    } catch (e) {
      setState(() => _isRecording = false);
    }
  }

  Future<void> _stopVoiceRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        // Simulate voice transcription result
        _controller.text = 'iPhone 15 Pro';
        widget.onSearchChanged('iPhone 15 Pro');
      }
    } catch (e) {
      setState(() => _isRecording = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: widget.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search for phones, earphones...',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
              GestureDetector(
                onTap:
                    _isRecording ? _stopVoiceRecording : _startVoiceRecording,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    color: _isRecording
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: _isRecording ? 'stop' : 'mic',
                    color: _isRecording
                        ? AppTheme.lightTheme.colorScheme.onTertiary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showDropdown && widget.recentSearches.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Text(
                    'Recent Searches',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ...widget.recentSearches.take(5).map(
                      (search) => ListTile(
                        dense: true,
                        leading: CustomIconWidget(
                          iconName: 'history',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        title: Text(
                          search,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          widget.onRecentSearchTap(search);
                          _controller.text = search;
                          _focusNode.unfocus();
                        },
                      ),
                    ),
              ],
            ),
          ),
      ],
    );
  }
}
