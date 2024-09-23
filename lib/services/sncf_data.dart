import 'dart:convert';
import 'package:myapp/models/found_object.dart';
import 'package:http/http.dart' as http;

class SncfData {
  final String apiUrl =
      'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records';
  final String lastFounded = "?order_by=date%20DESC&limit=20";

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
    // Construction dynamique de l'URL avec les filtres
    String query = '$apiUrl&sort=date%20DESC';

    if (stationName != null && stationName.isNotEmpty) {
      query += '&q=gc_obo_gare_origine_r_name:$stationName';
    }
    if (objectType != null && objectType.isNotEmpty) {
      query += '%20AND%20gc_obo_type_c:$objectType';
    }
    if (dateMin != null) {
      final dateMinStr = dateMin.toIso8601String();
      query += '%20AND%20date>=$dateMinStr';
    }
    if (dateMax != null) {
      final dateMaxStr = dateMax.toIso8601String();
      query += '%20AND%20date<=$dateMaxStr';
    }

    final response = await http.get(Uri.parse(query));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['records'];
      return data.map((item) => FoundObject.fromJson(item['fields'])).toList();
    }
    throw Exception('Failed to search found objects');
  }
}
