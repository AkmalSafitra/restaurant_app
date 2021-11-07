import 'dart:convert';
import 'package:restaurantapp/data/model/restaurant.dart';

RestaurantSearchResult restaurantSearchResultFromJson(String str) => RestaurantSearchResult.fromJson(json.decode(str));

String restaurantSearchResultToJson(RestaurantSearchResult data) => json.encode(data.toJson());

class RestaurantSearchResult {
  RestaurantSearchResult({
    required this.error,
    required this.founded,
    required this.restaurantsSearch,
  });

  bool error;
  int founded;
  List<Restaurant> restaurantsSearch;

  factory RestaurantSearchResult.fromJson(Map<String, dynamic> json) => RestaurantSearchResult(
    error: json["error"],
    founded: json["founded"],
    restaurantsSearch: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "founded": founded,
    "restaurants": List<dynamic>.from(restaurantsSearch.map((x) => x.toJson())),
  };
}