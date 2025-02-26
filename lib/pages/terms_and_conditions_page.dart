import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/component/footer.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(AppLocalizations.of(context).terms_title),
            _buildParagraph(AppLocalizations.of(context).terms_description),
            _buildSectionTitle(AppLocalizations.of(context).terms_acceptanceTitle),
            _buildParagraph(AppLocalizations.of(context).terms_acceptanceDescription),
            _buildSectionTitle(AppLocalizations.of(context).terms_contentTitle),
            _buildParagraph(AppLocalizations.of(context).terms_contentDescription),
            _buildSectionTitle(AppLocalizations.of(context).terms_userContentTitle),
            _buildParagraph(AppLocalizations.of(context).terms_userContentDescription),
            _buildSectionTitle(AppLocalizations.of(context).terms_disclaimerTitle),
            _buildParagraph(AppLocalizations.of(context).terms_disclaimerDescription),
            _buildSectionTitle(AppLocalizations.of(context).terms_liabilityTitle),
            _buildParagraph(AppLocalizations.of(context).terms_liabilityDescription),
            _buildSectionTitle(AppLocalizations.of(context).terms_thirdPartyTitle),
            _buildParagraph(AppLocalizations.of(context).terms_thirdPartyDescription),
            _buildSectionTitle(AppLocalizations.of(context).terms_governingLawTitle),
            _buildParagraph(AppLocalizations.of(context).terms_governingLawDescription),
            _buildSectionTitle(AppLocalizations.of(context).terms_amendmentsTitle),
            _buildParagraph(AppLocalizations.of(context).terms_amendmentsDescription),
            _buildSectionTitle(AppLocalizations.of(context).terms_contactTitle),
            _buildParagraph(AppLocalizations.of(context).terms_contactDescription),

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
