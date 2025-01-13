import 'package:flutter/material.dart';
import 'package:jippin/style/GlobalScaffold.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Text(
                "Hello, Renter!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "JIPPIN helps you find the best rental experiences by connecting you with reliable landlord reviews and resources.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 24),

              // Quick Navigation Buttons
              Text(
                "Get Started:",
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
                    label: "Browse Reviews",
                    route: "/Reviews",
                  ),
                  _buildNavigationButton(
                    context,
                    icon: Icons.add,
                    label: "Submit Review",
                    route: "/Submit",
                  ),
                  _buildNavigationButton(
                    context,
                    icon: Icons.info,
                    label: "About",
                    route: "/About",
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Highlights section
              Text(
                "Why Choose JIPPIN?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildFeatureCard(
                context,
                title: "Verified Reviews",
                description:
                    "Read honest reviews from real tenants about their experiences.",
                icon: Icons.verified,
                color: Colors.blue,
              ),
              _buildFeatureCard(
                context,
                title: "Submit Your Story",
                description:
                    "Share your renting journey and help others make informed decisions.",
                icon: Icons.share,
                color: Colors.green,
              ),
              _buildFeatureCard(
                context,
                title: "Community Support",
                description:
                    "Connect with renters like you to find trusted advice and support.",
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
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
