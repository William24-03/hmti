class Book {
  final int id;
  final String title;
  final String author;
  final String description;
  final String? createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'author': author, 'description': description};
  }
}
