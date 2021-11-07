import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurantapp/data/model/restaurant.dart';
import 'package:restaurantapp/data/model/restaurant_detail.dart';
import 'package:restaurantapp/data/model/restaurant_search.dart';

class ApiService{
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  final String id;
  final String query;

  ApiService({this.id = '', this.query=''});

  Future<RestaurantResult> apiRestaurantlist() async{
    final response = await http.get(Uri.parse(_baseUrl+ "list"));

    if(response.statusCode == 200){
      return RestaurantResult.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load Restaurant list');
    }
  }

  Future<RestaurantDetailResult> apiRestaurantDetail() async{

    final response = await http.get(Uri.parse(_baseUrl+ "detail/$id"));

    if(response.statusCode == 200){
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load Restaurant detail');
    }
  }

  Future<RestaurantSearchResult> apiRestaurantSearch() async{
    final response = await http.get(Uri.parse(_baseUrl+"search?q=$query"));

    if(response.statusCode == 200){
      return RestaurantSearchResult.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load Restaurant Search');
    }
  }

}