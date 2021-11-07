import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/provider/restaurant_provider.dart';
import 'package:restaurantapp/ui/home_page.dart';
import 'package:restaurantapp/ui/restaurant_search_page.dart';
import 'package:restaurantapp/widget/card_restaurant.dart';
import 'package:restaurantapp/widget/platform_widget.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';
  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {

  Widget _buildList(BuildContext context){
    return Consumer<RestaurantProvider>(
      builder: (context, state, _){
        if(state.state == ResultState.Loading){
          return Center(child: CircularProgressIndicator());
        } else if(state.state == ResultState.HasData){
          return Scrollbar(
            isAlwaysShown: true,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.result.restaurants.length,
              itemBuilder: (context, index){
                var restaurant = state.result.restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              },
            ),
          );
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text("Failed to load Data"),
                Text("Please check your Internet connection"),
                IconButton(
                    icon: Icon(Icons.refresh),
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
                  },
                ),
              ]
            ),
          );
        } else {
          return Center(child: Text(''));
        }
      }
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, RestaurantSearchPage.routeName);
            },
          )
        ],
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
