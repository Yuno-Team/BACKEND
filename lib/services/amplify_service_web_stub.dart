class AmplifyService {
  AmplifyService._();
  static final AmplifyService instance = AmplifyService._();

  Future<void> configure(String amplifyConfig) async {}
  bool get isConfigured => false;

  Future<dynamic> currentUser() async => null;

  Future<void> signInWithKakao() async {
    // No-op on web. Consider showing a message in UI if needed.
  }

  Future<void> signOut() async {}
}

