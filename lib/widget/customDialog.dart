import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantapp/common/navigation.dart';

customDialog(BuildContext context){
  if(Platform.isIOS){
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return CupertinoAlertDialog(
          title: Text('Sorry'),
          content: Text('This feature is under Construction'),
          actions: [
            CupertinoDialogAction(
              child: Text('ok'),
              onPressed: (){
                Navigation.back();
              },
            )
          ],
        );
      });
  } else{
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Sorry'),
          content: Text('This feature is under Construction'),
          actions: [
            TextButton(
              onPressed: (){
                Navigation.back();
              },
              child: Text('ok'),
            ),
          ],
        );
      }
    );
  }
}