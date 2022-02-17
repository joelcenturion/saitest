import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:devkitflutter/model/integration/property_listview_model.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import './bloc.dart';

class PropertyListviewBloc extends Bloc<PropertyListviewEvent, PropertyListviewState> {
  PropertyListviewBloc() : super(InitialPropertyListviewState());

  @override
  Stream<PropertyListviewState> mapEventToState(
      PropertyListviewEvent event,
      ) async* {
    if(event is GetPropertyListview){
      yield* _getPropertyListview(event.first, event.show, event.query,  event.apiToken);
    }
  }
}

Stream<PropertyListviewState> _getPropertyListview(String first, String show,String query, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield PropertyListviewWaiting();
  try {
    List<PropertyModel> data = await _apiProvider.getPropertyListview(first, show, query, apiToken);
    yield GetPropertyListviewSuccess(propertyListviewData: data);
  } catch (ex){
    print(ex.toString());
    if(ex != 'cancel'){
      yield PropertyListviewError(errorMessage: ex.toString());
    }
  }
}