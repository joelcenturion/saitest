import 'package:meta/meta.dart';

@immutable
abstract class PropertyListviewEvent {}

class GetPropertyListview extends PropertyListviewEvent {
  final String query, first, show;
  final apiToken;
  GetPropertyListview({required this.first, required this.show,required this.query, required this.apiToken});
}