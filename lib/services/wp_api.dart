// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<List> fetchWpPosts() async {
//   final response = await http.get(
//       'http://www.kisara.or.id/wp-json/wp/v2/posts?_embed',
//       headers: {"Accept": "application/json"});
//   var convertDatatoJson = jsonDecode(response.body);
//   return convertDatatoJson;
// }

String baseUrl = "http://www.kisara.or.id/wp-json/wp/v2/posts?_embed";
// String baseUrl =
//     "https://public-api.wordpress.com/rest/v1.1/sites/cybdom.tech/posts";
