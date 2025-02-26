import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/component/footer.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(AppLocalizations.of(context).privacy_privacyTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_privacyDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_informationCollectionTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_informationCollectionDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_cookiesTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_cookiesDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_informationSharingTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_informationSharingDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_dataSecurityTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_dataSecurityDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_childrenTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_childrenDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_analyticsTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_analyticsDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_botDetectionTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_botDetectionDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_advertisingTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_advertisingDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_gdprTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_gdprDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_dsaTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_dsaDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_policyChangesTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_policyChangesDescription),

            _buildSectionTitle(AppLocalizations.of(context).privacy_contactTitle),
            _buildParagraph(AppLocalizations.of(context).privacy_contactDescription),

            // 📌 Footer (Not Sticky, Appears After All Content)
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }
}
