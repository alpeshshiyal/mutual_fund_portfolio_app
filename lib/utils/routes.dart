import 'package:flutter/material.dart';
import '../views/auth/view/auth_get.dart';
import '../views/chart/view/chart_view.dart';
class Routes {

  static MaterialPageRoute makeRoute(Widget page) => MaterialPageRoute(
    builder: (context) => page,);
  static Map<String, Widget Function(BuildContext)> generateRoutes = {
    AuthGate.routeName:(context)=>const AuthGate(),
    MutualFundChartScreen.routeName:(context)=> MutualFundChartScreen(),
  };

}