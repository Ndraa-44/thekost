import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:thekost/features/booking/domain/entities/booking.dart';
import 'package:thekost/features/booking/data/datasources/booking_local_datasource.dart';

void main() {
  late BookingRepositoryImpl repository;

  setUp(() {
    repository = BookingRepositoryImpl();
  });

  group('BookingRepositoryImpl', () {
    group('getBookings', () {
      test('should return all bookings from local data source', () async {
        final result = await repository.getBookings();

        expect(result.length, BookingLocalDataSource.bookings.length);
      });
    });

    group('getBookingsByStatus', () {
      test('should return only active bookings', () async {
        final result =
            await repository.getBookingsByStatus(BookingStatus.active);

        expect(result, isNotEmpty);
        expect(result.every((b) => b.status == BookingStatus.active), isTrue);
      });

      test('should return only completed bookings', () async {
        final result =
            await repository.getBookingsByStatus(BookingStatus.completed);

        expect(result, isNotEmpty);
        expect(
            result.every((b) => b.status == BookingStatus.completed), isTrue);
      });

      test('should return only cancelled bookings', () async {
        final result =
            await repository.getBookingsByStatus(BookingStatus.cancelled);

        expect(result, isNotEmpty);
        expect(
            result.every((b) => b.status == BookingStatus.cancelled), isTrue);
      });
    });
  });
}
