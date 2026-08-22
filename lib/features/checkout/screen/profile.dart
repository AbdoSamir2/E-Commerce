import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../auth/logic/auth_state.dart';
import '../../profile/screens/personal_information_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );

    if (shouldSignOut != true || !context.mounted) {
      return;
    }

    await context.read<AuthCubit>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final email = context.select<AuthCubit, String?>(
      (cubit) => cubit.state.email,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current.status == AuthStatus.unauthenticated,
        listener: (context, state) => context.go(AppRoutes.login),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 16),
              const Text(
                'User Name',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Text(
                email ?? 'Not signed in',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Personal Information'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PersonalInformationScreen(),
                      ),
                    );
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: const Text('Order History'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return OutlinedButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () => _confirmSignOut(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
