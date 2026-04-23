import 'package:flutter_bloc/flutter_bloc.dart';
import 'property_event.dart';
import 'property_state.dart';
import '../../data/datasources/dummy_data.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc() : super(PropertyInitial()) {
    on<LoadProperties>((event, emit) async {
      emit(PropertyLoading());
      // Simulate API load time
      await Future.delayed(const Duration(seconds: 1));
      emit(PropertyLoaded(DummyData.properties, DummyData.categories));
    });

    on<SearchProperties>((event, emit) async {
      emit(PropertyLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      final filtered = DummyData.properties.where((p) => 
        p.name.toLowerCase().contains(event.query.toLowerCase()) || 
        p.location.toLowerCase().contains(event.query.toLowerCase())
      ).toList();
      emit(PropertyLoaded(filtered, DummyData.categories));
    });
  }
}
