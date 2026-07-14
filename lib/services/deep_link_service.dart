import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

/// Deep Link Service to handle invitation links or other deep links
class DeepLinkService {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey;

  DeepLinkService(this.navigatorKey) {
    _init();
  }

  void _init() {
    _appLinks = AppLinks();
    
    // Check initial link if app was cold started from a deep link
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    // Handle deep links when app is in background or foreground
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      debugPrint('Deep Link Error: $err');
    });
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Received deep link: $uri');
    
    // Example format: vertex://app/invite?orgId=123&token=abc
    // Or: https://vertex.com/invite?orgId=123&token=abc
    
    if (uri.path.contains('/invite') || uri.host == 'invite') {
      final orgId = uri.queryParameters['orgId'];
      final token = uri.queryParameters['token'];
      
      if (orgId != null && token != null) {
        // Delay to allow UI to settle if just starting
        Future.delayed(const Duration(milliseconds: 500), () {
          navigatorKey.currentState?.pushNamed(
            '/accept-invite',
            arguments: {'orgId': orgId, 'token': token},
          );
        });
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
