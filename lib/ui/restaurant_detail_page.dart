import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/data/api/api_service.dart';
import 'package:restaurantapp/data/db/database_helper.dart';
import 'package:restaurantapp/data/model/restaurant.dart';
// import 'package:restaurantapp/data/model/restaurant_detail.dart';
import 'package:restaurantapp/provider/database_provider.dart';
import 'package:restaurantapp/provider/restaurant_detail_provider.dart';
import 'package:restaurantapp/provider/restaurant_provider.dart';
import 'package:restaurantapp/widget/platform_widget.dart';
import 'package:restaurantapp/widget/widget_restaurant_detail.dart';

late Restaurant restaurantDetail;

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String id;

  const RestaurantDetailPage({
    required this.id
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {

  Widget _buildDetail(BuildContext context){
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => RestaurantDetailProvider(apiService: ApiService(id: widget.id)),
        child: Consumer<RestaurantDetailProvider>(
          builder: (context, state, _){
            if(state.state == ResultState.Loading){
              return Center(child: CircularProgressIndicator());
            } else if(state.state == ResultState.HasData){
              return ChangeNotifierProvider<DatabaseProvider>(
                      create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
                      child: WidgetRestaurantDetail(restaurantDetail : state.result.restaurantDetail),
                    );

                // ;
            } else if (state.state == ResultState.NoData) {
              return Center(child: Text(""));
            } else if (state.state == ResultState.Error) {
              return Center(
                child: defaultTargetPlatform == TargetPlatform.iOS
                  ?
                  CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Text("Restaurant")  ,
                      transitionBetweenRoutes: false,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Failed to load Data"),
                          Text("Please check your Internet connection"),
                        ],
                      )
                    ),
                  )
                  :
                  Scaffold(
                    appBar: AppBar(
                      title: Text("Restaurant"),
                    ),
                    body:Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Failed to load Data"),
                          Text("Please check your Internet connection"),
                        ],
                      )
                    ),
                  ),
              );
            } else {
              return Center(child: Text(''));
            }
          }
       ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildDetail(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: _buildDetail(context),
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


