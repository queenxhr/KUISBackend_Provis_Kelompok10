import 'package:kuis_backend_kel10/item.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL untuk mendapatkan token
  static const String tokenUrl = 'http://146.190.109.66:8000/token';
  // URL untuk mendapatkan item
  static const String itemUrl = 'http://146.190.109.66:8000/items/?skip=0&limit=100';

  // Properti untuk menyimpan token
  late String token;

  // Fungsi untuk mendapatkan token
  Future<void> getToken({required String username, required String password}) async {
    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      token = responseData['access_token'];
    } else {
      throw Exception('Failed to get token');
    }
  }

  // Fungsi untuk mengambil item dengan token yang disertakan
  Future<List<Item>> fetchItems() async {
    // Periksa jika token sudah ada atau tidak, jika tidak ada, minta token terlebih dahulu
    if (token.isEmpty) {
      await getToken(username: 'queenxhr', password: 'hellopanda');
    }

    final response = await http.get(
      Uri.parse(itemUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Jika berhasil, parse data dan kembalikan list item
      return parseItems(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }

  // Fungsi untuk mengubah data JSON menjadi list item
  List<Item> parseItems(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Item>((json) => Item.fromJson(json)).toList();
  }
}
// class ApiService {
//   final Dio dio = Dio();
//   final String baseUrl = 'http://146.190.109.66:8000';

//   Future<List<Item>> fetchItems() async {
//     try {
//       final response = await dio.get('$baseUrl/items');
//       return (response.data as List)
//           .map((itemJson) => Item.fromJson(itemJson))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to fetch items');
//     }
//   }
// }

// class ApiService {
//   static const String baseUrl = 'http://146.190.109.66:8000';

//   Future<List<Item>> fetchItems() async {
//     final response = await http.get(
//       // Uri.parse('$baseUrl/items/'),
//       Uri.parse('$baseUrl/items/?skip=0&limit=100'),
//       //headers: {'accept': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       // final List<Map<String, dynamic>> jsonData = json.decode(response.body).cast<Map<String, dynamic>>();
//       List<dynamic> jsonData = jsonDecode(response.body);
//       return jsonData.map((json) => Item.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load items');
//     }
//   }
// }

// class ApiService {

//   void fetchItems() async {
//     const baseUrl = 'http://146.190.109.66:8000';
//     final uri = Uri.parse(baseUrl); 
//     final response = await http.get(
//       // Uri.parse('$baseUrl/items/'),
//       uri);
//       //headers: {'accept': 'application/json'},
//       final body = response.body;
//       final json = jsonDecode(body);
//       setState((){
//         users = json['']
//       });
//     // );

//     // if (response.statusCode == 200) {
//     //   // final List<Map<String, dynamic>> jsonData = json.decode(response.body).cast<Map<String, dynamic>>();
//     //   List<dynamic> jsonData = jsonDecode(response.body);
//     //   return jsonData.map((json) => Item.fromJson(json)).toList();
//     // } else {
//     //   throw Exception('Failed to load items');
//     // }
//   }
// }
