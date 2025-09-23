import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/policy_service.dart';
import '../models/policy.dart';

class HomeScreen extends StatefulWidget {
  final List<String> selectedInterests;
  final Map<String, String> profileData;
  
  HomeScreen({
    required this.selectedInterests,
    required this.profileData,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PolicyService _policyService = PolicyService();

  List<Policy> _recommendedPolicies = [];
  List<Policy> _popularPolicies = [];
  List<Policy> _deadlinePolicies = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPolicyData();
  }

  Future<void> _loadPolicyData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // 병렬로 API 호출
      final results = await Future.wait([
        _policyService.getRecommendedPolicies(interests: widget.selectedInterests),
        _policyService.getPopularPolicies(),
        _policyService.getUpcomingDeadlines(),
      ]);

      setState(() {
        _recommendedPolicies = results[0];
        _popularPolicies = results[1];
        _deadlinePolicies = results[2];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'API 데이터를 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
      print('Policy data loading error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '추천 배너',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // AI 추천 정책 섹션
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘의 추천 정책 (AI 기반)',
                      style: GoogleFonts.notoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: 16),

                    // 추천 정책 카드들
                    if (_isLoading)
                      Center(child: CircularProgressIndicator())
                    else if (_error != null)
                      Text(
                        _error!,
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      )
                    else if (_recommendedPolicies.isEmpty)
                      Text(
                        '추천 정책이 없습니다.',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      )
                    else
                      ...(_recommendedPolicies.take(2).map((policy) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: _buildPolicyCard(
                            title: policy.title,
                            category: policy.category,
                            status: policy.applicationPeriod,
                          ),
                        )
                      ).toList()),
                    
                    SizedBox(height: 16),
                    
                    Center(
                      child: Text(
                        '더보기 >',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // 유용 일정 배너
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '오늘이 신청마감인 정책이 있어요!',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // 인기 정책 섹션
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '인기 정책',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    '인기 정책 TOP3',
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // TOP3 정책 카드들
                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (_popularPolicies.isEmpty)
                    Text(
                      '인기 정책이 없습니다.',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    ...(_popularPolicies.take(3).asMap().entries.map((entry) {
                      int index = entry.key;
                      Policy policy = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: _buildTopPolicyCard(
                          policy.title,
                          policy.category,
                          policy.applicationPeriod,
                          '${index + 1}위',
                        ),
                      );
                    }).toList()),
                ],
              ),
              
              SizedBox(height: 40),
              
              // 마감 임박 정책 섹션
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '내가 저장한 일정 관련 안내',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    '다가오는 일정',
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // 마감 임박 정책 카드들
                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (_deadlinePolicies.isEmpty)
                    Text(
                      '마감 임박 정책이 없습니다.',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    ...(_deadlinePolicies.take(3).map((policy) =>
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: _buildUpcomingCard(
                          policy.title,
                          '신청 마감',
                          policy.applicationPeriod,
                        ),
                      )
                    ).toList()),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '탐색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: '일정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이',
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required String category,
    required String status,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                category,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Text(
            status,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPolicyCard(
    String title,
    String category,
    String status,
    String saves,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      status,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            saves,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(
    String title,
    String eventType,
    String date,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  eventType,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
