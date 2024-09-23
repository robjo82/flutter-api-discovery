class FoundObject {
  final DateTime date; // Date à laquelle l'objet a été trouvé
  final DateTime? dateRestituted; // Date de restitution de l'objet (nullable)
  final String? stationName; // Nom de la gare d'origine
  final String? stationCode; // Code UIC de la gare
  final String nature; // Nature de l'objet (ex: "Appareil audio portable")
  final String type; // Type de l'objet (ex: "Appareils électroniques")
  final String recordType; // Type d'enregistrement (ex: "Objet trouvé")

  FoundObject({
    required this.date,
    this.dateRestituted,
    required this.stationName,
    required this.stationCode,
    required this.nature,
    required this.type,
    required this.recordType,
  });

  // Méthode pour convertir un JSON en un objet FoundObject
  factory FoundObject.fromJson(Map<String, dynamic> json) {
    return FoundObject(
      date: DateTime.parse(json['date'] as String),
      dateRestituted: json['gc_obo_date_heure_restitution_c'] != null
          ? DateTime.parse(json['gc_obo_date_heure_restitution_c'] as String)
          : null,
      stationName: json['gc_obo_gare_origine_r_name'] as String?,
      stationCode: json['gc_obo_gare_origine_r_code_uic_c'] as String?,
      nature: json['gc_obo_nature_c'] as String,
      type: json['gc_obo_type_c'] as String,
      recordType: json['gc_obo_nom_recordtype_sc_c'] as String,
    );
  }
}
