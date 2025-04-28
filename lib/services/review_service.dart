// lib/services/review_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  static final supabase = Supabase.instance.client;

  /// 🔥 Fetch recent reviews (optionally by country)
  /// Use: home_page "Recent Review" section
  static Future<List<Map<String, dynamic>>> fetchRecentReviews({
    String? countryCode,
    int limit = 3,
  }) async {
    try {
      List<dynamic> response;
      if (countryCode == null) {
        response = await supabase.from('review').select('*').order('created_at', ascending: false).limit(limit);
      } else {
        response = await supabase.from('review').select('*').eq('country_code', countryCode).order('created_at', ascending: false).limit(limit);
      }
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Error fetching reviews: $error');
    }
  }
}
