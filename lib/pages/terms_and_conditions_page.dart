import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/component/footer.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(local.terms_title),
            _SectionBody(local.terms_effective_date),
            _SectionBody(local.terms_intro),
            _SectionTitle(local.terms_section1_title),
            _SectionBody(local.terms_section1_body),
            _SectionTitle(local.terms_section2_title),
            _SectionBody(local.terms_section2_body),
            _SectionTitle(local.terms_section3_title),
            _SectionBody(local.terms_section3_body),
            _SectionTitle(local.terms_section4_title),
            _SectionBody(local.terms_section4_body),
            _SectionTitle(local.terms_section5_title),
            _SectionBody(local.terms_section5_body),
            _SectionTitle(local.terms_section6_title),
            _SectionBody(local.terms_section6_body),
            _SectionTitle(local.terms_section7_title),
            _SectionBody(local.terms_section7_body),
            _SectionTitle(local.terms_section8_title),
            _SectionBody(local.terms_section8_body),
            _SectionTitle(local.terms_section9_title),
            _SectionBody(local.terms_section9_body),
            _SectionTitle(local.terms_section10_title),
            _SectionBody(local.terms_section10_body),
            _SectionTitle(local.terms_section11_title),
            _SectionBody(local.terms_section11_body),
            const SizedBox(height: 30),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  final String text;
  const _SectionBody(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, height: 1.6),
    );
  }
}
