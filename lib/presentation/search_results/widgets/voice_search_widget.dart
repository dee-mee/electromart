import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceSearchWidget extends StatefulWidget {
  final Function(String) onTranscriptionComplete;
  final VoidCallback onCancel;

  const VoiceSearchWidget({
    Key? key,
    required this.onTranscriptionComplete,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<VoiceSearchWidget> createState() => _VoiceSearchWidgetState();
}

class _VoiceSearchWidgetState extends State<VoiceSearchWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isRecording = false;
  String _transcriptionPreview = '';
  List<double> _waveformData = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _startRecording();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(const RecordConfig(),
            path: 'voice_search.m4a');
        setState(() => _isRecording = true);
        _animationController.repeat(reverse: true);
        _simulateWaveform();
      }
    } catch (e) {
      widget.onCancel();
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      _animationController.stop();

      if (path != null) {
        // Simulate transcription process
        await _simulateTranscription();
      }
    } catch (e) {
      widget.onCancel();
    }
  }

  void _simulateWaveform() {
    // Simulate real-time waveform data
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isRecording && mounted) {
        setState(() {
          _waveformData
              .add((DateTime.now().millisecondsSinceEpoch % 100) / 100.0);
          if (_waveformData.length > 50) {
            _waveformData.removeAt(0);
          }
        });
        _simulateWaveform();
      }
    });
  }

  Future<void> _simulateTranscription() async {
    const transcriptionSteps = [
      'Listening...',
      'iPhone...',
      'iPhone 15...',
      'iPhone 15 Pro',
    ];

    for (final step in transcriptionSteps) {
      if (mounted) {
        setState(() => _transcriptionPreview = step);
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (mounted) {
      widget.onTranscriptionComplete('iPhone 15 Pro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWaveformVisualization(),
                SizedBox(height: 4.h),
                _buildMicrophoneButton(),
                SizedBox(height: 4.h),
                _buildTranscriptionPreview(),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _isRecording ? 'Listening...' : 'Voice Search',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          if (_isRecording)
            Text(
              'Speak now',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWaveformVisualization() {
    return Container(
      height: 15.h,
      width: 80.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _isRecording
          ? CustomPaint(
              painter: WaveformPainter(_waveformData),
              size: Size(double.infinity, 10.h),
            )
          : Center(
              child: CustomIconWidget(
                iconName: 'graphic_eq',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 48,
              ),
            ),
    );
  }

  Widget _buildMicrophoneButton() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isRecording ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: _isRecording
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: _isRecording ? 'stop' : 'mic',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 32,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTranscriptionPreview() {
    return Container(
      width: 80.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Text(
        _transcriptionPreview.isNotEmpty
            ? _transcriptionPreview
            : 'Your speech will appear here...',
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: _transcriptionPreview.isNotEmpty
              ? AppTheme.lightTheme.colorScheme.onSurface
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: widget.onCancel,
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (!_isRecording && _transcriptionPreview.isNotEmpty)
            ElevatedButton(
              onPressed: () =>
                  widget.onTranscriptionComplete(_transcriptionPreview),
              child: const Text('Search'),
            ),
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;

  WaveformPainter(this.waveformData);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.primary
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    final barWidth = size.width / waveformData.length;

    for (int i = 0; i < waveformData.length; i++) {
      final barHeight = waveformData[i] * size.height;
      final rect = Rect.fromLTWH(
        i * barWidth,
        size.height - barHeight,
        barWidth * 0.8,
        barHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
