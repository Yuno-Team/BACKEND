import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/foundation.dart';

/// Simple Amplify bootstrapper for the app.
///
/// Usage:
/// 1) Run `amplify init`, add resources, then `amplify push` in repo root.
/// 2) In FE, run `amplify pull` to generate `lib/amplifyconfiguration.dart`.
/// 3) Call `AmplifyService.instance.configure(amplifyconfig)` once at startup.
class AmplifyService {
  AmplifyService._();
  static final AmplifyService instance = AmplifyService._();

  bool _configured = false;

  Future<void> configure(String amplifyConfig) async {
    if (_configured) return;
    // Idempotent: adding same plugin multiple times throws, so guard by `_configured` only.
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
      // If config is placeholder/invalid, keep app running and log.
      debugPrint('Amplify configure failed: $e');
    }
  }

  bool get isConfigured => _configured && Amplify.isConfigured;

  // --- Auth helpers ---
  Future<AuthUser?> currentUser() async {
    try {
      return await Amplify.Auth.getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }
}

