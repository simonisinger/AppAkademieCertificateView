// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get invalidQrCode => 'The scanned QR Code is invalid';

  @override
  String get validQrCode => 'The scanned QR Code is valid';

  @override
  String certificateName(String name) {
    return 'Name: $name';
  }

  @override
  String certificateNumber(String number) {
    return 'Certificate number: $number';
  }

  @override
  String get scanQrCodeTitle => 'Scan QR Code';

  @override
  String get scanQrCodeInstruction =>
      'Please scan the QR code of an App Akademie certificate with your phone\'s camera.';

  @override
  String get noQrCodeProvided => 'No QR code provided';
}
