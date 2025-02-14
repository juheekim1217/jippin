import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/component/footer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  final String defaultCountryCode;
  final String defaultCountryName;
  final ValueChanged<String> onSearchLandlord;

  const HomePage({
    super.key,
    required this.defaultCountryCode,
    required this.defaultCountryName,
    required this.onSearchLandlord,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> recentReviews = [];
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRecentReviews();
  }

  @override
  void dispose() {
    searchController.dispose(); // ✅ Prevent memory leaks
    super.dispose();
  }

  void _handleSearch() {
    widget.onSearchLandlord(searchController.text);
  }

  // Fetch reviews from Supabase by Selected Country
  Future<void> _fetchRecentReviews() async {
    try {
      var response = await supabase
          .from('review')
          .select('*') // Fetch all columns or specify required ones
          .eq('country_code', widget.defaultCountryCode)
          .order('created_at', ascending: false) // Order by latest first
          .limit(3); // Get only the most recent 3 reviews

      if (response.isEmpty) {
        response = await supabase
            .from('review')
            .select('*') // Fetch all columns or specify required ones
            .order('created_at', ascending: false) // Order by latest first
            .limit(3); // Get only the most recent 3 reviews
      }
      debugPrint("_fetchedRecent3Reviews ${response.length}");

      if (response.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        recentReviews = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching reviews: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Hero Section
              _buildHeroSection(localizations, context),
              const SizedBox(height: 40),

              // 🔒 Anonymous Review Notice
              _buildAnonymousSection(localizations),
              const SizedBox(height: 50),

              // 🏡 Recent Reviews
              _buildRecentReviews(localizations, context),
              const SizedBox(height: 50),

              // 🔄 How It Works
              _buildHowItWorksSection(localizations, context),
              const SizedBox(height: 40),

              // 📌 Footer (Not Sticky, Appears After All Content)
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 Hero Section
  Widget _buildHeroSection(AppLocalizations localizations, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          localizations.home_heroTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          localizations.home_heroSubtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 30),

        // 🔍 Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            onSubmitted: (value) => _handleSearch(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              hintText: localizations.home_searchHint,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ⚡ CTA Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              text: localizations.home_readReviews,
              onTap: () => _handleSearch, //Navigator.pushReplacementNamed(context, '/reviews'),
            ),
            const SizedBox(width: 10),
            _buildButton(
              text: localizations.home_writeReview,
              isOutlined: true,
              onTap: () => Navigator.pushReplacementNamed(context, '/submit'), //debugPrint("Navigate to Submit Review"),
            ),
          ],
        ),
      ],
    );
  }

  // 🎨 Custom Button
  Widget _buildButton({required String text, required VoidCallback onTap, bool isOutlined = false}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.white : Colors.black,
        foregroundColor: isOutlined ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isOutlined ? const BorderSide(color: Colors.black, width: 1.5) : BorderSide.none,
        ),
      ),
      child: Text(text),
    );
  }

  // 🔒 Anonymous Review Section
  Widget _buildAnonymousSection(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          const Icon(Icons.privacy_tip, color: Colors.black54, size: 30),
          const SizedBox(height: 8),
          Text(
            localizations.home_anonymousReviewsTitle,
            style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            localizations.home_anonymousReviewsDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReviews(AppLocalizations localizations, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.home_recentReviews,
          style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // 🏡 Dynamically Build Review Cards
        ...recentReviews.map((review) => _buildReviewCard(
              localizations,
              review['country'] ?? localizations.unknown_country,
              review['city'] ?? localizations.unknown_city,
              review['landlord'] ?? '',
              review['property'] ?? '',
              review['overall_rating'] ?? 0,
              review['title'] ?? '',
              review['review'] ?? localizations.no_review_available,
            )),

        const SizedBox(height: 10),

        // 🔗 "See More Reviews" Button
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/reviews'),
          child: Text(localizations.home_seeMoreReviews),
        ),
      ],
    );
  }

  // 🏡 Review Card
  Widget _buildReviewCard(AppLocalizations localizations, String country, String city, String landlord, String property, double rating, String title, String review) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏡 Landlord Name (Bold)
            if (landlord.isNotEmpty)
              Text(
                "${localizations.landlord}: $landlord",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),

            // 📍 Country & City (Smaller Font)
            Text(
              "$city, $country",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),

            // 🏠 Property Name
            if (property.isNotEmpty)
              Text(
                property,
                style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
              ),

            // 🏠 Review Title
            if (title.isNotEmpty)
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        // 💬 Review Title Text
        // 💬 Review Text
        subtitle: Text(review, maxLines: 2, overflow: TextOverflow.ellipsis),

        // ⭐ Rating Stars
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(index < rating.round() ? Icons.star : Icons.star_border, color: Colors.amber, size: 16);
          }),
        ),
      ),
    );
  }

  // 🔄 How It Works Section
  Widget _buildHowItWorksSection(AppLocalizations localizations, BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.home_howItWorks, style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildFeatureCard(
            title: localizations.home_findLandlordsTitle,
            description: localizations.home_findLandlordsDesc,
            icon: Icons.content_paste_search_rounded,
            color: Colors.lightBlue,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/reviews'); // Navigate to Profile Page
            },
          ),
          _buildFeatureCard(
            title: localizations.home_writeReviewTitle,
            description: localizations.home_writeReviewDesc,
            icon: Icons.mode_edit_rounded,
            color: Colors.green,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/submit'); // Navigate to Profile Page
            },
          ),
        ],
      ),
    );
  }

  // Helper method to create feature cards
  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap, // Callback for navigation
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Changes cursor when hovering over the card
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: onTap, // Card itself is now clickable
          borderRadius: BorderRadius.circular(12), // Smooth touch effect
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Ensures clickable area is large
            child: Row(
              children: [
                // 🔵 Clickable CircleAvatar
                MouseRegion(
                  cursor: SystemMouseCursors.click, // Changes cursor on hover
                  child: Material(
                    shape: const CircleBorder(),
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onTap, // CircleAvatar is also clickable
                      child: CircleAvatar(
                        backgroundColor: color.withAlpha(60),
                        child: Icon(icon, color: color),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Spacing between avatar and text

                // 📄 Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(description, style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
