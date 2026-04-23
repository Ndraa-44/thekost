abstract class PropertyEvent {}

class LoadProperties extends PropertyEvent {}
class SearchProperties extends PropertyEvent {
  final String query;
  SearchProperties(this.query);
}
