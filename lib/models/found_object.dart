import 'dart:convert';
import 'package:crypto/crypto.dart';

class FoundObject {
  final DateTime date;
  final DateTime? dateReturned;
  final String? stationName;
  final String? stationCode;
  final String nature;
  final String type;
  final String recordType;

  FoundObject({
    required this.date,
    this.dateReturned,
    required this.stationName,
    required this.stationCode,
    required this.nature,
    required this.type,
    required this.recordType,
  });

  factory FoundObject.fromJson(Map<String, dynamic> json) {
    return FoundObject(
      date: DateTime.parse(json['date'] as String),
      dateReturned: json['gc_obo_date_heure_restitution_c'] != null
          ? DateTime.parse(json['gc_obo_date_heure_restitution_c'] as String)
          : null,
      stationName: json['gc_obo_gare_origine_r_name'] as String?,
      stationCode: json['gc_obo_gare_origine_r_code_uic_c'] as String?,
      nature: json['gc_obo_nature_c'] as String,
      type: json['gc_obo_type_c'] as String,
      recordType: json['gc_obo_nom_recordtype_sc_c'] as String,
    );
  }

  String getUniqueId() {
    final String rawId =
        '${date.toIso8601String()}|$stationName|$nature|$type';

    final bytes = utf8.encode(rawId);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }
}
