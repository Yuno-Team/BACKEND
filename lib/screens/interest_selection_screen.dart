import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'completion_screen.dart';

class InterestSelectionScreen extends StatefulWidget {
  final Map<String, String>? profileData;
  
  InterestSelectionScreen({this.profileData});

  @override
  _InterestSelectionScreenState createState() => _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  List<String> selectedInterests = [];
  
  final List<InterestCategory> interests = [
    InterestCategory('장학금', true),
    InterestCategory('정부지원사업', false),
    InterestCategory('대외활동', true),
    InterestCategory('대회/연구', true),
    InterestCategory('대학생활', false),
    InterestCategory('주거지원', true),
    InterestCategory('취창업', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                           MediaQuery.of(context).padding.top - 
                           MediaQuery.of(context).padding.bottom - 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              SizedBox(height: 40),
              
              // 헤더 텍스트
              Text(
                '관심 분야를 선택해주세요',
                style: GoogleFonts.notoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 8),
              
              Text(
                '3개 이상 선택해주세요',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              
              SizedBox(height: 60),
              
              // 관심 분야 버튼들
              Column(
                children: interests.map((interest) {
                    bool isSelected = selectedInterests.contains(interest.name);
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => _toggleInterest(interest.name),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.grey[800],
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.grey[700]!,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              interest.name,
                              style: GoogleFonts.notoSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ),
              
              SizedBox(height: 40),
              
              // 다음 버튼
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedInterests.length >= 3 ? _goToNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedInterests.length >= 3 
                        ? Colors.white 
                        : Colors.grey[700],
                    foregroundColor: selectedInterests.length >= 3 
                        ? Colors.black 
                        : Colors.grey[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '다음 (${selectedInterests.length}/3)',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  void _goToNext() {
    if (selectedInterests.length >= 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CompletionScreen(
            selectedInterests: selectedInterests,
            profileData: widget.profileData ?? {},
          ),
        ),
      );
    }
  }
}

class InterestCategory {
  final String name;
  final bool isDefault;
  
  InterestCategory(this.name, this.isDefault);
}
