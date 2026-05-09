import 'package:flutter_test/flutter_test.dart';
import 'package:thekost/features/property/data/repositories/property_repository_impl.dart';
import 'package:thekost/features/property/data/datasources/property_local_datasource.dart';

void main() {
  late PropertyRepositoryImpl repository;

  setUp(() {
    repository = PropertyRepositoryImpl();
  });

  group('PropertyRepositoryImpl', () {
    group('getProperties', () {
      test('should return all properties from local data source', () async {
        final result = await repository.getProperties();

        expect(result, isNotEmpty);
        expect(result.length, PropertyLocalDataSource.properties.length);
      });

      test('should return the same data as the data source', () async {
        final result = await repository.getProperties();

        expect(result, equals(PropertyLocalDataSource.properties));
      });
    });

    group('getCategories', () {
      test('should return all categories from local data source', () async {
        final result = await repository.getCategories();

        expect(result, isNotEmpty);
        expect(result.length, PropertyLocalDataSource.categories.length);
      });
    });

    group('getLocations', () {
      test('should return all locations from local data source', () async {
        final result = await repository.getLocations();

        expect(result, isNotEmpty);
        expect(result.length, PropertyLocalDataSource.jogjaLocations.length);
      });
    });

    group('searchProperties', () {
      test('should return matching properties by name', () async {
        final result = await repository.searchProperties('Jakal');

        expect(result, isNotEmpty);
        expect(
          result.every((p) =>
              p.name.toLowerCase().contains('jakal') ||
              p.location.toLowerCase().contains('jakal')),
          isTrue,
        );
      });

      test('should return matching properties by location', () async {
        final result = await repository.searchProperties('Sleman');

        expect(result, isNotEmpty);
        expect(
          result.every((p) =>
              p.name.toLowerCase().contains('sleman') ||
              p.location.toLowerCase().contains('sleman')),
          isTrue,
        );
      });

      test('should return empty list when no match found', () async {
        final result = await repository.searchProperties('Nonexistent');

        expect(result, isEmpty);
      });

      test('should be case insensitive', () async {
        final resultLower = await repository.searchProperties('kost');
        final resultUpper = await repository.searchProperties('KOST');

        expect(resultLower.length, equals(resultUpper.length));
      });
    });
  });
}
