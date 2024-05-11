import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuis_backend_kel10/selesai.dart';

class TransaksiStatusPage extends StatefulWidget {
  @override
  _TransaksiStatusPageState createState() => _TransaksiStatusPageState();
}

class _TransaksiStatusPageState extends State<TransaksiStatusPage> {
  List<String> _statusList = [
    'Checkout',
    'Pembayaran',
    'Pesanan Diterima',
    'Driver Mulai Mengantar',
    'Pesanan Selesai'
  ];

  int _currentStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text(
          'STATUS TRANSAKSI',
          style: GoogleFonts.nunito(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true, // Judul ditengah app bar
        toolbarHeight: 87,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Margin horizontal
        child: ListView.builder(
          itemCount: _statusList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    child: Column(
                      children: [
                        if (index < _statusList.length - 1)
                          Container(
                            width: 2,
                            height: 8,
                            color: Colors.black,
                          ),
                        Icon(
                          index <= _currentStatusIndex
                              ? Icons.check
                              : Icons.circle,
                          color: index <= _currentStatusIndex
                              ? Colors.green
                              : Colors.grey,
                          size: 20,
                        ),
                        if (index < _statusList.length - 1)
                          Container(
                            width: 2,
                            height: 8,
                            color: Colors.black,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _statusList[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_currentStatusIndex < _statusList.length - 1) {
                  _currentStatusIndex++;
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PesananBerhasilPage(),
                    ),
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
            ),
            child: Text(
              'Klik untuk melihat status transaksi Anda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
