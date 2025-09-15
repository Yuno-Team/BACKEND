import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'interest_selection_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              
              // Yuno 로고 이미지
              Image.asset(
                'assets/images/yuno_logo.png',
                height: 120,
                width: 280,
                fit: BoxFit.contain,
              ),
              
              SizedBox(height: 20),
              
              Text(
                '이런 혜택, 알고 있었어?',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              Spacer(flex: 3),
              
              // 소셜 로그인 버튼들
              Column(
                children: [
                  // 구글 로그인 버튼
                  _buildSocialLoginButton(
                    context: context,
                    icon: 'G',
                    text: '구글로 로그인 하기',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onTap: () => _handleGoogleLogin(context),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // 네이버 로그인 버튼
                  _buildSocialLoginButton(
                    context: context,
                    icon: 'N',
                    text: '네이버로 로그인 하기',
                    backgroundColor: Color(0xFF03C75A),
                    textColor: Colors.white,
                    onTap: () => _handleNaverLogin(context),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // 카카오 로그인 버튼
                  _buildSocialLoginButton(
                    context: context,
                    icon: '톡',
                    text: '카카오로 로그인 하기',
                    backgroundColor: Color(0xFFFFE812),
                    textColor: Colors.black,
                    onTap: () => _handleKakaoLogin(context),
                  ),
                ],
              ),
              
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required BuildContext context,
    required String icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: backgroundColor == Colors.white 
                    ? Colors.grey[100] 
                    : backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGoogleLogin(BuildContext context) {
    // TODO: 구글 로그인 로직 구현
    _navigateToNextScreen(context);
  }

  void _handleNaverLogin(BuildContext context) {
    // TODO: 네이버 로그인 로직 구현
    _navigateToNextScreen(context);
  }

  void _handleKakaoLogin(BuildContext context) {
    // TODO: 카카오 로그인 로직 구현
    _navigateToNextScreen(context);
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => InterestSelectionScreen()),
    );
  }
}
