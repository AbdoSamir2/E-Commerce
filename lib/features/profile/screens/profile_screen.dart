import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../data/user_repository.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget
{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
{
  late final UserRepository _userRepository;
  UserModel? _user;
  bool _isLoading = true;
  String? _errorMessage;
  static const int _userId = 1;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository(context.read<ApiClient>(),);
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _userRepository.getUserById(_userId,);

      if (!mounted) return;

      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
    catch (error) {
      debugPrint('PROFILE ERROR: $error');
      debugPrint('PROFILE ERROR TYPE: ${error.runtimeType}',);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load profile information.';
      });
    }

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),),
      body: _buildBody(),
    );
  }

  Widget _buildBody()
  {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(),);
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_user == null) {
      return const Center(
        child: Text('No profile data available.',),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUser,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50,),
          ),

          const SizedBox(height: 16),
          Text(
            _user!.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
          ),

          const SizedBox(height: 8),
          Text(
            '@${_user!.username}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600,),
          ),

          const SizedBox(height: 30),
          _infoCard(Icons.email_outlined, 'Email', _user!.email,),

          _infoCard(Icons.phone_outlined, 'Phone', _user!.phone,),

          _infoCard(Icons.location_on_outlined, 'Address',
            '${_user!.street}, ${_user!.city}, ${_user!.zipcode}',),

          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined,),
              title:
              const Text('Order History'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
              onTap: () {
                context.push(AppRoutes.orderHistory,);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value,)
  {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildErrorState()
  {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 70,),
            const SizedBox(height: 16),

            Text(_errorMessage!, textAlign: TextAlign.center,),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loadUser,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}