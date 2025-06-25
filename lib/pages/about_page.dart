import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/component/footer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context);

    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeaderSection(local),
            _buildPersonalStorySection(local),
            _buildSectionTitle(local.about_section_what_you_can_share),
            _buildWhatYouCanShareSection(local),
            _buildSectionTitle(local.about_section_ratings),
            _buildRatingSection(
              icon: Icons.shield_outlined,
              title: local.about_rating_trust_title,
              description: local.about_rating_trust_description,
            ),
            _buildRatingSection(
              icon: Icons.attach_money_outlined,
              title: local.about_rating_price_title,
              description: local.about_rating_price_description,
            ),
            _buildRatingSection(
              icon: Icons.location_on_outlined,
              title: local.about_rating_location_title,
              description: local.about_rating_location_description,
            ),
            _buildRatingSection(
              icon: Icons.home_repair_service_outlined,
              title: local.about_rating_condition_title,
              description: local.about_rating_condition_description,
            ),
            _buildSectionTitle(local.about_section_why_it_matters),
            _buildWhyItMattersSection(local),
            const SizedBox(height: 30),
            _buildContributionMessage(local.about_contribution_message),
            const SizedBox(height: 20),
            _buildContactSection(local),
            const SizedBox(height: 30),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(AppLocalizations local) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(local.about_title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(local.about_subtitle, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPersonalStorySection(AppLocalizations local) {
    return Text(local.about_personal_story, style: const TextStyle(fontSize: 16));
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

  Widget _buildWhatYouCanShareSection(AppLocalizations local) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(local.about_what_rental_title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(local.about_what_rental_body, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 12),
        Text(local.about_what_who_title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(local.about_what_who_body, style: const TextStyle(fontSize: 16)),
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

  Widget _buildWhyItMattersSection(AppLocalizations local) {
    return Text(local.about_why_it_matters, style: const TextStyle(fontSize: 16));
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
          Expanded(child: Text(message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent))),
        ],
      ),
    );
  }

  Widget _buildContactSection(AppLocalizations local) {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'icecreambears1@gmail.com',
    );

    return Row(
      children: [
        const Icon(Icons.email_outlined, size: 24, color: Colors.black54),
        const SizedBox(width: 8),
        Text(local.about_contact_label, style: const TextStyle(fontSize: 16)),
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
