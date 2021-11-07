import 'package:flutter/cupertino.dart';
import 'package:restaurantapp/data/api/api_service.dart';
import 'package:restaurantapp/data/model/restaurant_detail.dart';
import 'package:restaurantapp/provider/restaurant_provider.dart';

class RestaurantDetailProvider extends ChangeNotifier{
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService}) {
    _fetchDetailRestaurant();
  }

  late RestaurantDetailResult _restaurantDetailResult;
  String _message = '';
  late ResultState _state;

  String get message => _message;
  RestaurantDetailResult get result => _restaurantDetailResult;
  ResultState get state => _state;

  Future<dynamic> _fetchDetailRestaurant() async{
    try{
      _state = ResultState.Loading;
      notifyListeners();
      final restaurantDetail = await apiService.apiRestaurantDetail();

      if(restaurantDetail.error == true){
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }else{
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantDetailResult = restaurantDetail;
      }
    }catch(e){
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}