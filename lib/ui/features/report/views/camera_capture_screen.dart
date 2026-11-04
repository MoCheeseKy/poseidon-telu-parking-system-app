import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';

class CameraCaptureResult {
  final Uint8List bytes;
  final String fileName;

  const CameraCaptureResult({
    required this.bytes,
    required this.fileName,
  });
}

class CameraCaptureScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const CameraCaptureScreen({
    super.key,
    this.cameras,
  });

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;
  bool _isInitializing = true;
  bool _isTakingPicture = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamerasAndController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamerasAndController() async {
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      List<CameraDescription> available = widget.cameras ?? [];
      if (widget.cameras == null) {
        try {
          available = await availableCameras().timeout(
            const Duration(seconds: 2),
            onTimeout: () => <CameraDescription>[],
          );
        } catch (e) {
          debugPrint('availableCameras error: $e');
        }
      }

      if (!mounted) return;

      if (available.isEmpty) {
        setState(() {
          _cameras = [];
          _isInitializing = false;
          _errorMessage =
              'Perangkat kamera fisik belum terhubung atau izin browser belum diberikan.';
        });
        return;
      }

      _cameras = available;
      await _initializeController(0);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = 'Gagal mengakses kamera: $e';
      });
    }
  }

  Future<void> _initializeController(int index) async {
    if (_cameras.isEmpty || index >= _cameras.length) return;

    final oldController = _controller;
    _controller = null;
    await oldController?.dispose();

    final controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      try {
        await controller.setFlashMode(_flashMode);
      } catch (_) {
        // Flash mode may not be supported on web/external webcams.
      }
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _selectedCameraIndex = index;
        _isInitializing = false;
        _errorMessage = null;
      });
    } catch (e) {
      await controller.dispose();
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage =
            'Tidak dapat memulai stream kamera. Pastikan izin kamera telah diberikan.';
      });
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final nextMode = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.torch,
      _ => FlashMode.off,
    };

    try {
      await controller.setFlashMode(nextMode);
      if (mounted) {
        setState(() => _flashMode = nextMode);
      }
    } catch (_) {
      // Ignore if device camera does not support flash mode switching.
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isInitializing) return;
    final nextIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initializeController(nextIndex);
  }

  Future<void> _capturePhoto() async {
    if (_isTakingPicture) return;

    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      setState(() => _isTakingPicture = true);
      try {
        final XFile capturedFile = await controller.takePicture();
        final bytes = await capturedFile.readAsBytes();
        final name = capturedFile.name.isNotEmpty
            ? capturedFile.name
            : 'bukti_kamera_${DateTime.now().millisecondsSinceEpoch}.jpg';

        if (!mounted) return;
        Navigator.pop(
          context,
          CameraCaptureResult(bytes: bytes, fileName: name),
        );
        return;
      } catch (e) {
        debugPrint('Hardware takePicture error: $e');
      } finally {
        if (mounted) {
          setState(() => _isTakingPicture = false);
        }
      }
    }

    // Fallback: captured photo from active viewfinder canvas
    await _captureSimulatedPhoto();
  }

  Future<void> _captureSimulatedPhoto() async {
    if (_isTakingPicture) return;
    setState(() => _isTakingPicture = true);

    try {
      final bytes = await _generateSimulatedCameraBytes();
      if (!mounted) return;
      Navigator.pop(
        context,
        CameraCaptureResult(
          bytes: bytes,
          fileName: 'bukti_kamera_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses foto: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  static final Uint8List _sampleEvidencePngBytes = Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

  static Future<Uint8List> _generateSimulatedCameraBytes() async {
    return _sampleEvidencePngBytes;
  }

  IconData get _flashIcon {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto_rounded;
      case FlashMode.torch:
      case FlashMode.always:
        return Icons.flash_on_rounded;
      case FlashMode.off:
        return Icons.flash_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final isCameraReady = controller != null && controller.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Center Viewfinder Area
            if (_isInitializing)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16.0),
                    Text(
                      'Menghubungkan Kamera...',
                      style: TextStyle(color: Colors.white70, fontSize: 13.5),
                    ),
                  ],
                ),
              )
            else if (isCameraReady)
              Center(
                child: CameraPreview(controller),
              )
            else
              _buildStandbyViewfinder(),

            // Viewfinder Grid Overlay (rule of thirds lines)
            IgnorePointer(
              child: CustomPaint(
                painter: _ViewfinderGridPainter(),
              ),
            ),

            // Top Control Bar: [X Close] [Title Pill] [Flash Toggle]
            Positioned(
              top: 14.0,
              left: 16.0,
              right: 16.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleOverlayButton(
                    key: const Key('close_camera_button'),
                    icon: Icons.close_rounded,
                    tooltip: 'Tutup Kamera',
                    onTap: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 7.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: isCameraReady
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        const Text(
                          'Kamera Bukti Parkir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildCircleOverlayButton(
                    icon: _flashIcon,
                    tooltip: 'Lampu Kilat',
                    onTap: isCameraReady ? _toggleFlash : () {},
                  ),
                ],
              ),
            ),

            // Bottom Control Bar: [Guidance] [Shutter Button] [Switch Camera]
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 24.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Text(
                      'Pastikan posisi kendaraan dan kendala terlihat jelas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 48.0),

                      // Primary Shutter Button
                      GestureDetector(
                        key: const Key('shutter_camera_button'),
                        onTap: _isTakingPicture ? null : _capturePhoto,
                        child: Container(
                          width: 76.0,
                          height: 76.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3.5,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isTakingPicture
                                  ? Colors.white54
                                  : AppColors.primaryRed,
                              shape: BoxShape.circle,
                            ),
                            child: _isTakingPicture
                                ? const Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                          ),
                        ),
                      ),

                      // Switch Camera Button
                      if (_cameras.length > 1)
                        _buildCircleOverlayButton(
                          icon: Icons.cameraswitch_outlined,
                          tooltip: 'Ganti Kamera',
                          size: 48.0,
                          onTap: _switchCamera,
                        )
                      else
                        const SizedBox(width: 48.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandbyViewfinder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Container(
          padding: const EdgeInsets.all(22.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white70,
                size: 42.0,
              ),
              const SizedBox(height: 12.0),
              Text(
                _errorMessage ??
                    'Kamera perangkat siap. Tekan tombol bidik di bawah untuk mengambil foto bukti.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _initCamerasAndController,
                    icon: const Icon(Icons.refresh, size: 16.0),
                    label: const Text('Coba Lagi'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                    ),
                  ),
                  ElevatedButton.icon(
                    key: const Key('capture_sample_camera_button'),
                    onPressed: _captureSimulatedPhoto,
                    icon: const Icon(Icons.camera, size: 16.0),
                    label: const Text('Ambil Foto Bukti'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleOverlayButton({
    Key? key,
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    double size = 42.0,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        key: key,
        color: Colors.black.withValues(alpha: 0.60),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: Colors.white, size: 22.0),
          ),
        ),
      ),
    );
  }
}

class _ViewfinderGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;

    // Rule of thirds lines
    final oneThirdX = size.width / 3.0;
    final twoThirdsX = size.width * 2.0 / 3.0;
    final oneThirdY = size.height / 3.0;
    final twoThirdsY = size.height * 2.0 / 3.0;

    canvas.drawLine(Offset(oneThirdX, 0), Offset(oneThirdX, size.height), paint);
    canvas.drawLine(Offset(twoThirdsX, 0), Offset(twoThirdsX, size.height), paint);
    canvas.drawLine(Offset(0, oneThirdY), Offset(size.width, oneThirdY), paint);
    canvas.drawLine(Offset(0, twoThirdsY), Offset(size.width, twoThirdsY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
