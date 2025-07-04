import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';

class SubmittedPage extends StatelessWidget {
  const SubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              Text(
                local.submitted_review_success_title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                local.submitted_review_success_description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: Text(local.back_to_home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
