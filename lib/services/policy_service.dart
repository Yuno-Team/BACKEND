import '../models/policy.dart';
import '../models/policy_filter.dart';
import 'api_service.dart';

class PolicyService {
  static final PolicyService _instance = PolicyService._internal();
  factory PolicyService() => _instance;
  PolicyService._internal();

  final ApiService _apiService = ApiService();

  /// 추천 정책 조회 (사용자 관심사 기반)
  Future<List<Policy>> getRecommendedPolicies({
    List<String> interests = const [],
  }) async {
    try {
      final queryParams = <String, String>{};

      if (interests.isNotEmpty) {
        queryParams['interests'] = interests.join(',');
      }
      queryParams['limit'] = '2';

      final response = await _apiService.get(
        '/policies/recommended',
        queryParams: queryParams,
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> policiesData = response['data'];
        return policiesData.map((json) => Policy.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('추천 정책 조회 오류: $e');
      return [];
    }
  }

  /// 인기 정책 TOP N 조회
  Future<List<Policy>> getPopularPolicies() async {
    try {
      final response = await _apiService.get(
        '/policies/popular',
        queryParams: {'limit': '3'},
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> policiesData = response['data'];
        return policiesData.map((json) => Policy.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('인기 정책 조회 오류: $e');
      return [];
    }
  }

  /// 마감 임박 정책 조회
  Future<List<Policy>> getUpcomingDeadlines() async {
    try {
      final response = await _apiService.get(
        '/policies/upcoming',
        queryParams: {'limit': '3'},
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> policiesData = response['data'];
        return policiesData.map((json) => Policy.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('마감 임박 정책 조회 오류: $e');
      return [];
    }
  }

  /// 정책 검색 (필터 지원)
  Future<List<Policy>> searchPolicies({
    String? query,
    PolicyFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      // 검색어 추가
      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }

      // 필터가 있으면 모든 필터 파라미터를 추가
      if (filter != null) {
        final filterJson = filter.toApiJson();
        filterJson.forEach((key, value) {
          if (value != null) {
            queryParams[key] = value.toString();
          }
        });
      }

      final response = await _apiService.get(
        '/policies/search',
        queryParams: queryParams,
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> policiesData = response['data'];
        return policiesData.map((json) => Policy.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('정책 검색 오류: $e');
      return [];
    }
  }

  /// 정책 검색 (간단한 버전 - 하위 호환성)
  Future<List<Policy>> searchPoliciesSimple(String query, {
    String? mainCategory,
    String? region,
    int page = 1,
    int limit = 20,
  }) async {
    final filter = PolicyFilter(
      mainCategory: mainCategory,
      region: region,
    );

    return searchPolicies(
      query: query.isNotEmpty ? query : null,
      filter: filter,
      page: page,
      limit: limit,
    );
  }

  /// 정책 상세 조회
  Future<Policy?> getPolicyDetail(String policyId) async {
    try {
      final response = await _apiService.get('/policies/$policyId');

      if (response['success'] == true && response['data'] != null) {
        return Policy.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      print('정책 상세 조회 오류: $e');
      return null;
    }
  }

  /// 정책 북마크 추가
  Future<bool> bookmarkPolicy(String policyId) async {
    try {
      // TODO: 백엔드 북마크 API 구현 후 연동
      // final response = await _apiService.post(
      //   '/bookmarks/$policyId',
      //   {},
      //   requiresAuth: true,
      // );
      // return response['success'] == true;

      await Future.delayed(Duration(milliseconds: 200));
      return true;
    } catch (e) {
      print('북마크 추가 오류: $e');
      return false;
    }
  }

  /// 정책 북마크 해제
  Future<bool> unbookmarkPolicy(String policyId) async {
    try {
      // TODO: 백엔드 북마크 API 구현 후 연동
      // final response = await _apiService.delete(
      //   '/bookmarks/$policyId',
      //   requiresAuth: true,
      // );
      // return response['success'] == true;

      await Future.delayed(Duration(milliseconds: 200));
      return true;
    } catch (e) {
      print('북마크 해제 오류: $e');
      return false;
    }
  }

  /// 저장된 정책 목록 조회
  Future<List<Policy>> getSavedPolicies() async {
    try {
      // TODO: 백엔드 북마크 API 구현 후 연동
      // final response = await _apiService.get(
      //   '/bookmarks',
      //   requiresAuth: true,
      // );
      //
      // if (response['success'] == true && response['data'] != null) {
      //   final List<dynamic> policiesData = response['data'];
      //   return policiesData.map((json) => Policy.fromJson(json)).toList();
      // }

      return [];
    } catch (e) {
      print('저장된 정책 조회 오류: $e');
      return [];
    }
  }
}
