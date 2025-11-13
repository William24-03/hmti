class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final String? image;
  final String? createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    this.image,
    this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      image: _parseImageUrl(json['image']),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content, 'author': author};
  }
}

/// ✅ Helper function untuk memastikan image valid
String? _parseImageUrl(dynamic value) {
  if (value == null) return null;
  final str = value.toString();

  // Jika isinya HTML (dimulai dengan "<!DOCTYPE") -> return null biar tidak error
  if (str.startsWith('<!DOCTYPE') || str.startsWith('<html')) {
    return null;
  }

  // Jika bukan URL penuh, tambahkan base URL kamu
  if (!str.startsWith('http')) {
    return 'https://hmti-news.hppms-sabala.my.id/storage/$str';
  }

  return str;
}
