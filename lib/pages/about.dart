import 'package:flutter/material.dart';
import 'package:jippin/style/GlobalScaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome to Rent Review',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The Rent Review app helps tenants share their experiences with landlords and real estate agents, providing transparency and helping future renters make informed decisions.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Review Fields and Rating Technique',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Trustworthiness Rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The Trustworthiness Rating reflects how reliable and honest the landlord or real estate agent is in their dealings. Rate the landlord/agent based on transparency, ethical practices, and whether promises are kept.',
                style: TextStyle(fontSize: 16),
              ),
              _buildRatingExplanation([
                '1 Star: Very untrustworthy – Major issues with dishonesty or failure to follow through on promises.',
                '2 Stars: Untrustworthy – Some issues with transparency or reliability.',
                '3 Stars: Neutral – No major issues, but not particularly reliable.',
                '4 Stars: Trustworthy – Generally reliable, with few issues.',
                '5 Stars: Very trustworthy – Completely transparent and dependable in all dealings.',
              ]),
              SizedBox(height: 20),
              Text(
                '2. Respect Rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The Respect Rating reflects how the landlord or real estate agent treats you. This includes politeness, attentiveness to concerns, and overall professionalism.',
                style: TextStyle(fontSize: 16),
              ),
              _buildRatingExplanation([
                '1 Star: Very disrespectful – Rude or dismissive communication.',
                '2 Stars: Disrespectful – Occasional unprofessional behavior or lack of courtesy.',
                '3 Stars: Neutral – Adequate but not particularly respectful or disrespectful.',
                '4 Stars: Respectful – Generally polite and attentive, with minor issues.',
                '5 Stars: Very respectful – Always considerate, courteous, and professional.',
              ]),
              SizedBox(height: 20),
              Text(
                'Additional Review Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'In addition to the Trustworthiness and Respect Ratings, users can leave comments to provide more context on their experiences. They can also answer the following optional questions:',
                style: TextStyle(fontSize: 16),
              ),
              _buildAdditionalReviewQuestions(),
              SizedBox(height: 20),
              Text(
                'By contributing to Rent Review, you’re helping other renters find reliable and respectful landlords and agents, creating a more transparent rental market for everyone.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
  }

  Widget _buildRatingExplanation(List<String> explanations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: explanations
          .map((explanation) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  explanation,
                  style: TextStyle(fontSize: 16),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildAdditionalReviewQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '• Was there a contract dispute? – Indicate if you encountered any issues with the lease agreement.',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '• Did the landlord/agent provide accurate information? – Rate whether the information given was truthful and clear.',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '• Did you experience any discriminatory behavior? – Optional, to assess how inclusive the landlord/agent was.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
