import 'package:ig_agency_app/flavor_settings.dart';

extension StringBaseUrlExtension on String? {
  String withBaseUrl() {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return '${FlavorSettings().baseUrl}/$this';
  }
}
