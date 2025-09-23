import '../models/policy.dart';
import 'api_service.dart';

class PolicyService {
  static final PolicyService _instance = PolicyService._internal();
  factory PolicyService() => _instance;
  PolicyService._internal();

  final ApiService _apiService = ApiService();

  Future<List<Policy>> getRecommendedPolicies({
    List<String> interests = const [],
  }) async {
    return await _apiService.getRecommendedPolicies();
  }

  Future<List<Policy>> getPopularPolicies() async {
    return await _apiService.getPopularPolicies();
  }

  Future<List<Policy>> getUpcomingDeadlines() async {
    return await _apiService.getDeadlinePolicies();
  }

  Future<List<Policy>> searchPolicies(String query) async {
    return await _apiService.getPolicies(search: query);
  }

  Future<List<Policy>> getPoliciesByCategory(String category) async {
    return await _apiService.getPolicies(category: category);
  }

  Future<Policy?> getPolicyById(String id) async {
    final policy = await _apiService.getPolicyById(id);
    if (policy != null) {
      // Track view interaction
      await _apiService.trackPolicyInteraction(
        policyId: id,
        action: 'view',
      );
    }
    return policy;
  }

  Future<List<Policy>> getBookmarkedPolicies() async {
    return await _apiService.getBookmarks();
  }

  Future<bool> bookmarkPolicy(String policyId) async {
    final success = await _apiService.addBookmark(policyId);
    if (success) {
      await _apiService.trackPolicyInteraction(
        policyId: policyId,
        action: 'bookmark',
      );
    }
    return success;
  }

  Future<bool> unbookmarkPolicy(String policyId) async {
    return await _apiService.removeBookmark(policyId);
  }

  Future<void> trackPolicyShare(String policyId) async {
    await _apiService.trackPolicyInteraction(
      policyId: policyId,
      action: 'share',
    );
  }

  Future<void> trackPolicyClick(String policyId) async {
    await _apiService.trackPolicyInteraction(
      policyId: policyId,
      action: 'click',
    );
  }
}
