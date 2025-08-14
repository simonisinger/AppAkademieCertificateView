import 'dart:convert';
import 'dart:typed_data';

import 'package:app_akademie_certificate_lib/app_akademie_certificate_lib.dart';
import 'package:app_akademie_certificate_view/generated/i18n/app_localizations.dart';
import 'package:app_akademie_certificate_view/main.dart';
import 'package:app_akademie_certificate_view/responsive_center.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide Padding, State;

class CertificateDataCheck extends StatefulWidget {
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
  State<CertificateDataCheck> createState() => _CertificateDataCheckState();
}

class _CertificateDataCheckState extends State<CertificateDataCheck> {
  bool _showDetails = false;
  @override
  Widget build(BuildContext context) {
    bool validation = false;
    AppLocalizations localizations = AppLocalizations.of(context)!;
    Certificate? certificate;

    try {
      final Base64Codec base64Url = Base64Codec.urlSafe();
      Uint8List data = base64Url.decode(widget.base64UrlData);
      certificate = Certificate.fromBuffer(data);
      validation = CertificateCrypto().validate(
        widget.publicKey,
        data,
        base64Url.decode(widget.signature),
        widget.digestIdentifierHex,
      );
    } catch (e) {
      validation = false;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: ResponsiveCenter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          validation
                              ? [
                                const Color(
                                  0xFF4CAF50,
                                ).withAlpha(26), // 0.1 * 255 ≈ 26
                                const Color(
                                  0xFF8BC34A,
                                ).withAlpha(13), // 0.05 * 255 ≈ 13
                              ]
                              : [
                                const Color(
                                  0xFFF44336,
                                ).withAlpha(26), // 0.1 * 255 ≈ 26
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
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF404040),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zertifikat Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withAlpha(
                                  230,
                                ), // 0.9 * 255 ≈ 230
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Name
                            _buildDetailRow(
                              icon: Icons.person_outline,
                              label: 'Name',
                              value: certificate?.name ?? 'N/A',
                            ),

                            const SizedBox(height: 12),

                            // Certificate Number
                            _buildDetailRow(
                              icon: Icons.confirmation_number_outlined,
                              label: 'Zertifikatsnummer',
                              value: certificate?.certificateNumber ?? 'N/A',
                            ),

                            const SizedBox(height: 12),

                            // Certificate Type
                            _buildDetailRow(
                              icon: Icons.verified_outlined,
                              label: 'Typ',
                              value:
                                  certificate?.isCompletion == true
                                      ? localizations.completionCertificate
                                      : localizations.participationConfirmation,
                            ),

                            const SizedBox(height: 12),

                            // Training Start
                            _buildDetailRow(
                              icon: Icons.play_arrow_outlined,
                              label: 'Kursstart',
                              value:
                                  _formatDate(certificate?.trainingStart) ??
                                  'N/A',
                            ),

                            const SizedBox(height: 12),

                            // Training End
                            _buildDetailRow(
                              icon: Icons.stop_outlined,
                              label: 'Kurssende',
                              value:
                                  _formatDate(certificate?.trainingEnd) ??
                                  'N/A',
                            ),

                            // Expandable Details Button
                            if (validation &&
                                certificate?.isCompletion == true &&
                                ((certificate?.modules != null &&
                                        certificate!.modules.isNotEmpty) ||
                                    (certificate?.badges != null &&
                                        certificate!.badges.isNotEmpty))) ...[
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _showDetails = !_showDetails;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3A3A3A),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF4CAF50,
                                      ).withAlpha(128),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _showDetails
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Colors.white.withAlpha(179),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _showDetails
                                              ? 'Details verstecken'
                                              : _buildSummaryText(certificate),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withAlpha(230),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            // Modules (only show if validation successful, isCompletion is true, modules exist, and details are expanded)
                            if (validation &&
                                certificate?.isCompletion == true &&
                                _showDetails &&
                                certificate?.modules != null &&
                                certificate!.modules.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _buildModulesSection(certificate.modules),
                            ],

                            // Badges (only show if validation successful, isCompletion is true, badges exist, and details are expanded)
                            if (validation &&
                                certificate?.isCompletion == true &&
                                _showDetails &&
                                certificate?.badges != null &&
                                certificate!.badges.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _buildBadgesSection(certificate.badges),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                const SizedBox(height: 64),

                // Credits Section - Outside main container
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF333333),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    localizations.credits,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(153), // 0.6 * 255 ≈ 153
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildSummaryText(Certificate? certificate) {
    List<String> parts = [];

    if (certificate?.modules != null && certificate!.modules.isNotEmpty) {
      final moduleCount = certificate.modules.length;
      parts.add('$moduleCount/$totalModules Modulen');
    } else {
      parts.add('0/$totalModules Modulen');
    }

    if (certificate?.badges != null && certificate!.badges.isNotEmpty) {
      final badgeCount = certificate.badges.length;
      parts.add('$badgeCount/$totalBadges Badges');
    } else {
      parts.add('0/$totalBadges Badges');
    }

    return parts.join(', ');
  }

  String? _formatDate(dynamic date) {
    if (date == null) return null;

    try {
      // If date is already a string, try to parse it
      if (date is String) {
        try {
          final parsedDate = DateTime.parse(date);
          return '${parsedDate.day.toString().padLeft(2, '0')}.${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.year}';
        } catch (e) {
          return date;
        }
      }

      // If date is a DateTime object, format it
      if (date is DateTime) {
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      }

      // Try toDateTime method for protobuf Timestamp objects
      try {
        final dateTime = date.toDateTime();
        return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
      } catch (e) {
        // Fallback to string parsing
        final str = date.toString();
        final secondsMatch = RegExp(r'seconds:\s*(\d+)').firstMatch(str);
        if (secondsMatch != null) {
          final seconds = int.parse(secondsMatch.group(1)!);
          final dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
          return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
        }
      }

      return 'N/A';
    } catch (e) {
      return 'N/A';
    }
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

  Widget _buildModulesSection(dynamic modules) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.school_outlined,
                color: Colors.white.withAlpha(179),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Module',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(153),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...modules.map<Widget>((module) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withAlpha(128),
                  width: 1,
                ),
              ),
              child: Text(
                module.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(230),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(dynamic badges) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.military_tech_outlined,
                color: Colors.white.withAlpha(179),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Badges',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(153),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...badges.map<Widget>((badge) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFFD700).withAlpha(128),
                  width: 1,
                ),
              ),
              child: Text(
                badge.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(230),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
