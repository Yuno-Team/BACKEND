import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/foundation.dart';

class AmplifyService {
  AmplifyService._();
  static final AmplifyService instance = AmplifyService._();

  bool _configured = false;

  Future<void> configure(String amplifyConfig) async {
    if (_configured) return;
    Amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyAPI(),
      AmplifyStorageS3(),
    ]);
    try {
      await Amplify.configure(amplifyConfig);
      _configured = true;
      debugPrint('Amplify configured');
    } on AmplifyAlreadyConfiguredException {
      _configured = true;
      debugPrint('Amplify already configured');
    } catch (e) {
      debugPrint('Amplify configure failed: $e');
    }
  }

  bool get isConfigured => _configured && Amplify.isConfigured;

  Future<AuthUser?> currentUser() async {
    try {
      return await Amplify.Auth.getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  Future<void> signInWithKakao() async {
    await Amplify.Auth.signInWithWebUI(
      provider: const AuthProvider.oidc('kakao', 'https://kauth.kakao.com'),
    );
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }
}

