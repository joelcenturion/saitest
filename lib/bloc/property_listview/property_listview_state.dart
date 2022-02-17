import 'package:devkitflutter/model/integration/property_listview_model.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PropertyListviewState {}

class InitialPropertyListviewState extends PropertyListviewState {}

class PropertyListviewError extends PropertyListviewState {
  final String errorMessage;

  PropertyListviewError({
    required this.errorMessage,
  });
}

class PropertyListviewWaiting extends PropertyListviewState {}

class GetPropertyListviewSuccess extends PropertyListviewState {
  final List<PropertyModel> propertyListviewData;
  GetPropertyListviewSuccess({required this.propertyListviewData});
}