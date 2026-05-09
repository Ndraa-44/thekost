import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/booking/domain/entities/booking.dart';

void main() {
  group('Booking Entity', () {
    const booking1 = Booking(
      id: 'B001',
      propertyName: 'Kost Exclusive',
      propertyImage: 'https://example.com/img.jpg',
      location: 'Sleman',
      checkIn: '24 Apr 2026',
      checkOut: '24 Mei 2026',
      price: 'Rp 1.200.000',
      status: BookingStatus.active,
    );

    const booking2 = Booking(
      id: 'B001',
      propertyName: 'Kost Exclusive',
      propertyImage: 'https://example.com/img.jpg',
      location: 'Sleman',
      checkIn: '24 Apr 2026',
      checkOut: '24 Mei 2026',
      price: 'Rp 1.200.000',
      status: BookingStatus.active,
    );

    const booking3 = Booking(
      id: 'B002',
      propertyName: 'Villa Retreat',
      propertyImage: 'https://example.com/villa.jpg',
      location: 'Gunungkidul',
      checkIn: '10 Mar 2026',
      checkOut: '12 Mar 2026',
      price: 'Rp 1.700.000',
      status: BookingStatus.completed,
    );

    test('should support value equality (same data = equal)', () {
      expect(booking1, equals(booking2));
    });

    test('should NOT be equal when data differs', () {
      expect(booking1, isNot(equals(booking3)));
    });

    test('props should contain all fields', () {
      expect(
        booking1.props,
        equals([
          'B001',
          'Kost Exclusive',
          'https://example.com/img.jpg',
          'Sleman',
          '24 Apr 2026',
          '24 Mei 2026',
          'Rp 1.200.000',
          BookingStatus.active,
        ]),
      );
    });

    test('should store all properties correctly', () {
      expect(booking1.id, 'B001');
      expect(booking1.propertyName, 'Kost Exclusive');
      expect(booking1.location, 'Sleman');
      expect(booking1.status, BookingStatus.active);
    });
  });

  group('BookingStatus Enum', () {
    test('should have 3 values', () {
      expect(BookingStatus.values.length, 3);
    });

    test('should contain active, completed, cancelled', () {
      expect(BookingStatus.values, contains(BookingStatus.active));
      expect(BookingStatus.values, contains(BookingStatus.completed));
      expect(BookingStatus.values, contains(BookingStatus.cancelled));
    });
  });
}
