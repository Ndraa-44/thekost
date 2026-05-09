import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/property/domain/entities/category.dart';

void main() {
  group('Category Entity', () {
    const category1 = Category(id: '1', name: 'Kost', iconName: 'kost');
    const category2 = Category(id: '1', name: 'Kost', iconName: 'kost');
    const category3 = Category(id: '2', name: 'Villa', iconName: 'villa');

    test('should support value equality (same data = equal)', () {
      expect(category1, equals(category2));
    });

    test('should NOT be equal when data differs', () {
      expect(category1, isNot(equals(category3)));
    });

    test('props should contain all fields', () {
      expect(category1.props, equals(['1', 'Kost', 'kost']));
    });

    test('should store all properties correctly', () {
      expect(category1.id, '1');
      expect(category1.name, 'Kost');
      expect(category1.iconName, 'kost');
    });
  });
}
