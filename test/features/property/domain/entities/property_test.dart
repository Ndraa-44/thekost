import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/property/domain/entities/property.dart';

void main() {
  group('Property Entity', () {
    const property1 = Property(
      id: '1',
      name: 'Kost Exclusive',
      location: 'Sleman',
      price: 'Rp 1.200.000/bln',
      imageUrl: 'https://example.com/img.jpg',
      rating: 4.8,
      category: 'Kost',
    );

    const property2 = Property(
      id: '1',
      name: 'Kost Exclusive',
      location: 'Sleman',
      price: 'Rp 1.200.000/bln',
      imageUrl: 'https://example.com/img.jpg',
      rating: 4.8,
      category: 'Kost',
    );

    const property3 = Property(
      id: '2',
      name: 'Villa Retreat',
      location: 'Gunungkidul',
      price: 'Rp 850.000/malam',
      imageUrl: 'https://example.com/villa.jpg',
      rating: 4.7,
      category: 'Villa',
    );

    test('should support value equality (same data = equal)', () {
      expect(property1, equals(property2));
    });

    test('should NOT be equal when data differs', () {
      expect(property1, isNot(equals(property3)));
    });

    test('props should contain all fields', () {
      expect(
        property1.props,
        equals([
          '1',
          'Kost Exclusive',
          'Sleman',
          'Rp 1.200.000/bln',
          'https://example.com/img.jpg',
          4.8,
          'Kost',
        ]),
      );
    });

    test('should store all properties correctly', () {
      expect(property1.id, '1');
      expect(property1.name, 'Kost Exclusive');
      expect(property1.location, 'Sleman');
      expect(property1.price, 'Rp 1.200.000/bln');
      expect(property1.imageUrl, 'https://example.com/img.jpg');
      expect(property1.rating, 4.8);
      expect(property1.category, 'Kost');
    });
  });
}
