import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAuthenticated => _apiService.isAuthenticated && _currentUser != null;

  Future<void> initialize() async {
    _apiService.initialize();

    // Load current user if authenticated
    if (_apiService.isAuthenticated) {
      _currentUser = await _apiService.getCurrentUser();
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) return false;

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? accessToken = auth.accessToken;
      final String? idToken = auth.idToken;

      if (accessToken == null) return false;

      _currentUser = await _apiService.socialLogin(
        provider: 'google',
        accessToken: accessToken,
        idToken: idToken,
      );

      return _currentUser != null;
    } catch (e) {
      print('Google sign in error: $e');
      return false;
    }
  }

  Future<bool> signInWithNaver() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status != NaverLoginStatus.loggedIn) return false;

      final NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;

      _currentUser = await _apiService.socialLogin(
        provider: 'naver',
        accessToken: token.accessToken,
      );

      return _currentUser != null;
    } catch (e) {
      print('Naver sign in error: $e');
      return false;
    }
  }

  Future<bool> signInWithKakao() async {
    try {
      kakao.OAuthToken? token;

      if (await kakao.isKakaoTalkInstalled()) {
        token = await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      _currentUser = await _apiService.socialLogin(
        provider: 'kakao',
        accessToken: token.accessToken,
      );

      return _currentUser != null;
    } catch (e) {
      print('Kakao sign in error: $e');
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      if (!Platform.isIOS) return false;

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken == null) return false;

      _currentUser = await _apiService.socialLogin(
        provider: 'apple',
        accessToken: credential.authorizationCode,
        idToken: credential.identityToken,
      );

      return _currentUser != null;
    } catch (e) {
      print('Apple sign in error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      // Sign out from social providers
      await GoogleSignIn().signOut();
      await FlutterNaverLogin.logOut();
      await kakao.UserApi.instance.logout();
    } catch (e) {
      print('Social logout error: $e');
    }

    await _apiService.signOut();
    _currentUser = null;
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
      if (_currentUser == null) return false;

      final success = await _apiService.updateUserProfile(
        birthDate: birthDate,
        region: region,
        school: school,
        education: education,
        major: major,
        interests: interests,
      );

      if (success) {
        _currentUser = _currentUser!.copyWith(
          birthDate: birthDate,
          region: region,
          school: school,
          education: education,
          major: major,
          interests: interests,
        );
      }

      return success;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<void> refreshUserData() async {
    if (_apiService.isAuthenticated) {
      _currentUser = await _apiService.getCurrentUser();
    }
  }
}
