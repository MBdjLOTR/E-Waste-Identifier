import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiKey = 'AIzaSyA64zou9i6ctD2qIjc5PKIQJk3EZxm_d2k'; // Replace with your Google API key
  final String searchEngineId = '808c3b84529b144d9'; // Replace with your search engine ID (CX)

  Future<Map<String, dynamic>> fetchEwasteInfo(String query) async {
    // Construct the API URL
    final url = Uri.parse(
      'https://www.googleapis.com/customsearch/v1?q=$query&key=$apiKey&cx=$searchEngineId',
    );

    // Make the GET request to the Google Custom Search API
    final response = await http.get(url);

    // Handle the response
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data; // Return the JSON data as a Map
    } else {
      throw Exception('Failed to fetch e-waste information');
    }
  }
}