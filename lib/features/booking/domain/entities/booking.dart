class Booking {
  final String id;
  final String propertyName;
  final String propertyImage;
  final String location;
  final String checkIn;
  final String checkOut;
  final String price;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.propertyName,
    required this.propertyImage,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.price,
    required this.status,
  });
}

enum BookingStatus {
  active,    // Aktif
  completed, // Selesai
  cancelled, // Dibatalkan
}
