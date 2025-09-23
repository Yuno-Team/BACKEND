import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart' as app_models;
import '../models/policy.dart';
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  String? _accessToken;
  String? _refreshToken;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && await _refreshAccessToken()) {
            final req = error.requestOptions;
            req.headers['Authorization'] = 'Bearer $_accessToken';
            try {
              final retry = await _dio.fetch(req);
              handler.resolve(retry);
              return;
            } catch (_) {}
          }
          handler.next(error);
        },
      ),
    );

    _loadTokensFromStorage();
  }

  Future<void> _loadTokensFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
  }

  Future<void> _saveTokensToStorage(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  Future<void> _clearTokensFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _accessToken = null;
    _refreshToken = null;
  }

  Map<String, dynamic> _unpack(dynamic body) {
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) return data;
      return body;
    }
    return <String, dynamic>{};
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;
    try {
      final resp = await _dio.post('/auth/refresh', data: {
        'refreshToken': _refreshToken,
      });
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        final tokens = (data['tokens'] ?? data) as Map<String, dynamic>;
        await _saveTokensToStorage(
          tokens['accessToken'] as String,
          tokens['refreshToken'] as String,
        );
        return true;
      }
    } catch (e) {
      // ignore
    }
    return false;
  }

  // Auth
  Future<app_models.User?> socialLogin({
    required String provider,
    String? accessToken,
    String? idToken,
  }) async {
    try {
      final resp = await _dio.post('/auth/social-login', data: {
        'provider': provider,
        if (accessToken != null) 'accessToken': accessToken,
        if (idToken != null) 'idToken': idToken,
      });
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        final tokens = data['tokens'] as Map<String, dynamic>;
        final user = data['user'] as Map<String, dynamic>;
        await _saveTokensToStorage(
          tokens['accessToken'] as String,
          tokens['refreshToken'] as String,
        );
        return app_models.User.fromJson(user);
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  Future<app_models.User?> getCurrentUser() async {
    try {
      final resp = await _dio.get('/users/me');
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        return app_models.User.fromJson(data);
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  Future<bool> updateUserProfile({
    DateTime? birthDate,
    String? region,
    String? school,
    String? education,
    String? major,
    List<String>? interests,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (birthDate != null) payload['birth_date'] = birthDate.toIso8601String();
      if (region != null) payload['region'] = region;
      if (school != null) payload['school'] = school;
      if (education != null) payload['education'] = education;
      if (major != null) payload['major'] = major;
      if (interests != null) payload['interests'] = interests;

      final resp = await _dio.put('/users/me', data: payload);
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {
      // ignore
    } finally {
      await _clearTokensFromStorage();
    }
  }

  // Policies
  Future<List<Policy>> getPolicies({
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final qp = <String, dynamic>{'page': page, 'limit': limit};
      if (category != null) qp['category'] = category;
      if (search != null) qp['search'] = search;
      final resp = await _dio.get('/policies', queryParameters: qp);
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        final list = (data['policies'] ?? []) as List<dynamic>;
        return list.map((e) => Policy.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Policy>> getPopularPolicies() async {
    try {
      final resp = await _dio.get('/policies/lists/popular');
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        final list = (data['policies'] ?? []) as List<dynamic>;
        return list.map((e) => Policy.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Policy>> getDeadlinePolicies() async {
    try {
      final resp = await _dio.get('/policies/lists/deadline');
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        final list = (data['policies'] ?? []) as List<dynamic>;
        return list.map((e) => Policy.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Policy>> getRecommendedPolicies() async {
    try {
      final resp = await _dio.get('/policies/lists/recommendations');
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        final list = (data['policies'] ?? []) as List<dynamic>;
        return list.map((e) => Policy.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<Policy?> getPolicyById(String id) async {
    try {
      final resp = await _dio.get('/policies/$id');
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        return Policy.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  // Bookmarks
  Future<List<Policy>> getBookmarks() async {
    try {
      final resp = await _dio.get('/users/me/bookmarks');
      if (resp.statusCode == 200) {
        final data = _unpack(resp.data);
        final list = (data['bookmarks'] ?? []) as List<dynamic>;
        return list.map((e) => Policy.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> addBookmark(String policyId) async {
    try {
      final resp = await _dio.post('/users/me/bookmarks', data: {'policyId': policyId});
      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeBookmark(String policyId) async {
    try {
      final resp = await _dio.delete('/users/me/bookmarks/$policyId');
      return resp.statusCode == 200 || resp.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  Future<void> trackPolicyInteraction({
    required String policyId,
    required String action,
  }) async {
    try {
      await _dio.post('/policies/$policyId/interact', data: {'action': action});
    } catch (_) {
      // ignore
    }
  }

  bool get isAuthenticated => _accessToken != null;
}
