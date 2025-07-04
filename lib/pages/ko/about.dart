import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/component/footer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPageKo extends StatelessWidget {
  const AboutPageKo({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeaderSection(),
            _buildPersonalStorySection(),
            _buildSectionTitle("공유할 수 있는 내용"),
            _buildWhatYouCanShareSection(),
            _buildSectionTitle("상태 및 경험 평가"),
            _buildRatingSection(
              icon: Icons.shield_outlined,
              title: "신뢰도",
              description: "집주인 또는 중개인이 약속을 지키고 정직하게 행동했나요?",
            ),
            _buildRatingSection(
              icon: Icons.attach_money_outlined,
              title: "가격",
              description: "가격이 제공된 가치에 비해 합리적이었나요?",
            ),
            _buildRatingSection(
              icon: Icons.location_on_outlined,
              title: "위치",
              description: "지역이 편리하고 안전하며 접근성이 좋았나요?",
            ),
            _buildRatingSection(
              icon: Icons.home_repair_service_outlined,
              title: "상태",
              description: "집 상태가 청결하고 안전하며 잘 관리되고 있었나요?",
            ),
            _buildSectionTitle("왜 중요한가요?"),
            _buildWhyItMattersSection(),
            const SizedBox(height: 30),
            _buildContributionMessage("모든 리뷰는 익명으로 처리됩니다. 당신의 경험 공유는 다른 이들이 나쁜 임대를 피하고 더 나은 집을 찾는 데 큰 도움이 됩니다."),
            const SizedBox(height: 20),
            _buildContactSection(),
            const SizedBox(height: 30),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("지핀 소개", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(
          "세입자가 더 안전하게 집을 고를 수 있고 더 나아가 전세 사기를 피하도록 돕습니다.",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPersonalStorySection() {
    return const Text(
      "한국에서 전세 사기로 인해 청년들이 극단적인 선택을 했다는 뉴스를 보고 지핀을 만들게 되었습니다.\n\n"
      "누구도 사기로 인해 고통받아서는 안 됩니다. 세입자들이 겪은 이야기를 익명으로 공유함으로써 서로를 지킬 수 있습니다.\n\n"
      "누구나 참여할 수 있고, 함께하면 이런 사기를 예방할 수 있습니다. 지핀은 앞으로 지속적으로 사이트를 보완할 예정이고 "
      "더 많은 나라로 확장할 예정입니다. 전 세계 세입자들이 정보를 나누고 서로를 도울 수 있도록 만들겠습니다.",
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1),
        const SizedBox(height: 15),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildWhatYouCanShareSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🏡 임대 부동산 정보 (모르면 “모름”으로 작성하세요)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text(
          "• 국가, 도/주, 도시\n"
          "• 도로명 주소 및 우편번호\n"
          "• 임대 유형: 단기, 장기, 전세, 일일 임대, 휴가용 임대, 기타\n"
          "• 월세 및 보증금",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 12),
        Text("👤 임대 관련 인물 (모르면 “모름”으로 작성하세요)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text("• 집주인 이름\n• 부동산 중개인 또는 플랫폼 이름", style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildRatingSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildWhyItMattersSection() {
    return const Text(
      "리뷰 하나하나가 더 안전하고 투명한 임대 시장을 만듭니다:\n\n"
      "• 사기 및 차별 행위를 드러냅니다\n"
      "• 믿을 수 있고 존중하는 집주인과 중개인을 알려줍니다\n"
      "• 신입 세입자, 학생, 취약 계층을 보호합니다\n"
      "• 집단의 경험을 바탕으로 사기를 예방합니다",
      style: TextStyle(fontSize: 16),
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

  Widget _buildContactSection() {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'icecreambears1@gmail.com',
    );

    return Row(
      children: [
        const Icon(Icons.email_outlined, size: 24, color: Colors.black54),
        const SizedBox(width: 8),
        const Text("개발자 문의 이메일:", style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(emailUri)) {
              await launchUrl(emailUri);
            }
          },
          child: Text(
            emailUri.path,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
