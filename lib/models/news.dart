class News {
  final int id;
  final String title;
  final String author;
  final String description;
  final String? image;
  final String? createdAt;

  News({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.image,
    this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] != null ? json['image'].toString() : null,
      createdAt: json['created_at']?.toString(),
    );
  }
}
