import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:tiktok_app_clone_flutter/core/enums/route_enum.dart';
import 'package:tiktok_app_clone_flutter/src/view/auth/login_view.dart';
import 'package:tiktok_app_clone_flutter/src/view/auth/registration_view.dart';

class AppRoutes {
  const AppRoutes._();

  static List<GetPage<dynamic>> appRoute() => [
        _buildPageRoute(RouteName.login),
        _buildPageRoute(RouteName.regist),
      ];

  static GetPage<dynamic> _buildPageRoute(
    RouteName route, {
    Transition? transition,
  }) {
    return GetPage(
      name: '/$route',
      page: () => _buildPage(route),
      transition: transition ?? Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static Widget _buildPage(RouteName route) {
    switch (route) {
      case RouteName.login:
        return LoginView.page();
      case RouteName.regist:
        return RegistView.page();
      default:
        throw Exception('invalid');
    }
  }
}
