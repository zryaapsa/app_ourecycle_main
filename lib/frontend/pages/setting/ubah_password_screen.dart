import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UbahPasswordScreen extends StatefulWidget {
  const UbahPasswordScreen({super.key});

  @override
  State<UbahPasswordScreen> createState() => _UbahPasswordScreenState();
}

class _UbahPasswordScreenState extends State<UbahPasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.green.shade800),
        title: Text(
          'Ubah Password',
          style: TextStyle(color: Colors.green.shade800),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTextField(
              context: context,
              label: 'Password Baru',
              controller: newPasswordController,
              icon: Icons.lock_open_outlined,
              obscureText: _obscureNew,
              onToggleVisibility: () {
                setState(() => _obscureNew = !_obscureNew);
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context: context,
              label: 'Konfirmasi Password Baru',
              controller: confirmPasswordController,
              icon: Icons.lock_reset,
              obscureText: _obscureConfirm,
              onToggleVisibility: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implementasi simpan password baru
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.green,
          selectionColor: Colors.green.withOpacity(0.3),
          selectionHandleColor: Colors.green,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green),
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade400, width: 2.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.green,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}
