import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  static final supabase = Supabase.instance.client;

  /// Fetch recent reviews (optionally by country) Use: home_page "Recent Review" section
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

  /// Fetch all reviews by country Use: reviews_page
  static Future<List<Map<String, dynamic>>> fetchAllReviews({
    required String countryCode,
  }) async {
    try {
      final query = supabase.from('review').select('*').eq('country_code', countryCode).order('created_at', ascending: false);
      final List<dynamic> response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Error fetching reviews: $error');
    }
  }

  /// Submit a new review Use: submit_review_page
  static Future<void> createReview(Map<String, dynamic> reviewData) async {
    final response = await supabase.from('review').insert(reviewData);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }
}
