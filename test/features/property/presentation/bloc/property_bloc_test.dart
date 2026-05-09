import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thekost/features/property/domain/entities/property.dart';
import 'package:thekost/features/property/domain/entities/category.dart';
import 'package:thekost/features/property/domain/repositories/property_repository.dart';
import 'package:thekost/features/property/presentation/bloc/property_bloc.dart';
import 'package:thekost/features/property/presentation/bloc/property_event.dart';
import 'package:thekost/features/property/presentation/bloc/property_state.dart';

class MockPropertyRepository extends Mock implements PropertyRepository {}

void main() {
  late PropertyBloc propertyBloc;
  late MockPropertyRepository mockRepository;

  const testProperties = [
    Property(
      id: '1',
      name: 'Kost A',
      location: 'Sleman',
      price: 'Rp 1.000.000',
      imageUrl: 'https://example.com/a.jpg',
      rating: 4.5,
      category: 'Kost',
    ),
    Property(
      id: '2',
      name: 'Villa B',
      location: 'Gunungkidul',
      price: 'Rp 800.000',
      imageUrl: 'https://example.com/b.jpg',
      rating: 4.3,
      category: 'Villa',
    ),
  ];

  const testCategories = [
    Category(id: '1', name: 'Kost', iconName: 'kost'),
    Category(id: '2', name: 'Villa', iconName: 'villa'),
  ];

  setUp(() {
    mockRepository = MockPropertyRepository();
    propertyBloc = PropertyBloc(repository: mockRepository);
  });

  tearDown(() {
    propertyBloc.close();
  });

  group('PropertyBloc', () {
    test('initial state should be PropertyInitial', () {
      expect(propertyBloc.state, const PropertyInitial());
    });

    // ── LoadProperties ──
    group('LoadProperties', () {
      blocTest<PropertyBloc, PropertyState>(
        'emits [PropertyLoading, PropertyLoaded] when loading succeeds',
        build: () {
          when(() => mockRepository.getProperties())
              .thenAnswer((_) async => testProperties);
          when(() => mockRepository.getCategories())
              .thenAnswer((_) async => testCategories);
          return propertyBloc;
        },
        act: (bloc) => bloc.add(const LoadProperties()),
        expect: () => [
          const PropertyLoading(),
          const PropertyLoaded(testProperties, testCategories),
        ],
        verify: (_) {
          verify(() => mockRepository.getProperties()).called(1);
          verify(() => mockRepository.getCategories()).called(1);
        },
      );

      blocTest<PropertyBloc, PropertyState>(
        'emits [PropertyLoading, PropertyError] when loading fails',
        build: () {
          when(() => mockRepository.getProperties())
              .thenThrow(Exception('Network error'));
          return propertyBloc;
        },
        act: (bloc) => bloc.add(const LoadProperties()),
        expect: () => [
          const PropertyLoading(),
          isA<PropertyError>(),
        ],
      );

      blocTest<PropertyBloc, PropertyState>(
        'emits [PropertyLoading, PropertyLoaded] with empty list when no properties',
        build: () {
          when(() => mockRepository.getProperties())
              .thenAnswer((_) async => []);
          when(() => mockRepository.getCategories())
              .thenAnswer((_) async => testCategories);
          return propertyBloc;
        },
        act: (bloc) => bloc.add(const LoadProperties()),
        expect: () => [
          const PropertyLoading(),
          const PropertyLoaded([], testCategories),
        ],
      );
    });

    // ── SearchProperties ──
    group('SearchProperties', () {
      blocTest<PropertyBloc, PropertyState>(
        'emits [PropertyLoading, PropertyLoaded] when search succeeds',
        build: () {
          when(() => mockRepository.searchProperties('Kost'))
              .thenAnswer((_) async => [testProperties[0]]);
          when(() => mockRepository.getCategories())
              .thenAnswer((_) async => testCategories);
          return propertyBloc;
        },
        act: (bloc) => bloc.add(const SearchProperties('Kost')),
        expect: () => [
          const PropertyLoading(),
          PropertyLoaded([testProperties[0]], testCategories),
        ],
        verify: (_) {
          verify(() => mockRepository.searchProperties('Kost')).called(1);
        },
      );

      blocTest<PropertyBloc, PropertyState>(
        'emits [PropertyLoading, PropertyLoaded] with empty list when no results',
        build: () {
          when(() => mockRepository.searchProperties('Nonexistent'))
              .thenAnswer((_) async => []);
          when(() => mockRepository.getCategories())
              .thenAnswer((_) async => testCategories);
          return propertyBloc;
        },
        act: (bloc) => bloc.add(const SearchProperties('Nonexistent')),
        expect: () => [
          const PropertyLoading(),
          const PropertyLoaded([], testCategories),
        ],
      );

      blocTest<PropertyBloc, PropertyState>(
        'emits [PropertyLoading, PropertyError] when search fails',
        build: () {
          when(() => mockRepository.searchProperties('error'))
              .thenThrow(Exception('Search error'));
          return propertyBloc;
        },
        act: (bloc) => bloc.add(const SearchProperties('error')),
        expect: () => [
          const PropertyLoading(),
          isA<PropertyError>(),
        ],
      );
    });
  });

  // ── Property Event Tests ──
  group('PropertyEvent', () {
    test('LoadProperties supports value equality', () {
      expect(const LoadProperties(), equals(const LoadProperties()));
    });

    test('SearchProperties supports value equality', () {
      const event1 = SearchProperties('kost');
      const event2 = SearchProperties('kost');
      expect(event1, equals(event2));
    });

    test('SearchProperties with different queries are not equal', () {
      const event1 = SearchProperties('kost');
      const event2 = SearchProperties('villa');
      expect(event1, isNot(equals(event2)));
    });

    test('SearchProperties props contains query', () {
      const event = SearchProperties('kost');
      expect(event.props, equals(['kost']));
    });
  });

  // ── Property State Tests ──
  group('PropertyState', () {
    test('PropertyInitial supports value equality', () {
      expect(const PropertyInitial(), equals(const PropertyInitial()));
    });

    test('PropertyLoading supports value equality', () {
      expect(const PropertyLoading(), equals(const PropertyLoading()));
    });

    test('PropertyLoaded supports value equality', () {
      const state1 = PropertyLoaded(testProperties, testCategories);
      const state2 = PropertyLoaded(testProperties, testCategories);
      expect(state1, equals(state2));
    });

    test('PropertyLoaded props contains properties and categories', () {
      const state = PropertyLoaded(testProperties, testCategories);
      expect(state.props, equals([testProperties, testCategories]));
    });

    test('PropertyError supports value equality', () {
      const state1 = PropertyError('error');
      const state2 = PropertyError('error');
      expect(state1, equals(state2));
    });

    test('PropertyError props contains message', () {
      const state = PropertyError('some error');
      expect(state.props, equals(['some error']));
    });
  });
}
