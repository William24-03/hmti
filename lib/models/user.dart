class User {
  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? bio;
  final String? website;

  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.bio,
    this.website,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      bio: json['bio']?.toString(),
      website: json['website']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (website != null) 'website': website,
    };
  }
}
