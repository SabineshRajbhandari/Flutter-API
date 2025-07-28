import 'package:dio/dio.dart';
import 'package:statement/models/post_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) {
          return Post.fromJson(e);
        }).toList();
      } else {
        throw Exception("Status code is not 200!");
      }
    } catch (e) {
      throw Exception("Something went wrong!");
    }
  }

  static Future<void> createPost(Post post) async {
    try {
      final response = await _dio.post('/posts', data: post.toJson());
      if (response.statusCode != 201) {
        throw Exception("Somethign went wrong!");
      }
    } catch (e) {
      throw Exception("Somethign went wrong!");
    }
  }
}
