import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Layar untuk menampilkan Syarat & Ketentuan penggunaan aplikasi Ourecycle.
class SyaratDanKetentuanScreen extends StatelessWidget {
  const SyaratDanKetentuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Style dasar untuk teks paragraf
    final paragraphStyle = GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black87,
      height: 1.6,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Syarat & Ketentuan',
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
                'Harap baca Syarat dan Ketentuan ini dengan saksama sebelum menggunakan aplikasi Ourecycle.',
                style: paragraphStyle.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              _buildParagraph(
                'Dengan mendaftar dan menggunakan layanan Ourecycle ("Aplikasi"), Anda ("Pengguna") setuju untuk terikat oleh Syarat dan Ketentuan ("Ketentuan") ini. Jika Anda tidak menyetujui Ketentuan ini, Anda tidak diperkenankan menggunakan Aplikasi.',
                style: paragraphStyle,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('1. Penggunaan Layanan'),
              _buildParagraph(
                'a. Pengguna harus berusia minimal 17 tahun atau telah memiliki kapasitas hukum untuk membuat perjanjian yang mengikat.\n'
                'b. Pengguna bertanggung jawab penuh atas keamanan akunnya, termasuk menjaga kerahasiaan kata sandi.\n'
                'c. Pengguna setuju untuk memberikan informasi yang akurat, terkini, dan lengkap saat melakukan pendaftaran dan menggunakan layanan.',
                style: paragraphStyle,
              ),

              _buildSectionTitle('2. Kewajiban Pengguna'),
              _buildParagraph(
                'a. Pengguna wajib memilah sampah anorganik sesuai kategori yang telah ditentukan oleh Aplikasi.\n'
                'b. Sampah yang disetorkan harus dalam kondisi relatif kering, bersih, dan bebas dari bahan berbahaya atau beracun.\n'
                'c. Pengguna bertanggung jawab untuk memberikan akses yang aman dan mudah bagi mitra pengumpul saat proses penjemputan.',
                style: paragraphStyle,
              ),
              
              _buildSectionTitle('3. Poin dan Imbalan'),
              _buildParagraph(
                'a. Poin diberikan berdasarkan berat dan jenis sampah yang telah diverifikasi oleh mitra kami. Keputusan verifikasi bersifat final.\n'
                'b. Poin tidak dapat diuangkan dan hanya dapat ditukarkan dengan imbalan yang tersedia di dalam Aplikasi.\n'
                'c. Ourecycle berhak mengubah skema perolehan dan penukaran poin sewaktu-waktu tanpa pemberitahuan sebelumnya.',
                style: paragraphStyle,
              ),

              _buildSectionTitle('4. Kekayaan Intelektual'),
              _buildParagraph(
                'Seluruh konten, logo, merek dagang, dan materi lain yang ada di dalam Aplikasi adalah milik penuh Ourecycle. Pengguna dilarang menggunakan, menyalin, atau mendistribusikan konten tersebut tanpa izin tertulis dari kami.',
                style: paragraphStyle,
              ),

              _buildSectionTitle('5. Pembatasan Tanggung Jawab'),
              _buildParagraph(
                'Ourecycle tidak bertanggung jawab atas kerugian atau kerusakan tidak langsung yang mungkin timbul dari penggunaan atau ketidakmampuan dalam menggunakan layanan ini. Layanan disediakan "sebagaimana adanya" tanpa jaminan apa pun.',
                style: paragraphStyle,
              ),

              _buildSectionTitle('6. Privasi'),
              _buildParagraph(
                'Penggunaan data pribadi Anda diatur oleh Kebijakan Privasi kami. Dengan menyetujui Ketentuan ini, Anda juga menyetujui Kebijakan Privasi kami.',
                style: paragraphStyle,
              ),

              _buildSectionTitle('7. Hukum yang Berlaku'),
              _buildParagraph(
                'Syarat dan Ketentuan ini diatur dan ditafsirkan sesuai dengan hukum yang berlaku di Republik Indonesia.',
                style: paragraphStyle,
              ),

              _buildSectionTitle('8. Kontak'),
              _buildParagraph(
                'Untuk pertanyaan lebih lanjut mengenai Syarat dan Ketentuan ini, silakan hubungi kami melalui email di ourecycle1@gmail.com.',
                style: paragraphStyle,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat judul pasal
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  // Widget helper untuk membuat paragraf
  Widget _buildParagraph(String text, {required TextStyle style}) {
    return Text(
      text,
      style: style,
      textAlign: TextAlign.justify,
    );
  }
}