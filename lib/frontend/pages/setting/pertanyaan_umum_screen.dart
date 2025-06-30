import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model sederhana untuk menyimpan data pertanyaan dan jawaban
class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

// Layar untuk menampilkan daftar pertanyaan yang sering diajukan (FAQ)
class PertanyaanUmumScreen extends StatefulWidget {
  const PertanyaanUmumScreen({super.key});

  @override
  State<PertanyaanUmumScreen> createState() => _PertanyaanUmumScreenState();
}

class _PertanyaanUmumScreenState extends State<PertanyaanUmumScreen> {
  // Daftar pertanyaan dan jawaban
  final List<FaqItem> _faqItems = [
    FaqItem(
      question: 'Apa itu Ourecycle?',
      answer:
          'Ourecycle adalah platform digital yang menghubungkan Anda dengan mitra daur ulang untuk memudahkan proses penyetoran sampah anorganik. Misi kami adalah membuat daur ulang menjadi lebih mudah, dapat diakses, dan menguntungkan bagi semua orang.',
    ),
    FaqItem(
      question: 'Jenis sampah apa saja yang diterima?',
      answer:
          'Saat ini kami menerima sampah anorganik yang sudah dipilah, seperti botol plastik (PET), kertas, kardus, kaleng aluminium, dan botol kaca. Pastikan sampah dalam kondisi relatif bersih dan kering untuk mendapatkan nilai terbaik.',
    ),
    FaqItem(
      question: 'Bagaimana proses penjemputannya bekerja?',
      answer:
          'Setelah Anda melaporkan sampah melalui aplikasi dan mengatur jadwal, mitra pengumpul terdekat akan mendapatkan notifikasi. Mereka akan datang ke lokasi Anda sesuai jadwal yang telah ditentukan untuk mengambil sampah Anda.',
    ),
    FaqItem(
      question: 'Apakah layanan ini tersedia di daerah saya?',
      answer:
          'Cakupan layanan kami terus berkembang. Anda dapat memeriksa ketersediaan layanan di daerah Anda melalui fitur peta atau dengan memasukkan alamat Anda pada menu penjemputan di dalam aplikasi.',
    ),
    FaqItem(
      question: 'Bagaimana cara kerja sistem poin?',
      answer:
          'Setiap kilogram sampah yang berhasil kami verifikasi akan dikonversi menjadi poin. Jumlah poin bervariasi tergantung jenis dan kualitas sampah. Poin yang terkumpul dapat Anda tukarkan dengan berbagai imbalan menarik seperti voucher belanja, pulsa, atau donasi.',
    ),
    FaqItem(
      question: 'Apakah ada biaya untuk menggunakan Ourecycle?',
      answer:
          'Ya. Layanan penjemputan sampah melalui aplikasi Ourecycle Ada biaya untuk kurir. Dan Anda juga akan mendapatkan imbalan berupa poin dari sampah yang Anda setorkan.',
    ),
    FaqItem(
      question: 'Bagaimana jika saya punya pertanyaan lain?',
      answer:
          'Tim kami selalu siap membantu. Jangan ragu untuk menghubungi kami melalui email di ourecycle1@gmail.com. Kami akan merespons sesegera mungkin.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pertanyaan Umum (FAQ)',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              iconColor: Colors.green.shade800,
              collapsedIconColor: Colors.black54,
              title: Text(
                item.question,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Text(
                    item.answer,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
