import '../../domain/entities/booking.dart';

/// Local data source that provides mock booking data.
///
/// Will be replaced by a Supabase data source in the future.
class BookingLocalDataSource {
  /// Mock booking records.
  static final List<Booking> bookings = [
    // ── Aktif ──
    Booking(
      id: 'B001',
      propertyName: 'Kost Melati Putri',
      propertyImage:
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=500',
      location: 'Sleman, Yogyakarta',
      checkIn: '20 Apr 2026',
      checkOut: '20 Mei 2026',
      price: 'Rp 1.500.000',
      status: BookingStatus.active,
      propertyType: 'KOST',
      transactionDate: '20 April 2026',
      duration: '1 Bulan',
      roomCount: 1,
      rentPrice: 'Rp 1.000.000',
      motorBikePrice: 'Rp 100.000',
      serviceFee: '10.000',
      totalPayment: 'Rp 1.110.000',
      tenantArrivalConfirmedAt:
          DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Booking(
      id: 'B002',
      propertyName: 'Homestay Malioboro Stay',
      propertyImage:
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=500',
      location: 'Kota Yogyakarta',
      checkIn: '25 Apr 2026',
      checkOut: '27 Apr 2026',
      price: 'Rp 700.000',
      status: BookingStatus.active,
      propertyType: 'HOMESTAY',
      transactionDate: '25 April 2026',
      duration: '3 Hari',
      roomCount: 1,
      rentPrice: 'Rp 650.000',
      serviceFee: '10.000',
      totalPayment: 'Rp 660.000',
    ),
    // ── Selesai ──
    Booking(
      id: 'B003',
      propertyName: 'Kost Melati Putri',
      propertyImage:
          'https://images.unsplash.com/photo-1570129477492-45a003537e1f?q=80&w=500',
      location: 'Sleman, Yogyakarta',
      checkIn: '20 Apr 2026',
      checkOut: '20 Mei 2026',
      price: 'Rp 1.500.000',
      status: BookingStatus.completed,
      propertyType: 'KOST',
      transactionDate: '20 April 2026',
      duration: '1 Bulan',
      roomCount: 1,
      rentPrice: 'Rp 1.000.000',
      motorBikePrice: 'Rp 100.000',
      serviceFee: '10.000',
      totalPayment: 'Rp 1.110.000',
      tenantArrivalConfirmedAt:
          DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Booking(
      id: 'B004',
      propertyName: 'Kost Prawirotaman Premium',
      propertyImage:
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?q=80&w=500',
      location: 'Kota Yogyakarta',
      checkIn: '01 Feb 2026',
      checkOut: '01 Mar 2026',
      price: 'Rp 1.500.000',
      status: BookingStatus.completed,
      propertyType: 'KOST',
      transactionDate: '01 Februari 2026',
      duration: '1 Bulan',
      roomCount: 1,
      rentPrice: 'Rp 1.400.000',
      serviceFee: '10.000',
      totalPayment: 'Rp 1.410.000',
      // Arrival confirmed > 4 hours ago — refund disabled
      tenantArrivalConfirmedAt:
          DateTime.now().subtract(const Duration(hours: 5)),
    ),
    // ── Refund ──
    Booking(
      id: 'B006',
      propertyName: 'Villa Kaliurang Retreat',
      propertyImage:
          'https://images.unsplash.com/photo-1570129477492-45a003537e1f?q=80&w=500',
      location: 'Sleman, Yogyakarta',
      checkIn: '10 Mar 2026',
      checkOut: '12 Mar 2026',
      price: 'Rp 1.700.000',
      status: BookingStatus.refund,
      propertyType: 'VILLA',
      transactionDate: '10 Maret 2026',
      duration: '3 Hari',
      roomCount: 1,
      rentPrice: 'Rp 1.650.000',
      serviceFee: '10.000',
      totalPayment: 'Rp 1.660.000',
    ),
    // ── Dibatalkan ──
    Booking(
      id: 'B005',
      propertyName: 'Villa Pantai Baron',
      propertyImage:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=500',
      location: 'Gunungkidul',
      checkIn: '15 Jan 2026',
      checkOut: '17 Jan 2026',
      price: 'Rp 2.200.000',
      status: BookingStatus.cancelled,
      propertyType: 'VILLA',
      transactionDate: '15 Januari 2026',
      duration: '3 Hari',
      roomCount: 1,
      rentPrice: 'Rp 2.100.000',
      serviceFee: '10.000',
      totalPayment: 'Rp 2.110.000',
    ),
  ];
}
