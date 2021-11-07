import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/data/model/restaurant.dart';
import 'package:restaurantapp/provider/database_provider.dart';

import 'customDialog.dart';

class WidgetRestaurantDetail extends StatelessWidget {
  final Restaurant restaurantDetail;

  WidgetRestaurantDetail({required this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return
      defaultTargetPlatform == TargetPlatform.iOS
        ?
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(restaurantDetail.name)  ,
            transitionBetweenRoutes: false,
          ),
          child: WidgetDetail(restaurantDetail),
        )
        :
        Scaffold(
          appBar: AppBar(
            title: Text(restaurantDetail.name),
          ),
          body:WidgetDetail(restaurantDetail),
        );
  }
}

class WidgetDetail extends StatelessWidget {
  WidgetDetail(this.restaurantDetail);

  final Restaurant restaurantDetail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  height: 240,
                  child: Image.network("https://restaurant-api.dicoding.dev/images/medium/${restaurantDetail.pictureId}", width: 300,),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Consumer<DatabaseProvider>(
                  builder: (context, provider, child){
                    return FutureBuilder<bool>(
                      future: provider.isBookmarked(restaurantDetail.id),
                      builder: (context, snapshot){
                        var isBookmarked = snapshot.data ?? false;
                        return Align(
                          alignment: Alignment.bottomRight,
                          child: isBookmarked
                              ? IconButton(
                            icon: Icon(Icons.favorite),
                            color: Theme.of(context).accentColor,
                            onPressed: () => provider.removeBookmark(restaurantDetail.id),
                          )
                              : IconButton(
                            icon: Icon(Icons.favorite_border),
                            color: Theme.of(context).accentColor,
                            onPressed: () => provider.addBookmark(restaurantDetail),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Text('Rating: '),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.star, size: 14),
                              ),
                              TextSpan(
                                text: restaurantDetail.rating.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text('City: '),
                        Text(restaurantDetail.city),
                      ],
                    ),
                    // TableRow(
                    //   children: <Widget>[
                    //     Text('Address:'),
                    //     Text(restaurantDetail.address),
                    //   ],
                    // ),
                  ],
                ),

                Divider(color: Colors.grey),
                Text(restaurantDetail.description),

                SizedBox(height: 5),
                Center(
                  child: ElevatedButton(
                    child: Text('Reserve Here'),
                    onPressed: (){
                      customDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
