class Contact {
  final int id;
  final String name;
  final String phone;
  final String email;
  final bool isFavorite;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.isFavorite = false
  });
}
