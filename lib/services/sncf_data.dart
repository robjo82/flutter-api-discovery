import 'dart:convert';
import 'package:myapp/models/found_object.dart';
import 'package:http/http.dart' as http;

class SncfData {
  final String apiUrl =
      'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records';
  final String lastFounded = "?order_by=date%20DESC&limit=100";

  Future<List<FoundObject>> fetchFoundObjects() async {
    final response = await http.get(Uri.parse(apiUrl + lastFounded));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((item) => FoundObject.fromJson(item)).toList();
    }
    throw Exception('Failed to load found objects');
  }

  // Rechercher des objets trouvés selon les filtres
  Future<List<FoundObject>> searchFoundObjects({
    String? stationName, // Filtrer par nom de la gare
    String? objectType, // Filtrer par type d'objet
    DateTime? dateMin, // Filtrer par date minimale
    DateTime? dateMax, // Filtrer par date maximale
  }) async {
    String whereClause = '';

    // Ajoute le filtre par gare
    if (stationName != null && stationName.isNotEmpty) {
      whereClause +=
          'gc_obo_gare_origine_r_name%20%3D%20%22${Uri.encodeComponent(stationName)}%22';
    }

    // Ajoute le filtre par date min
    if (dateMin != null) {
      final dateMinStr =
          '${dateMin.day.toString().padLeft(2, '0')}/${dateMin.month.toString().padLeft(2, '0')}/${dateMin.year}';
      if (whereClause.isNotEmpty) whereClause += '%20AND%20';
      whereClause += 'date%20%3E%3D%20%22$dateMinStr%22';
    }

    // Ajoute le filtre par date max
    if (dateMax != null) {
      final dateMaxStr =
          '${dateMax.day.toString().padLeft(2, '0')}/${dateMax.month.toString().padLeft(2, '0')}/${dateMax.year}';
      if (whereClause.isNotEmpty) whereClause += '%20AND%20';
      whereClause += 'date%20%3C%3D%20%22$dateMaxStr%22';
    }
    // Construction de l'URL finale avec le tri par date décroissante et la limite
    String finalUrl =
        '$apiUrl?where=$whereClause&order_by=date%20DESC&limit=100';

    // Effectue la requête HTTP
    final response = await http.get(Uri.parse(finalUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((item) => FoundObject.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des objets trouvés');
    }
  }
}
