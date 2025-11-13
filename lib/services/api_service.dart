import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/book.dart';
import '../models/news.dart';
import '../models/user.dart';

class ApiService {
  // BASE URL (sesuaikan bila perlu)
  static const String baseUrl = 'https://hppms-sabala.my.id/api';

  // --- Auth helpers ---
  static Future<void> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('token', token);
  }

  static Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('token');
  }

  static Future<void> removeToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('token');
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    final headers = {'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ================= AUTH =================
  // register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final uri = Uri.parse('$baseUrl/register');
    final res = await http.post(
      uri,
      body: {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (phone != null) 'phone': phone,
      },
      headers: {'Accept': 'application/json'},
    );

    final body = json.decode(res.body);
    if (res.statusCode == 201 || res.statusCode == 200) {
      // API docs indicate data.token might be present
      final token = (body['data'] != null && body['data']['token'] != null)
          ? body['data']['token']
          : (body['token'] ?? null);
      if (token != null) await saveToken(token);
      return body;
    } else {
      throw Exception(body);
    }
  }

  // login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/login');
    final res = await http.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    final body = json.decode(res.body);
    if (res.statusCode == 200) {
      // save token if present under data.token or token
      String? token;
      if (body['data'] != null && body['data']['token'] != null) {
        token = body['data']['token'];
      } else if (body['token'] != null) {
        token = body['token'];
      }
      if (token != null) await saveToken(token);
      return body;
    } else {
      throw Exception(body);
    }
  }

  // logout
  static Future<void> logout() async {
    final uri = Uri.parse('$baseUrl/logout');
    final headers = await _authHeaders();
    final res = await http.post(uri, headers: headers);
    if (res.statusCode == 200) {
      await removeToken();
    } else {
      throw Exception('Logout gagal: ${res.statusCode}');
    }
  }

  // ================= BOOKS =================
  static Future<List<Book>> fetchBooks({int page = 1}) async {
    final uri = Uri.parse('$baseUrl/books?page=$page');
    final headers = await _authHeaders();
    final res = await http.get(uri, headers: headers);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final list = (body is List) ? body : (body['data'] ?? body);
      return (list as List).map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception('Gagal ambil books: ${res.statusCode}');
    }
  }

  static Future<Book> getBook(int id) async {
    final uri = Uri.parse('$baseUrl/books/$id');
    final headers = await _authHeaders();
    final res = await http.get(uri, headers: headers);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final data = (body is Map && body['data'] != null) ? body['data'] : body;
      return Book.fromJson(data);
    } else {
      throw Exception('Gagal ambil book: ${res.statusCode}');
    }
  }

  static Future<Book> createBook({
    required String title,
    required String author,
    required String description,
  }) async {
    final uri = Uri.parse('$baseUrl/books');
    final headers = await _authHeaders();
    final res = await http.post(
      uri,
      headers: headers,
      body: {'title': title, 'author': author, 'description': description},
    );

    final body = json.decode(res.body);
    if (res.statusCode == 201 || res.statusCode == 200) {
      final data = body['data'] ?? body;
      return Book.fromJson(data);
    } else {
      throw Exception(body);
    }
  }

  static Future<Book> updateBook({
    required int id,
    required String title,
    required String author,
    required String description,
  }) async {
    final uri = Uri.parse('$baseUrl/books/$id');
    final headers = await _authHeaders();
    // Some APIs accept PUT, some accept POST with _method=PUT
    final res = await http.put(
      uri,
      headers: {...headers, 'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'author': author,
        'description': description,
      }),
    );

    final body = json.decode(res.body);
    if (res.statusCode == 200) {
      final data = body['data'] ?? body;
      return Book.fromJson(data);
    } else {
      throw Exception(body);
    }
  }

  static Future<void> deleteBook(int id) async {
    final uri = Uri.parse('$baseUrl/books/$id');
    final headers = await _authHeaders();
    final res = await http.delete(uri, headers: headers);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Gagal menghapus book: ${res.statusCode}');
    }
  }

  // ================= NEWS =================
  static Future<List<News>> fetchNews({int page = 1, int perPage = 10}) async {
    final uri = Uri.parse('$baseUrl/news?page=$page&per_page=$perPage');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final list = (body is List) ? body : (body['data'] ?? body);
      return (list as List).map((e) => News.fromJson(e)).toList();
    } else {
      throw Exception('Gagal ambil news: ${res.statusCode}');
    }
  }

  static Future<News> getNews(int id) async {
    final uri = Uri.parse('$baseUrl/news/$id');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final data = body['data'] ?? body;
      return News.fromJson(data);
    } else {
      throw Exception('Gagal ambil news: ${res.statusCode}');
    }
  }

  // create news (multipart with image)
  static Future<News> createNews({
    required String title,
    required String description,
    required String author,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/news');
    final token = await getToken();
    final req = http.MultipartRequest('POST', uri);
    req.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    req.fields['title'] = title;
    req.fields['description'] = description;
    req.fields['author'] = author;

    if (imageFile != null) {
      final file = await http.MultipartFile.fromPath('image', imageFile.path);
      req.files.add(file);
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    final body = json.decode(res.body);

    if (res.statusCode == 201 || res.statusCode == 200) {
      final data = body['data'] ?? body;
      return News.fromJson(data);
    } else {
      throw Exception(body);
    }
  }

  static Future<News> updateNews({
    required int id,
    required String title,
    required String description,
    required String author,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/news/$id');
    final token = await getToken();
    final req = http.MultipartRequest('POST', uri);
    req.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    req.fields['_method'] = 'PUT';
    req.fields['title'] = title;
    req.fields['description'] = description;
    req.fields['author'] = author;
    if (imageFile != null) {
      final f = await http.MultipartFile.fromPath('image', imageFile.path);
      req.files.add(f);
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    final body = json.decode(res.body);

    if (res.statusCode == 200) {
      final data = body['data'] ?? body;
      return News.fromJson(data);
    } else {
      throw Exception(body);
    }
  }

  static Future<void> deleteNews(int id) async {
    final uri = Uri.parse('$baseUrl/news/$id');
    final token = await getToken();
    final headers = {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final res = await http.delete(uri, headers: headers);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Gagal hapus news: ${res.statusCode}');
    }
  }

  // ================= PROFILE =================
  static Future<User> getProfile() async {
    final uri = Uri.parse('$baseUrl/profile');
    final headers = await _authHeaders();
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final data = body['data'] ?? body;
      return User.fromJson(data);
    } else {
      throw Exception('Gagal ambil profile: ${res.statusCode}');
    }
  }

  static Future<User> updateProfile(User user) async {
    final uri = Uri.parse('$baseUrl/profile');
    final headers = await _authHeaders();
    final res = await http.put(
      uri,
      headers: {...headers, 'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    final body = json.decode(res.body);
    if (res.statusCode == 200) {
      final data = body['data'] ?? body;
      return User.fromJson(data);
    } else {
      throw Exception(body);
    }
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final uri = Uri.parse('$baseUrl/profile/change-password');
    final headers = await _authHeaders();
    final res = await http.post(
      uri,
      headers: {...headers, 'Content-Type': 'application/json'},
      body: json.encode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
    );
    if (res.statusCode != 200) {
      final body = json.decode(res.body);
      throw Exception(body);
    }
  }

  static Future<void> deletePost(int id) async {}

  static Future<void> updatePost(
      {required int id,
      required String title,
      required String content,
      required String author,
      File? imageFile}) async {}

  static Future<void> createPost(
      {required String title,
      required String content,
      required String author,
      File? imageFile}) async {}
}
