import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantapp/data/api/api_service.dart';
import 'package:restaurantapp/data/model/restaurant_search.dart';
import 'package:restaurantapp/widget/card_restaurant.dart';
import 'package:restaurantapp/widget/platform_widget.dart';

class RestaurantSearchPage extends StatefulWidget {
  static const routeName = '/restaurant_search';
  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}


class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  late Future<RestaurantSearchResult> _restaurantSearch;

  @override
  void initState() {
    super.initState();
    _restaurantSearch = ApiService(query: 'blank').apiRestaurantSearch();
  }

  Widget _buildList(BuildContext context){
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: "Search Restaurant",
                          hintStyle: TextStyle(color: Colors.grey)
                      ),
                      onChanged: (value) {
                        setState(() {
                          _restaurantSearch = ApiService(query: value).apiRestaurantSearch();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
        Expanded(
          flex: 8,
          child: FutureBuilder(
            future: _restaurantSearch,
            builder: (context, AsyncSnapshot<RestaurantSearchResult> snapshot) {
              var state = snapshot.connectionState;
              if (state != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.restaurantsSearch.length,
                    itemBuilder: (context, index) {
                      var restaurant = snapshot.data?.restaurantsSearch[index];
                      return CardRestaurant( restaurant: restaurant!);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          Text("No Internet Connection"),
                          Text("Please check your Internet connection"),
                        ]
                    ),
                  );
                } else {
                  return Text('');
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Restaurant')  ,
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}


