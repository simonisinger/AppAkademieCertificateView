import 'dart:convert';
import 'dart:typed_data';

import 'package:app_akademie_certificate_lib/app_akademie_certificate_lib.dart';
import 'package:app_akademie_certificate_view/generated/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart';

class CertificateDataCheck extends StatelessWidget {
  final String base64UrlData;
  final String signature;
  final RSAPublicKey publicKey;
  final String digestIdentifierHex;
  const CertificateDataCheck({
    super.key,
    required this.base64UrlData,
    required this.publicKey,
    required this.digestIdentifierHex,
    required this.signature,
  });

  @override
  Widget build(BuildContext context) {
    final Base64Codec base64Url = Base64Codec.urlSafe();
    Uint8List data = base64Url.decode(base64UrlData);
    bool validation = CertificateCrypto().validate(
      publicKey,
      data,
      base64Url.decode(signature),
      digestIdentifierHex,
    );

    AppLocalizations localizations = AppLocalizations.of(context)!;
    Certificate certificate = Certificate.fromBuffer(data);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  validation
                      ? [
                        const Color(0xFF4CAF50).withAlpha(26), // 0.1 * 255 ≈ 26
                        const Color(
                          0xFF8BC34A,
                        ).withAlpha(13), // 0.05 * 255 ≈ 13
                      ]
                      : [
                        const Color(0xFFF44336).withAlpha(26), // 0.1 * 255 ≈ 26
                        const Color(
                          0xFFE91E63,
                        ).withAlpha(13), // 0.05 * 255 ≈ 13
                      ],
            ),
            border: Border.all(
              color:
                  validation
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (validation
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF44336))
                    .withAlpha(77), // 0.3 * 255 ≈ 77
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Status Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      validation
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                ),
                child: Icon(
                  validation ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),

              // Status Text
              Text(
                validation
                    ? localizations.validQrCode
                    : localizations.invalidQrCode,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      validation
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Certificate Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF404040), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zertifikat Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withAlpha(230), // 0.9 * 255 ≈ 230
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      label: 'Name',
                      value: certificate.name,
                    ),

                    const SizedBox(height: 12),

                    // Certificate Number
                    _buildDetailRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Zertifikatsnummer',
                      value: certificate.certificateNumber,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white.withAlpha(179),
          size: 20,
        ), // 0.7 * 255 ≈ 179
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(153), // 0.6 * 255 ≈ 153
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withAlpha(230), // 0.9 * 255 ≈ 230
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
