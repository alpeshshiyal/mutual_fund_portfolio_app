import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/preference_constants.dart';

class PreferenceService {
  final SharedPreferences pref;
  PreferenceService(this.pref);

  void storeUserData({userId,firstName,name,email,mobileNumber,token}){
    pref.setString(PreferenceConstants.userId, userId.toString());
    pref.setString(PreferenceConstants.name, name.toString());
    pref.setString(PreferenceConstants.email, email.toString());
  }
  void storeToken(String? token) {
    pref.setString(PreferenceConstants.userToken, token!);
  }

  String? getToken() {
    return pref.getString(PreferenceConstants.userToken);
  }
  void setIsLogin({bool isLogin = false}){
    pref.setBool(PreferenceConstants.isLogin, isLogin);
  }
  bool? getIsLogin(){
    return pref.getBool(PreferenceConstants.isLogin);
  }

  String? getUserId(){
    debugPrint("pref user id:${pref.getString(PreferenceConstants.userId)}");
    // return "2";
    return pref.getString(PreferenceConstants.userId);
  }

  String getName(){
    return pref.getString(PreferenceConstants.name)??"";
  }
  String? getEmail(){
    return pref.getString(PreferenceConstants.email);
  }
  //!================================USER LOGOUT=====================================

  void logOutUser() {
    pref.remove(PreferenceConstants.isLogin);
    // Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, Routes.signIn(), (route) => false);
    // NavigationHelper.navigateToAndRemoveUntil(SignInView.routeName);
  }
}
