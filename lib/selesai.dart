import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuis_backend_kel10/food_menu_page.dart';
class PesananBerhasilPage extends StatelessWidget {
  // Kelas Pembayaran yang merupakan widget StatelessWidget
  @override
  Widget build(BuildContext context) {
    // Fungsi untuk membangun tampilan widget
    return Scaffold(
      // Mengembalikan widget Scaffold sebagai tampilan utama
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.pink[300],
        title: Text(
          'PESANAN SELESAI',
          style: GoogleFonts.nunito(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true, // Judul ditengah app bar
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // Aksi saat tombol ditekan
            // Mengganti halaman saat ini dengan BerandaPage dan menghapus semua halaman di atasnya dalam tumpukan navigasi
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FoodMenuPage()), // Mengarahkan ke BerandaPage
              (route) => false, // Menghapus semua halaman di atasnya
            );
          },
        ),
        toolbarHeight: 87,
      ),
      body: Center(
        // Konten utama halaman ditengah layar
        child: Column(
          // Widget kolom untuk menata konten
          mainAxisAlignment: MainAxisAlignment
              .center, // Posisi konten utama di tengah vertikal
          children: [
            // Daftar widget anak di dalam kolom
            Expanded(
              // Widget yang dapat memperluas diri untuk mengisi ruang yang tersedia
              child: Center(
                // Pusatkan konten di dalam Expanded
                child: Column(
                  // Widget kolom di dalam Expanded untuk menata konten tengah
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Posisi konten utama di tengah vertikal
                  children: [
                    // Daftar widget anak di dalam kolom
                    SizedBox(
                        // Widget untuk menentukan ukuran kotak kosong
                        width: 200.0, // Lebar kotak kosong
                        height: 200.0, // Tinggi kotak kosong
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 200, // Ukuran ikon
                        )),
                    SizedBox(height: 20), // Jarak antara gambar dan teks
                    Text(
                      // Teks pertama
                      "Terima Kasih", // Isi teks pertama
                      style: TextStyle(
                        // Gaya teks untuk teks pertama
                        color: Colors.black, // Warna teks pertama
                        fontWeight: FontWeight.bold, // Ketebalan teks pertama
                        fontSize: 16, // Ukuran teks pertama
                      ),
                    ),
                    Text(
                      // Teks kedua
                      "Pesanan Anda telah selesai!", // Isi teks kedua
                      style: TextStyle(
                        // Gaya teks untuk teks kedua
                        color: Colors.black, // Warna teks kedua
                        fontWeight: FontWeight.bold, // Ketebalan teks kedua
                        fontSize: 16, // Ukuran teks kedua
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
