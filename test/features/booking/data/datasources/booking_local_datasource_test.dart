import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/booking/data/datasources/booking_local_datasource.dart';
import 'package:thekost/features/booking/domain/entities/booking.dart';

void main() {
  group('BookingLocalDataSource', () {
    test('should contain 5 bookings', () {
      expect(BookingLocalDataSource.bookings.length, 5);
    });

    test('should have 2 active bookings', () {
      final active = BookingLocalDataSource.bookings
          .where((b) => b.status == BookingStatus.active)
          .toList();
      expect(active.length, 2);
    });

    test('should have 2 completed bookings', () {
      final completed = BookingLocalDataSource.bookings
          .where((b) => b.status == BookingStatus.completed)
          .toList();
      expect(completed.length, 2);
    });

    test('should have 1 cancelled booking', () {
      final cancelled = BookingLocalDataSource.bookings
          .where((b) => b.status == BookingStatus.cancelled)
          .toList();
      expect(cancelled.length, 1);
    });

    test('all bookings should have unique IDs', () {
      final ids = BookingLocalDataSource.bookings.map((b) => b.id);
      expect(ids.toSet().length, ids.length);
    });

    test('all bookings should have non-empty fields', () {
      for (final booking in BookingLocalDataSource.bookings) {
        expect(booking.id, isNotEmpty);
        expect(booking.propertyName, isNotEmpty);
        expect(booking.propertyImage, isNotEmpty);
        expect(booking.location, isNotEmpty);
        expect(booking.checkIn, isNotEmpty);
        expect(booking.checkOut, isNotEmpty);
        expect(booking.price, isNotEmpty);
      }
    });
  });
}
