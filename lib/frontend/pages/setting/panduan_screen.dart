import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PanduanScreen extends StatelessWidget {
  const PanduanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Panduan Penggunaan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang di Ourecycle!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Berikut adalah langkah mudah untuk mulai mendaur ulang dan mendapatkan imbalan bersama kami.',
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Menampilkan setiap langkah dalam bentuk kartu
              _buildStepCard(
                context: context,
                icon: Icons.sort,
                color: Colors.blue.shade700,
                title: '1. Pilah Sampah Anda',
                description:
                    'Pisahkan sampah Anda berdasarkan kategori yang bisa didaur ulang seperti plastik, kertas, dan logam. Sampah yang bersih memiliki nilai lebih tinggi!',
              ),
              _buildStepCard(
                context: context,
                icon: Icons.camera_alt_outlined,
                color: Colors.orange.shade700,
                title: '2. Laporkan Lewat Aplikasi',
                description:
                    'Buka aplikasi, ambil foto sampah yang sudah Anda pilah, lalu pilih kategori dan masukan estimasi beratnya.',
              ),
              _buildStepCard(
                context: context,
                icon: Icons.local_shipping_outlined,
                color: Colors.green.shade700,
                title: '3. Atur Penjemputan',
                description:
                    'Tentukan lokasi dan jadwal penjemputan yang Anda inginkan. Mitra kami akan segera datang ke lokasi Anda sesuai jadwal.',
              ),
              _buildStepCard(
                context: context,
                icon: Icons.emoji_events_outlined,
                color: Colors.amber.shade800,
                title: '4. Dapatkan Poin & Imbalan',
                description:
                    'Setelah sampah Anda diverifikasi oleh mitra kami, poin akan otomatis masuk ke akun Anda. Tukarkan poin dengan berbagai imbalan menarik!',
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Terima kasih telah membantu menjaga bumi tetap hijau!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat kartu panduan yang seragam.
  Widget _buildStepCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
