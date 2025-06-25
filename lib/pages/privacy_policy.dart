import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/component/footer.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(local.privacy_privacyTitle),
            _buildParagraph(local.privacy_privacyDescription),
            _buildSectionTitle(local.privacy_informationCollectionTitle),
            _buildParagraph(local.privacy_informationCollectionDescription),
            _buildSectionTitle(local.privacy_cookiesTitle),
            _buildParagraph(local.privacy_cookiesDescription),
            _buildSectionTitle(local.privacy_informationSharingTitle),
            _buildParagraph(local.privacy_informationSharingDescription),
            _buildSectionTitle(local.privacy_dataSecurityTitle),
            _buildParagraph(local.privacy_dataSecurityDescription),
            _buildSectionTitle(local.privacy_childrenTitle),
            _buildParagraph(local.privacy_childrenDescription),
            _buildSectionTitle(local.privacy_botDetectionTitle),
            _buildParagraph(local.privacy_botDetectionDescription),
            _buildSectionTitle(local.privacy_advertisingTitle),
            _buildParagraph(local.privacy_advertisingDescription),
            _buildSectionTitle(local.privacy_thirdPartyCollectionTitle),
            _buildParagraph(local.privacy_thirdPartyCollectionDescription),
            _buildSectionTitle(local.privacy_gdprTitle),
            _buildParagraph(local.privacy_gdprDescription),
            _buildSectionTitle(local.privacy_dsaTitle),
            _buildParagraph(local.privacy_dsaDescription),
            _buildSectionTitle(local.privacy_policyChangesTitle),
            _buildParagraph(local.privacy_policyChangesDescription),
            _buildSectionTitle(local.privacy_contactTitle),
            _buildParagraph(local.privacy_contactDescription),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14.0),
      ),
    );
  }
}
