import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ourecycle_main/frontend/pages/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // Widget helper untuk membuat baris gambar yang responsif
  Widget _buildImageRow(BuildContext context) {
    return Row(
      children: [
        // 1. Ganti Container(width: 100) dengan Expanded
        // Expanded membuat setiap widget mengambil porsi ruang yang sama
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/plastic-bottles.jpg',
              fit: BoxFit.cover,
              height: 140, // Tinggi bisa tetap atau dibuat proporsional
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/plastic-bottles.jpg',
              fit: BoxFit.cover,
              height: 140,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/plastic-bottles.jpg',
              fit: BoxFit.cover,
              height: 140,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar untuk padding proporsional
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        // 2. Gunakan padding yang proporsional, bukan tetap
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Beri jarak dari atas layar secara proporsional
              SizedBox(height: screenHeight * 0.05),

              // Tiga baris gambar yang sekarang responsif
              _buildImageRow(context),
              const SizedBox(height: 15),
              _buildImageRow(context),
              const SizedBox(height: 15),
              _buildImageRow(context),

              const SizedBox(height: 30),

              // Judul
              const Text(
                'Jual Sampahmu untuk\nmenyelamatkan bumi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold, // Dibuat bold agar lebih menonjol
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // Deskripsi
              const Text(
                'Kami menyediakan layanan penjualan berbagai jenis sampah untuk di daur ulang kembali.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              // 3. Gunakan Spacer untuk mendorong tombol ke bawah
              // Spacer akan mengambil semua sisa ruang vertikal yang ada
              const Spacer(),

              // Tombol
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 30.0,
                ), // Beri jarak dari bawah
                child: ElevatedButton(
                  onPressed: () {
                    // Gunakan Get.off agar tidak bisa kembali ke splash screen
                    Get.off(() => const LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ), // Pastikan tombol penuh
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lihat Selengkapnya',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
