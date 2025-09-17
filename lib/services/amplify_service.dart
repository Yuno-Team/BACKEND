// Conditional export: use real Amplify on mobile, no-op stub on web.
export 'amplify_service_mobile.dart'
    if (dart.library.html) 'amplify_service_web_stub.dart';
