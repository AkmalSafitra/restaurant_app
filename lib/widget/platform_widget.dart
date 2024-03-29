import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PlatformWidget extends StatelessWidget {

  late final WidgetBuilder androidBuilder;
  late final WidgetBuilder iosBuilder;

  PlatformWidget({required this.androidBuilder, required this.iosBuilder});

  @override
  Widget build(BuildContext context) {
    switch(defaultTargetPlatform){
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iosBuilder(context);
      default:
        return androidBuilder(context);
    }
  }
}
