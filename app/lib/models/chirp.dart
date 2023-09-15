class Chirp {
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  Chirp({
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chirp.fromJson(Map<String, dynamic> json) {
    return Chirp(
      message: json['message'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
