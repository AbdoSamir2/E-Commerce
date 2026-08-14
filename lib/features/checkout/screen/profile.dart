import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget
{
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50,),),
            const SizedBox(height: 16),
            const Text(
              'User Name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, ),
            ),
            const SizedBox(height: 8),

            const Text('user@example.com', style: TextStyle(color: Colors.grey,),),
            const SizedBox(height: 30),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Personal Information'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on_outlined,),
                title: const Text('Saved Addresses'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long_outlined,),
                title: const Text('Order History'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
              ),
            ),

          ],
        ),
      ),
    );
  }
}