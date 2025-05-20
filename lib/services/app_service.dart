
import 'package:mutual_fund_portfolio_app/config/key_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final AppService app = AppService.instance;

class AppService {
  static final AppService instance = AppService();


  initSupabase() async {
    await Supabase.initialize(
      url: KeyConstants.supabaseUrl,
      anonKey: KeyConstants.supabaseAnonKey
    );
  }
}