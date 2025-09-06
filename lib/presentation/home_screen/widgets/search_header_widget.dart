import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchHeaderWidget extends StatefulWidget {
  const SearchHeaderWidget({super.key});

  @override
  State<SearchHeaderWidget> createState() => _SearchHeaderWidgetState();
}

class _SearchHeaderWidgetState extends State<SearchHeaderWidget> {
  final TextEditingController _searchController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isListening = false;

  @override
  void dispose() {
    _searchController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: _buildSearchField(),
            ),
            SizedBox(width: 3.w),
            _buildVoiceSearchButton(),
            SizedBox(width: 2.w),
            _buildBarcodeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search for phones, earphones...",
          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        onChanged: (value) {
          setState(() {});
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Navigator.pushNamed(context, '/search-results');
          }
        },
      ),
    );
  }

  Widget _buildVoiceSearchButton() {
    return GestureDetector(
      onTap: _toggleVoiceSearch,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: _isRecording || _isListening
              ? AppTheme.accentLight.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isRecording || _isListening
                ? AppTheme.accentLight
                : AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: _isRecording ? 'mic' : 'mic_none',
            color: _isRecording || _isListening
                ? AppTheme.accentLight
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
        ),
      ),
    );
  }

  Widget _buildBarcodeButton() {
    return GestureDetector(
      onTap: _openBarcodeScanner,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: 'qr_code_scanner',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
        ),
      ),
    );
  }

  Future<void> _toggleVoiceSearch() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isListening = true;
        });

        await _audioRecorder.start(const RecordConfig(),
            path: 'voice_search.m4a');

        setState(() {
          _isRecording = true;
          _isListening = false;
        });

        // Auto-stop after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (_isRecording) {
            _stopRecording();
          }
        });
      } else {
        _showPermissionDialog(
            "Microphone access is required for voice search.");
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isListening = false;
      });
      _showErrorMessage("Voice search is not available at the moment.");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _isListening = false;
      });

      if (path != null) {
        // Simulate voice processing
        _showSuccessMessage("Voice search processed successfully!");
        // In a real app, you would process the audio file here
        Navigator.pushNamed(context, '/search-results');
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isListening = false;
      });
      _showErrorMessage("Failed to process voice search.");
    }
  }

  Future<void> _openBarcodeScanner() async {
    try {
      if (kIsWeb) {
        _showErrorMessage("Barcode scanning is not available on web.");
        return;
      }

      final permission = await Permission.camera.request();
      if (permission.isGranted) {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          _showBarcodeScanner(cameras);
        } else {
          _showErrorMessage("No camera available for barcode scanning.");
        }
      } else {
        _showPermissionDialog(
            "Camera access is required for barcode scanning.");
      }
    } catch (e) {
      _showErrorMessage("Barcode scanner is not available at the moment.");
    }
  }

  void _showBarcodeScanner(List<CameraDescription> cameras) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BarcodeScannerWidget(
        cameras: cameras,
        onBarcodeScanned: (barcode) {
          Navigator.pop(context);
          _searchController.text = barcode;
          Navigator.pushNamed(context, '/search-results');
        },
      ),
    );
  }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _BarcodeScannerWidget extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function(String) onBarcodeScanned;

  const _BarcodeScannerWidget({
    required this.cameras,
    required this.onBarcodeScanned,
  });

  @override
  State<_BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  CameraController? _cameraController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final camera = widget.cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => widget.cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to initialize camera"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Scan Barcode",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isInitialized && _cameraController != null
                ? Stack(
                    children: [
                      CameraPreview(_cameraController!),
                      Center(
                        child: Container(
                          width: 60.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _simulateBarcodeDetection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentLight,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                            ),
                            child: const Text(
                              "Capture",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _simulateBarcodeDetection() {
    // Simulate barcode detection
    const mockBarcode = "1234567890123";
    widget.onBarcodeScanned(mockBarcode);
  }
}
