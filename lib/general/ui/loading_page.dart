import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import '../widgets/progress_indicators.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.to;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
                onTap: () async => await authController.signOut(),
                child: circularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
