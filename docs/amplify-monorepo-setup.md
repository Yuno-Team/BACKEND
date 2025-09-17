Monorepo setup for Amplify + Flutter (Yuno)

1) Initialize Amplify in repo root (this repo)
- npm i -g @aws-amplify/cli
- amplify configure   # one-time AWS profile
- amplify init        # choose dev env, Flutter, default editor

2) Add backend resources
- amplify add auth    # Cognito Hosted UI, Social: Google + OIDC(Naver/Kakao)
- amplify add api     # AppSync GraphQL + DynamoDB
- optional: amplify add storage  # S3 for images/banners
- amplify push

3) FE (Flutter) connect to backend [Option B]
- Policy: do NOT commit `lib/amplifyconfiguration.dart`.
- Each developer runs per-env pull locally:
  - amplify pull --appId <APP_ID> --envName dev
- This generates `lib/amplifyconfiguration.dart` (ignored by git).
- The app uses Amplify packages declared in pubspec.yaml.

Hosted UI notes (CLI restriction)
- Amplify Gen 1 CLI enforces HTTPS callback URLs during the wizard; mobile deep links like `yuno://auth` are blocked there.
- Workaround for dev: keep `http://localhost/` in the CLI config, then add your app deep links via Cognito console or overrides.
- We preconfigured Hosted UI with domain `yuno-dev-social` and OAuth (code flow, openid/email/profile) in `amplify/backend/auth/*/cli-inputs.json`.

Add deep links after push
- Cognito console → User pools → App integration → App client → Hosted UI
  - Callback URLs: `yuno://auth`, `http://localhost/`
  - Sign-out URLs: `yuno://signout`, `http://localhost/`
- Or use `amplify override auth` and set CallbackURLs/LogoutURLs in overrides to keep IaC.

Free Tier guardrails
- Region: ap-northeast-2 (Seoul)
- DynamoDB: On-demand capacity
- AppSync: Cognito auth; avoid API Keys in prod
- S3: default encryption; keep buckets private
- Logs: set CloudWatch retention to 7 days where applicable

4) Flutter code snippet (init at startup)

import 'package:yuno_app/services/amplify_service.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AmplifyService.instance.configure(amplifyconfig);
  runApp(MyApp());
}

5) Schema (paste into amplify/backend/api/<apiName>/schema.graphql)

See `docs/schema.graphql` for a minimal starter.

6) Git & environments
- Commit `amplify/` (except `amplify/#current-cloud-backend/` and local configs)
- Do NOT commit `lib/amplifyconfiguration.dart` (ignored by .gitignore)
- Branch mapping: develop → dev env, main → prod env
- Commands: amplify env add; amplify env checkout dev|prod

7) Mobile deep links (for Hosted UI)
- Android: add intent-filter for scheme `yuno://auth`
- iOS: add URL Types (CFBundleURLSchemes)
- Update Cognito App client callback URLs to include the deep link
Example: Android intent-filter
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="yuno" android:host="auth" />
</intent-filter>

8) Social (Naver/Kakao via OIDC)
- Register OIDC app on each provider
- Configure Issuer/Authorize/Token/UserInfo URLs in Cognito IdP
- Map claims to email, name where available

Auth wizard baseline answers (reference)
- OAuth flow: Authorization code grant
- Callback URLs: yuno://auth
- Sign-out URLs: yuno://signout
- Scopes: openid, profile, email


Troubleshooting
- If configure fails at runtime, check that `lib/amplifyconfiguration.dart` exists and matches the backend env.
- For GraphQL: after editing schema, run `amplify push` and then regenerate models if using codegen.
