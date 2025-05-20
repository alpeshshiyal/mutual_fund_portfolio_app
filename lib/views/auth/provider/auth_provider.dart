import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/alerts.dart';

final authProvider = ChangeNotifierProvider((ref){
  return AuthProvider();
});

class AuthProvider extends ChangeNotifier{
  bool loading = false;
  bool isLogin = true;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void toggleMode() {
    isLogin = !isLogin;
    notifyListeners();
  }


  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    loading = true;
    notifyListeners();

    final supabase = Supabase.instance.client;
    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      } else {
        await supabase.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
       Alerts.showErrorSnackBar('Check your email to confirm account.');
      }
    } on AuthException catch (e) {
      Alerts.showErrorSnackBar(e.message);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}