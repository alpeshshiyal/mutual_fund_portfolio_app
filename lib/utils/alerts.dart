

import 'package:flutter/material.dart';

import '../../main.dart';
import 'color.dart';

class Alerts {
  static double bottomPadding = 50;

  static showErrorSnackBar(String message,{BuildContext? context}) {
    if(message.isEmpty) return;
    ScaffoldMessenger.of(context??navigatorKey.currentContext!).removeCurrentSnackBar();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(color: MyColors.primary)
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error,color: Colors.black,size: 40,),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white,fontSize: 16),
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          margin: EdgeInsets.only(bottom: bottomPadding,left: 16,right: 16),
        ),
      );
    });
  }
}
