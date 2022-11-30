import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrproject/screens/results_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;

  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        buildQrView(context),
        Positioned(
            bottom: 20,
            child: ElevatedButton(
              child: const Text('submit'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ResultScreen(text: ' ${barcode!.code}'))),
            )),
        Positioned(bottom: 10, child: buildResult())
      ]),
    );
  }

  Widget buildResult() => Text(
        barcode != null ? 'Result : ${barcode!.code}' : 'Scan code',
        maxLines: 2,
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderWidth: 10,
            borderLength: 20,
            borderRadius: 20,
            borderColor: Colors.blue),
      );

  void onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));

    setState(() => this.controller = controller);
  }
}
