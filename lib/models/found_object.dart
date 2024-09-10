class FoundObject {
  final String type; // Type d'objet (ex: "sac", "téléphone", etc.)
  final String station; // Gare où l'objet a été trouvé
  final DateTime dateFound; // Date à laquelle l'objet a été trouvé
  final DateTime? dateRestituted; // Date de restitution de l'objet (nullable)

  FoundObject({
    required this.type,
    required this.station,
    required this.dateFound,
    this.dateRestituted,
  });

  // Méthode pour convertir un JSON (de l'API) en un objet FoundObject
  factory FoundObject.fromJson(Map<String, dynamic> json) {
    return FoundObject(
      type: json['gc_obo_type_c'] as String,
      station: json['gc_obo_gare_origine_r_name'] as String,
      dateFound:
          DateTime.parse(json['gc_obo_date_heure_restitution_c'] as String),
      dateRestituted: json['gc_obo_date_heure_restitution_r_c'] != null
          ? DateTime.parse(json['gc_obo_date_heure_restitution_r_c'] as String)
          : null,
    );
  }
}
