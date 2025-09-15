import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'interest_selection_screen.dart';

class ProfileInputScreen extends StatefulWidget {
  ProfileInputScreen();

  @override
  _ProfileInputScreenState createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _regionController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _majorController = TextEditingController();
  
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    
    // 텍스트 필드 변경 감지
    _birthDateController.addListener(_checkFormValidity);
    _regionController.addListener(_checkFormValidity);
    _schoolController.addListener(_checkFormValidity);
    _educationController.addListener(_checkFormValidity);
    _majorController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _birthDateController.text.isNotEmpty &&
                    _regionController.text.isNotEmpty &&
                    _schoolController.text.isNotEmpty &&
                    _educationController.text.isNotEmpty &&
                    _majorController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    _regionController.dispose();
    _schoolController.dispose();
    _educationController.dispose();
    _majorController.dispose();
    super.dispose();
  }

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
                '프로필 정보를 입력해주세요',
                style: GoogleFonts.notoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 60),
              
              // 입력 폼
              Form(
                key: _formKey,
                child: Column(
                  children: [
                      _buildInputField(
                        controller: _birthDateController,
                        label: '생년월일(YYMMDD)',
                        hintText: '생년월일을 입력해주세요',
                      ),
                      
                      SizedBox(height: 32),
                      
                      _buildInputField(
                        controller: _regionController,
                        label: '지역',
                        hintText: '거주 지역을 입력해주세요',
                      ),
                      
                      SizedBox(height: 32),
                      
                      _buildInputField(
                        controller: _schoolController,
                        label: '학교',
                        hintText: '학교명을 입력해주세요',
                      ),
                      
                      SizedBox(height: 32),
                      
                      _buildInputField(
                        controller: _educationController,
                        label: '학력',
                        hintText: '학력을 입력해주세요',
                      ),
                      
                      SizedBox(height: 32),
                      
                      _buildInputField(
                        controller: _majorController,
                        label: '전공',
                        hintText: '전공을 입력해주세요',
                      ),
                      
                      SizedBox(height: 60),
                      
                      // 완료 버튼
                      Container(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isFormValid ? _completeProfile : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid ? Colors.white : Colors.grey[700],
                            foregroundColor: _isFormValid ? Colors.black : Colors.grey[500],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            '완료',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: GoogleFonts.notoSans(
            fontSize: 16,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.notoSans(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  void _completeProfile() {
    if (_isFormValid) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InterestSelectionScreen(
            profileData: {
              'birthDate': _birthDateController.text,
              'region': _regionController.text,
              'school': _schoolController.text,
              'education': _educationController.text,
              'major': _majorController.text,
            },
          ),
        ),
      );
    }
  }
}
