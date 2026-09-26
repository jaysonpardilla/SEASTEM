import 'dart:io';

import 'package:flutter/material.dart';

import '../models/scan_result.dart';
import '../models/shell_reference.dart';
import 'home_screen.dart';
import 'scan_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.scanResult});

  final ScanResult scanResult;

  @override
  Widget build(BuildContext context) {
    final imageFile = File(scanResult.imageUrl);
    final confidenceLabel =
        '${(scanResult.confidence * 100).toStringAsFixed(1)}%';
    final isRecognized = scanResult.confidence >= 0.60;
    final displayedClassName = isRecognized ? scanResult.label : 'Unrecognized';
    final shellReference = shellReferenceFor(
      scanResult.prediction,
      scanResult.label,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2D4D),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Identification Results',
          style: TextStyle(
            color: Color(0xFFFAF8F2),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Shell Image
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EEDC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0B2D4D), width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child:
                      imageFile.existsSync()
                          ? Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'lib/assets/images/logo.png',
                                fit: BoxFit.contain,
                              );
                            },
                          )
                          : Image.asset(
                            'lib/assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                ),
              ),
              const SizedBox(height: 20),

              // Shell Name and Confidence
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EEDC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            displayedClassName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0B2D4D),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF8F2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE8D8B8)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Confidence',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF163E5C),
                                ),
                              ),
                              Text(
                                confidenceLabel,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0B2D4D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (isRecognized && shellReference != null) ...[
                _buildReferenceSection(shellReference),
                const SizedBox(height: 24),
              ],

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2D4D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Scan Again',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFAF8F2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2D4D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFAF8F2),
                        ),
                      ),
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

  Widget _buildReferenceSection(ShellReference reference) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8D8B8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this species',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0B2D4D),
            ),
          ),
          _referenceItem('Main habitat and where found', reference.habitat),
          const SizedBox(height: 12),
          _referenceItem('Edibility', reference.edibility),
          const SizedBox(height: 12),
          _referenceItem('Recommended dishes', reference.recommendedDish),
          const SizedBox(height: 12),
          _referenceItem('Safety awareness', reference.safety),
        ],
      ),
    );
  }

  Widget _referenceItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF163E5C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 13,
            height: 1.4,
            color: Color(0xFF1F2933),
          ),
        ),
      ],
    );
  }
}
