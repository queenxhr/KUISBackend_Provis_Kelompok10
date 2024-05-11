import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuis_backend_kel10/food_menu_page.dart';

class DetailMenuPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailMenuPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        backgroundColor: Colors.pink[300],
        title: Text(
          item['title'],
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          
            onPressed: () { // Aksi saat tombol ditekan
              // Mengganti halaman saat ini dengan BerandaPage dan menghapus semua halaman di atasnya dalam tumpukan navigasi
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => FoodMenuPage()), // Mengarahkan ke BerandaPage
                (route) => false, // Menghapus semua halaman di atasnya
              );
            },
        ),
        toolbarHeight: 87,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.pink[100],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Gambar di bawah judul
                Center(
                  child: Image.asset(
                    '${item['img_name']}',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                // Title
                Text(
                  '${item['title']}',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Harga
                Text(
                  'Harga       : Rp ${item['price']}',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Deskripsi
                Text(
                  'Deskripsi : ${item['description']}',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}