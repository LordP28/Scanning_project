import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_appli/services/api_service.dart';
import 'package:scan_appli/screens/result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanning = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      isScanning = false;
      _verifyStudent(barcodes.first.rawValue ?? '');
    }
  }

  Future<void> _verifyStudent(String studentId) async {
    try {
      final student = await ApiService.verifyStudent(studentId);
      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(student: student),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: _onDetect,
                ),
                CustomPaint(
                  painter: ScannerOverlay(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Position the QR code within the frame',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  final Color color;

  ScannerOverlay({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final width = size.width;
    final height = size.height;
    final scanArea = 300.0;
    final left = (width - scanArea) / 2;
    final top = (height - scanArea) / 2;

    // Draw border
    canvas.drawRect(
      Rect.fromLTWH(left, top, scanArea, scanArea),
      paint,
    );

    // Draw corners
    final cornerLength = 30.0;
    final cornerWidth = 10.0;

    // Top left corner
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      paint..strokeWidth = cornerWidth,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      paint..strokeWidth = cornerWidth,
    );

    // Top right corner
    canvas.drawLine(
      Offset(left + scanArea, top),
      Offset(left + scanArea - cornerLength, top),
      paint..strokeWidth = cornerWidth,
    );
    canvas.drawLine(
      Offset(left + scanArea, top),
      Offset(left + scanArea, top + cornerLength),
      paint..strokeWidth = cornerWidth,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(left, top + scanArea),
      Offset(left + cornerLength, top + scanArea),
      paint..strokeWidth = cornerWidth,
    );
    canvas.drawLine(
      Offset(left, top + scanArea),
      Offset(left, top + scanArea - cornerLength),
      paint..strokeWidth = cornerWidth,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(left + scanArea, top + scanArea),
      Offset(left + scanArea - cornerLength, top + scanArea),
      paint..strokeWidth = cornerWidth,
    );
    canvas.drawLine(
      Offset(left + scanArea, top + scanArea),
      Offset(left + scanArea, top + scanArea - cornerLength),
      paint..strokeWidth = cornerWidth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 