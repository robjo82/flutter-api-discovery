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
}
