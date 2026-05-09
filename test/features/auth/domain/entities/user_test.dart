import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    const user1 = User(
      id: '1',
      name: 'Ahmad',
      email: 'ahmad@test.com',
      phoneNumber: '081234567890',
    );

    const user2 = User(
      id: '1',
      name: 'Ahmad',
      email: 'ahmad@test.com',
      phoneNumber: '081234567890',
    );

    const user3 = User(
      id: '2',
      name: 'Budi',
      email: 'budi@test.com',
      phoneNumber: '081234567891',
    );

    test('should be a subclass of Equatable', () {
      expect(user1, isA<User>());
    });

    test('should support value equality (same data = equal)', () {
      expect(user1, equals(user2));
    });

    test('should NOT be equal when data differs', () {
      expect(user1, isNot(equals(user3)));
    });

    test('props should contain all fields', () {
      expect(
        user1.props,
        equals(['1', 'Ahmad', 'ahmad@test.com', '081234567890']),
      );
    });

    test('should store all properties correctly', () {
      expect(user1.id, '1');
      expect(user1.name, 'Ahmad');
      expect(user1.email, 'ahmad@test.com');
      expect(user1.phoneNumber, '081234567890');
    });
  });
}
