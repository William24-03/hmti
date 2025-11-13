import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String baseUrl = 'https://hmti-news.hppms-sabala.my.id';
  static const Map<String, String> headers = {'Accept': 'application/json'};

  /// GET semua post
  static Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$baseUrl/api/posts');
    final res = await http.get(uri, headers: headers);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final data = body is List ? body : (body['data'] ?? []);
      return data.map<Post>((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Gagal ambil posts: ${res.statusCode}');
    }
  }

  /// GET post by ID
  static Future<Post> fetchPost(int id) async {
    final uri = Uri.parse('$baseUrl/api/posts/$id');
    final res = await http.get(uri, headers: headers);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final data = body is Map ? (body['data'] ?? body) : body;
      return Post.fromJson(data);
    } else {
      throw Exception('Post tidak ditemukan (${res.statusCode})');
    }
  }

  /// DELETE post
  static Future<void> deletePost(int id) async {
    final uri = Uri.parse('$baseUrl/api/posts/$id');
    final res = await http.delete(uri, headers: headers);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Gagal hapus post (${res.statusCode})');
    }
  }

  /// POST buat post baru (multipart)
  static Future<Post> createPost({
    required String title,
    required String content,
    required String author,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/api/posts');
    final req = http.MultipartRequest('POST', uri);
    req.headers.addAll(headers);
    req.fields['title'] = title;
    req.fields['content'] = content;
    req.fields['author'] = author;

    if (imageFile != null) {
      final multipart = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      );
      req.files.add(multipart);
    }

    final res = await req.send();
    final resp = await http.Response.fromStream(res);

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final data = body is Map ? (body['data'] ?? body) : body;
      return Post.fromJson(data);
    } else {
      throw Exception('Gagal buat post (${resp.statusCode}) ${resp.body}');
    }
  }

  /// PUT update post
  static Future<Post> updatePost({
    required int id,
    required String title,
    required String content,
    required String author,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/api/posts/$id');
    final req = http.MultipartRequest('POST', uri);
    req.headers.addAll(headers);
    req.fields['_method'] = 'PUT'; // Laravel trick
    req.fields['title'] = title;
    req.fields['content'] = content;
    req.fields['author'] = author;

    if (imageFile != null) {
      final multipart = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      );
      req.files.add(multipart);
    }

    final res = await req.send();
    final resp = await http.Response.fromStream(res);

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final data = body is Map ? (body['data'] ?? body) : body;
      return Post.fromJson(data);
    } else {
      throw Exception('Gagal update post (${resp.statusCode}) ${resp.body}');
    }
  }
}
