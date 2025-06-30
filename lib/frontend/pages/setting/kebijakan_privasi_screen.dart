import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Layar untuk menampilkan Kebijakan Privasi aplikasi Ourecycle.
// Konten di dalamnya bersifat statis dan diambil dari teks yang sudah dibuat.
class KebijakanPrivasiScreen extends StatelessWidget {
  const KebijakanPrivasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Style dasar untuk teks paragraf agar konsisten
    final paragraphStyle = GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black87,
      height: 1.6, // Jarak antar baris
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kebijakan Privasi',
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
              _buildHeading('Kebijakan Privasi untuk Aplikasi Ourecycle'),
              _buildParagraph(
                'Tanggal Efektif: 26 Juni 2025',
                style: paragraphStyle.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              _buildParagraph(
                'Terima kasih telah menggunakan Ourecycle! Kami berkomitmen untuk melindungi privasi data pribadi Anda. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, mengungkapkan, dan melindungi informasi Anda saat Anda menggunakan aplikasi seluler kami, Ourecycle.',
                style: paragraphStyle,
              ),
              const SizedBox(height: 24),

              _buildHeading('1. Informasi yang Kami Kumpulkan'),
              _buildParagraph(
                'Kami dapat mengumpulkan beberapa jenis informasi untuk berbagai tujuan guna menyediakan dan meningkatkan layanan kami kepada Anda.',
                style: paragraphStyle,
              ),
              const SizedBox(height: 16),

              _buildSubHeading('a. Informasi yang Anda Berikan Secara Langsung:'),
              _buildListItem('Data Akun: Nama, alamat email, dan kata sandi Anda.', paragraphStyle),
              _buildListItem('Data Profil: Nomor telepon dan alamat untuk keperluan penjemputan.', paragraphStyle),
              _buildListItem('Konten Pengguna: Gambar yang Anda unggah terkait barang yang akan didaur ulang.', paragraphStyle),
              _buildListItem('Komunikasi: Catatan korespondensi jika Anda menghubungi kami.', paragraphStyle),
              const SizedBox(height: 16),

              _buildSubHeading('b. Informasi yang Dikumpulkan Secara Otomatis:'),
              _buildListItem('Data Lokasi: Dengan izin Anda, kami mengumpulkan lokasi untuk menemukan titik daur ulang atau mengatur penjemputan.', paragraphStyle),
              _buildListItem('Data Penggunaan: Cara Anda berinteraksi dengan aplikasi.', paragraphStyle),
              _buildListItem('Data Perangkat: Model perangkat keras dan versi sistem operasi.', paragraphStyle),
              const SizedBox(height: 24),

              _buildHeading('2. Bagaimana Kami Menggunakan Informasi Anda'),
              _buildListItem('Menyediakan, mengoperasikan, dan memelihara aplikasi.', paragraphStyle),
              _buildListItem('Mengelola akun Anda dan mempersonalisasi pengalaman Anda.', paragraphStyle),
              _buildListItem('Memfasilitasi jadwal penjemputan atau menunjukkan lokasi mitra.', paragraphStyle),
              _buildListItem('Berkomunikasi dengan Anda (notifikasi, dukungan pelanggan).', paragraphStyle),
              _buildListItem('Menganalisis penggunaan untuk meningkatkan aplikasi.', paragraphStyle),
              _buildListItem('Mencegah penipuan dan menjaga keamanan platform.', paragraphStyle),
              const SizedBox(height: 24),

              _buildHeading('3. Pembagian Informasi Anda'),
              _buildParagraph(
                'Kami tidak menjual atau menyewakan data pribadi Anda. Kami hanya dapat membagikan informasi Anda dalam situasi berikut:',
                style: paragraphStyle,
              ),
              _buildListItem('Dengan Penyedia Layanan: Pihak ketiga yang membantu kami seperti penyedia hosting dan analisis.', paragraphStyle),
              _buildListItem('Dengan Mitra Daur Ulang: Untuk memproses permintaan daur ulang Anda.', paragraphStyle),
              _buildListItem('Untuk Kepatuhan Hukum: Jika diwajibkan oleh hukum.', paragraphStyle),
              const SizedBox(height: 24),

              _buildHeading('4. Keamanan Data'),
              _buildParagraph(
                'Kami menerapkan langkah-langkah keamanan yang wajar untuk melindungi data Anda. Namun, tidak ada metode transmisi atau penyimpanan yang 100% aman.',
                style: paragraphStyle,
              ),
              const SizedBox(height: 24),

              _buildHeading('5. Privasi Anak-Anak'),
              _buildParagraph(
                'Aplikasi kami tidak ditujukan untuk siapa pun yang berusia di bawah 13 tahun. Kami tidak secara sadar mengumpulkan data dari anak-anak.',
                style: paragraphStyle,
              ),
              const SizedBox(height: 24),

              _buildHeading('6. Perubahan pada Kebijakan Privasi Ini'),
              _buildParagraph(
                'Kami dapat memperbarui kebijakan ini dari waktu ke waktu. Kami akan memberitahu Anda tentang perubahan apa pun dengan mempostingnya di halaman ini.',
                style: paragraphStyle,
              ),
              const SizedBox(height: 24),

              _buildHeading('7. Hubungi Kami'),
              _buildParagraph(
                'Jika Anda memiliki pertanyaan atau kekhawatiran tentang Kebijakan Privasi ini, silakan hubungi kami melalui:',
                style: paragraphStyle,
              ),
              SelectableText(
                'ourecycle1@gmail.com',
                style: paragraphStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat judul utama
  Widget _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  // Widget helper untuk membuat sub-judul
  Widget _buildSubHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Widget helper untuk membuat paragraf
  Widget _buildParagraph(String text, {required TextStyle style}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.justify,
      ),
    );
  }

  // Widget helper untuk membuat item list dengan bullet point
  Widget _buildListItem(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: style.copyWith(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: style,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}