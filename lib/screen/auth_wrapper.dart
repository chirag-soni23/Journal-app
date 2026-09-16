import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_app_in_flutter/providers/auth_provider.dart';
import 'package:journal_app_in_flutter/screen/journal_screen.dart';
import 'package:journal_app_in_flutter/screen/login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) =>
          user != null ? const JournalScreen() : const LoginScreen(),
      error: (er, stack) =>
          Scaffold(body: Center(child: Text("Something Went Wrong $er"))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
