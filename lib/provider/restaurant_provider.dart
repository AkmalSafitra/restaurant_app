import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurantapp/data/api/api_service.dart';
import 'package:restaurantapp/data/model/restaurant.dart';

enum ResultState{Loading, NoData, HasData, Error}

class RestaurantProvider extends ChangeNotifier{
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late RestaurantResult _restaurantResult;
  String _message = '';
  late ResultState _state;

  String get message => _message;
  RestaurantResult get result => _restaurantResult;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async{
    try{
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.apiRestaurantlist();

      if(restaurant.restaurants.isEmpty){
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'No Restaurant Found';
      }else{
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    }catch(e){
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}


