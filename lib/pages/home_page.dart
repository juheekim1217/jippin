import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalPageLayoutScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //AutocompleteTest(),
          //DropdownMenuSample(),
          // Welcome header
          Text(
            AppLocalizations.of(context).home_intro1_title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).home_intro1_desc,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 24),

          // Quick Navigation Buttons
          Text(
            AppLocalizations.of(context).home_intro2_title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavigationButton(
                context,
                icon: Icons.list,
                label: AppLocalizations.of(context).home_intro2_desc1,
                route: "/reviews",
              ),
              _buildNavigationButton(
                context,
                icon: Icons.add,
                label: AppLocalizations.of(context).home_intro2_desc2,
                route: "/submit",
              ),
              _buildNavigationButton(
                context,
                icon: Icons.info,
                label: AppLocalizations.of(context).home_intro2_desc3,
                route: "/about",
              ),
            ],
          ),
          SizedBox(height: 32),

          // Highlights section
          Text(
            AppLocalizations.of(context).home_intro3_title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildFeatureCard(
            context,
            title: AppLocalizations.of(context).home_intro3_desc1_title,
            description: AppLocalizations.of(context).home_intro3_desc1,
            icon: Icons.verified,
            color: Colors.blue,
          ),
          _buildFeatureCard(
            context,
            title: AppLocalizations.of(context).home_intro3_desc2_title,
            description: AppLocalizations.of(context).home_intro3_desc2,
            icon: Icons.share,
            color: Colors.green,
          ),
          _buildFeatureCard(
            context,
            title: AppLocalizations.of(context).home_intro3_desc3_title,
            description: AppLocalizations.of(context).home_intro3_desc3,
            icon: Icons.people,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  // Helper method to create navigation buttons
  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 32, color: Colors.blue),
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  // Helper method to create feature cards
  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(60),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
