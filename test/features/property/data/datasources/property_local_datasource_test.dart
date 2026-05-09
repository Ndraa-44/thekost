import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/property/data/datasources/property_local_datasource.dart';

void main() {
  group('PropertyLocalDataSource', () {
    group('properties', () {
      test('should contain 7 property items', () {
        expect(PropertyLocalDataSource.properties.length, 7);
      });

      test('should contain properties from all categories', () {
        final categories = PropertyLocalDataSource.properties
            .map((p) => p.category)
            .toSet();
        expect(categories, containsAll(['Kost', 'Villa', 'Homestay']));
      });

      test('all properties should have non-empty fields', () {
        for (final property in PropertyLocalDataSource.properties) {
          expect(property.id, isNotEmpty);
          expect(property.name, isNotEmpty);
          expect(property.location, isNotEmpty);
          expect(property.price, isNotEmpty);
          expect(property.imageUrl, isNotEmpty);
          expect(property.rating, greaterThan(0));
          expect(property.category, isNotEmpty);
        }
      });

      test('all property IDs should be unique', () {
        final ids = PropertyLocalDataSource.properties.map((p) => p.id);
        expect(ids.toSet().length, ids.length);
      });

      test('all property ratings should be between 0 and 5', () {
        for (final property in PropertyLocalDataSource.properties) {
          expect(property.rating, greaterThanOrEqualTo(0));
          expect(property.rating, lessThanOrEqualTo(5));
        }
      });
    });

    group('categories', () {
      test('should contain 5 categories', () {
        expect(PropertyLocalDataSource.categories.length, 5);
      });

      test('should include Kost, Homestay, Rented House, Villa, Rented Apartement', () {
        final names = PropertyLocalDataSource.categories
            .map((c) => c.name)
            .toList();
        expect(names, containsAll([
          'Kost',
          'Homestay',
          'Rented House',
          'Villa',
          'Rented Apartement',
        ]));
      });

      test('all categories should have unique IDs', () {
        final ids = PropertyLocalDataSource.categories.map((c) => c.id);
        expect(ids.toSet().length, ids.length);
      });

      test('all categories should have non-empty icon names', () {
        for (final category in PropertyLocalDataSource.categories) {
          expect(category.iconName, isNotEmpty);
        }
      });
    });

    group('jogjaLocations', () {
      test('should contain 5 locations', () {
        expect(PropertyLocalDataSource.jogjaLocations.length, 5);
      });

      test('should include all Yogyakarta areas', () {
        expect(PropertyLocalDataSource.jogjaLocations, containsAll([
          'Kota Yogyakarta',
          'Sleman',
          'Bantul',
          'Gunungkidul',
          'Kulon Progo',
        ]));
      });

      test('all locations should be non-empty', () {
        for (final location in PropertyLocalDataSource.jogjaLocations) {
          expect(location, isNotEmpty);
        }
      });
    });
  });
}
