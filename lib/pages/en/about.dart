import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/component/footer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPageEn extends StatelessWidget {
  const AboutPageEn({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeaderSection(),
            _buildPersonalStorySection(),
            _buildSectionTitle("What You Can Share"),
            _buildWhatYouCanShareSection(),
            _buildSectionTitle("Condition & Experience Ratings"),
            _buildRatingSection(
              icon: Icons.shield_outlined,
              title: "Trustworthiness",
              description: "Did the landlord or agent follow through on promises and act with integrity?",
            ),
            _buildRatingSection(
              icon: Icons.attach_money_outlined,
              title: "Price",
              description: "Was the cost fair for what was offered?",
            ),
            _buildRatingSection(
              icon: Icons.location_on_outlined,
              title: "Location",
              description: "Was the area convenient, safe, and accessible?",
            ),
            _buildRatingSection(
              icon: Icons.home_repair_service_outlined,
              title: "Condition",
              description: "Was the property clean, safe, and well-maintained?",
            ),
            _buildSectionTitle("Why It Matters"),
            _buildWhyItMattersSection(),
            const SizedBox(height: 30),
            _buildContributionMessage("All reviews are anonymous. Your voice matters — by sharing your experience, you’re helping others avoid bad rentals and find better housing."),
            const SizedBox(height: 20),
            _buildContactSection(),
            const SizedBox(height: 30),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About Jippin", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(
          "Helping Renters Make Smarter Choices — and Avoid Rental Scams!",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPersonalStorySection() {
    return const Text(
      "I created Jippin after watching a heartbreaking news story about young people in South Korea who took their lives after falling victim to rental scams.\n\n"
      "No one should suffer alone or in silence. By sharing our stories, we can protect each other.\n\n"
      "Anyone can contribute — and together, we can prevent this crisis. I’m committed to expanding Jippin and adding more countries so renters everywhere can benefit from shared knowledge and support.",
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1),
        const SizedBox(height: 15),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildWhatYouCanShareSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🏡 Rental Property Details (If unknown, just write “unknown”)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text(
          "• Country, Province/State, and City\n"
          "• Street Address and Postal Code\n"
          "• Rental Type: Short-term, Long-term, Lump-sum Lease, Daily Rental, Vacation Rental, or Other\n"
          "• Rent and Deposit",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 12),
        Text("👤 Who You Dealt With (If unknown, just write “unknown”)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text("• Landlord Name\n• Realtor or Rental Platform", style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildRatingSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildWhyItMattersSection() {
    return const Text(
      "Every review helps build a safer, more transparent rental market:\n\n"
      "• Exposes dishonest or discriminatory practices\n"
      "• Highlights trustworthy and respectful landlords and agents\n"
      "• Helps protect newcomers, students, and vulnerable renters\n"
      "• Fights fraud and rental scams through shared knowledge",
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildContributionMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.handshake_outlined, size: 30, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'icecreambears1@gmail.com',
    );

    return Row(
      children: [
        const Icon(Icons.email_outlined, size: 24, color: Colors.black54),
        const SizedBox(width: 8),
        const Text("Developer Contact:", style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(emailUri)) {
              await launchUrl(emailUri);
            }
          },
          child: Text(
            emailUri.path,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
