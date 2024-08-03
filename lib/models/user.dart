class User {
  String id;
  String name;
  String email;
  String role;
  String? profilePhoto;
  User(
      {required this.id,
      required this.name,
      required this.role,
      required this.email,
      this.profilePhoto});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'].toString(),
        name: json['name'].toString(),
        email: json['email'].toString(),
        role: json['role'].toString(),
        profilePhoto: json['profile_photo']);
  }
  String get profilePhotoUrl {
    if (profilePhoto != null) {
      return 'http://10.0.2.2:8000/storage/$profilePhoto';
    }
    return '';
  }
}
