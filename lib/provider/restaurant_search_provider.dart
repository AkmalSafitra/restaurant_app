import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurantapp/data/api/api_service.dart';
import 'package:restaurantapp/data/model/restaurant_search.dart';
import 'package:restaurantapp/provider/restaurant_provider.dart';

class RestaurantSearchProvider extends ChangeNotifier{
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService}) {
    _fetchSearchRestaurant();
  }

  late RestaurantSearchResult _restaurantSearchResult;
  String _message = '';
  late ResultState _state;

  String get message => _message;
  RestaurantSearchResult get result => _restaurantSearchResult;
  ResultState get state => _state;

  Future<dynamic> _fetchSearchRestaurant() async{
    try{
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.apiRestaurantSearch();

      if(restaurant.restaurantsSearch.isEmpty){
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Restaurant Not Found';
      }else{
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantSearchResult = restaurant;
      }
    }catch(e){
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}


