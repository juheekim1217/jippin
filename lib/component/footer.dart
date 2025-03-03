import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      //color: Colors.grey.shade50, // Soft background for a clean look
      child: Column(
        children: [
          // 📜 Soft Divider
          Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
          const SizedBox(height: 12),

          // 🔒 Legal Links (Privacy & Terms)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              _buildFooterLink(context, localizations.terms_and_conditions, "/terms"),
              _buildFooterLink(context, localizations.privacy_policy, "/privacy"),
            ],
          ),
          const SizedBox(height: 16),

          // 📍 Privacy Notice
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_person, // You can change this to Icons.lock or Icons.security
                color: Colors.black54,
                size: 16, // Adjust size to match text
              ),
              const SizedBox(width: 6), // Add spacing between icon and text
              Flexible(
                child: Text(
                  localizations.appMission, // Use localization text
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.black54),
                  softWrap: true, // Ensures wrapping
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ⚖️ Copyright & Branding
          Text(
            "© 2025 JIPPIN. All rights reserved.",
            style: GoogleFonts.notoSans(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 🔗 Footer Link Helper
  Widget _buildFooterLink(BuildContext context, String text, String route) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click, // Changes cursor to pointer on hover
        child: GestureDetector(
          onTap: () => context.go(route),
          child: Text(
            text,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
