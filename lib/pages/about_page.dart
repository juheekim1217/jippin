import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/component/footer.dart';

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
            _buildHeaderSection(context, local.about_title, local.about_description),
            _buildSectionTitle(local.about_review_fields_title),
            _buildReviewCriteriaSection(
              context,
              icon: Icons.shield_outlined,
              title: local.about_trustworthiness_title,
              description: local.about_trustworthiness_description,
              ratingLabels: [
                local.about_trustworthiness_1_star,
                local.about_trustworthiness_2_star,
                local.about_trustworthiness_3_star,
                local.about_trustworthiness_4_star,
                local.about_trustworthiness_5_star,
              ],
            ),
            _buildReviewCriteriaSection(
              context,
              icon: Icons.emoji_people_outlined,
              title: local.about_respect_title,
              description: local.about_respect_description,
              ratingLabels: [
                local.about_respect_1_star,
                local.about_respect_2_star,
                local.about_respect_3_star,
                local.about_respect_4_star,
                local.about_respect_5_star,
              ],
            ),
            _buildAdditionalDetailsSection(local),
            const SizedBox(height: 30),
            _buildContributionMessage(local.about_contribute_message),

            // 📌 Footer (Not Sticky, Appears After All Content)
            const SizedBox(height: 30),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1),
        const SizedBox(height: 15),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildReviewCriteriaSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required List<String> ratingLabels,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 16)),
        _buildRatingList(ratingLabels),
      ],
    );
  }

  Widget _buildRatingList(List<String> ratings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ratings.map((rating) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.star, size: 20, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(child: Text(rating, style: const TextStyle(fontSize: 16))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdditionalDetailsSection(AppLocalizations local) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(local.about_additional_details_title),
        Text(
          local.about_additional_details_description,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        _buildQuestionItem(Icons.assignment_late_outlined, local.about_question_contract_dispute),
        _buildQuestionItem(Icons.info_outline, local.about_question_accurate_info),
        _buildQuestionItem(Icons.gavel_outlined, local.about_question_discriminatory_behavior),
      ],
    );
  }

  Widget _buildQuestionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
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
}
