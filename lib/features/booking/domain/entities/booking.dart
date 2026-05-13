import 'package:equatable/equatable.dart';

/// Status of a property booking.
enum BookingStatus {
  /// Currently active booking.
  active,

  /// Completed/checked-out booking.
  completed,

  /// Refund requested.
  refund,

  /// Cancelled booking.
  cancelled,
}

/// Represents a booking record for a property.
///
/// Domain entity — immutable and framework-agnostic.
class Booking extends Equatable {
  final String id;
  final String propertyName;
  final String propertyImage;
  final String location;
  final String checkIn;
  final String checkOut;
  final String price;
  final BookingStatus status;

  /// Property type label (e.g. "KOST", "HOMESTAY").
  final String propertyType;

  /// Transaction date string (e.g. "20 April 2026").
  final String transactionDate;

  /// Duration of stay (e.g. "1 Bulan", "3 Hari").
  final String duration;

  /// Number of rooms booked.
  final int roomCount;

  /// Rent price per period.
  final String rentPrice;

  /// Optional motorbike package price.
  final String? motorBikePrice;

  /// Service fee.
  final String serviceFee;

  /// Total payment (formatted).
  final String totalPayment;

  /// Timestamp when the seller confirmed tenant arrival.
  /// Used to trigger the 4-hour refund countdown.
  /// `null` means arrival has not been confirmed yet.
  final DateTime? tenantArrivalConfirmedAt;

  const Booking({
    required this.id,
    required this.propertyName,
    required this.propertyImage,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.price,
    required this.status,
    this.propertyType = 'KOST',
    this.transactionDate = '',
    this.duration = '',
    this.roomCount = 1,
    this.rentPrice = '',
    this.motorBikePrice,
    this.serviceFee = '',
    this.totalPayment = '',
    this.tenantArrivalConfirmedAt,
  });

  @override
  List<Object?> get props => [
        id,
        propertyName,
        propertyImage,
        location,
        checkIn,
        checkOut,
        price,
        status,
        propertyType,
        transactionDate,
        duration,
        roomCount,
        rentPrice,
        motorBikePrice,
        serviceFee,
        totalPayment,
        tenantArrivalConfirmedAt,
      ];
}
