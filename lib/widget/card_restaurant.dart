import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/common/navigation.dart';
import 'package:restaurantapp/common/styles.dart';
import 'package:restaurantapp/data/api/api_service.dart';
import 'package:restaurantapp/data/model/restaurant.dart';
import 'package:restaurantapp/provider/database_provider.dart';
import 'package:restaurantapp/provider/restaurant_detail_provider.dart';
import 'package:restaurantapp/ui/restaurant_detail_page.dart';

class CardRestaurant extends StatefulWidget {
  final Restaurant restaurant;

  const CardRestaurant({required this.restaurant});

  @override
  State<CardRestaurant> createState() => _CardRestaurantState();
}

class _CardRestaurantState extends State<CardRestaurant>{

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isBookmarked(widget.restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Material(
              color: primaryColor,
              child: ListTile(
                trailing: isBookmarked
                    ? IconButton(
                  icon: Icon(Icons.favorite),
                  color: Theme.of(context).accentColor,
                  onPressed: () => provider.removeBookmark(widget.restaurant.id)
,
                )
                    : IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                  onPressed: () => provider.addBookmark(widget.restaurant),
                ),

                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: widget.restaurant.pictureId,
                  child: Image.network( "https://restaurant-api.dicoding.dev/images/small/${widget.restaurant.pictureId}", width: 100),
                ),
                title: Text(widget.restaurant.name),
                subtitle: Text(widget.restaurant.city),

                onTap:() => Navigator.pushNamed(context, RestaurantDetailPage.routeName, arguments: widget.restaurant.id)
                    .then((value) => setState(() {
                      context.read<DatabaseProvider>().getBookmarks();
                    })),

              ),
            );
          },
        );
      },
    );
  }
}
