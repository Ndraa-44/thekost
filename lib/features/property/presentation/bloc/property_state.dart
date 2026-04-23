import '../../domain/entities/property.dart';
import '../../domain/entities/category.dart';

abstract class PropertyState {}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final List<Property> properties;
  final List<Category> categories;

  PropertyLoaded(this.properties, this.categories);
}

class PropertyError extends PropertyState {
  final String message;
  PropertyError(this.message);
}
