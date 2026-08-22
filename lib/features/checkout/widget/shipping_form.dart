import 'package:flutter/material.dart';

class ShippingForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController postalCodeController;
  const ShippingForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.postalCodeController,
  });

  String? _required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]{11}$').hasMatch(value.trim())) {
      return 'Enter a valid 11-digit phone number';
    }

    return null;
  }

  String? _postalCodeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Enter a valid postal code';
    }

    return null;
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          textInputAction: TextInputAction.next,
          decoration: _decoration('Full Name', Icons.person_outline),
          validator: (value) => _required(value, 'Full name'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: _decoration('Phone Number', Icons.phone_outlined),
          validator: _phoneValidator,
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: addressController,
          maxLines: 2,
          textInputAction: TextInputAction.next,
          decoration: _decoration('Address', Icons.location_on_outlined),
          validator: (value) => _required(value, 'Address'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: cityController,
          textInputAction: TextInputAction.next,
          decoration: _decoration('City', Icons.location_city_outlined),
          validator: (value) => _required(value, 'City'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: postalCodeController,
          keyboardType: TextInputType.number,
          decoration: _decoration(
            'Postal Code',
            Icons.markunread_mailbox_outlined,
          ),
          validator: _postalCodeValidator,
        ),
      ],
    );
  }
}
