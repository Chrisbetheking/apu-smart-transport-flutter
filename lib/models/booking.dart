class Booking {
  final String id;
  final String title;
  String status;

  Booking({
    required this.id,
    required this.title,
    this.status = 'Reserved',
  });
}
