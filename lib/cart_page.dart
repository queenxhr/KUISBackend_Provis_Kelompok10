import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuis_backend_kel10/food_menu_page.dart';
import 'package:kuis_backend_kel10/status_transaksi_page.dart';
import 'package:kuis_backend_kel10/item.dart';
import 'package:kuis_backend_kel10/cart.dart';

class CartPage extends StatefulWidget {
  final List<Item> cartItems;
  final double deliveryCharge;

  const CartPage({
    Key? key,
    required this.cartItems,
    required this.deliveryCharge,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late String shippingAddress;
  late double totalPrice;
  String? _selectedPaymentMethod;
  List<Cart> cartList = []; // Menyimpan item di keranjang

  @override
  void initState() {
    super.initState();
    shippingAddress = 'Jl. Setiabudhi No. 123';
    _selectedPaymentMethod = 'Pilih Metode Pembayaran';
    // Inisialisasi cartList dengan item yang diterima dari FoodMenuPage
    for (var item in widget.cartItems) {
      cartList.add(
        Cart(
          item_id: item.id,
          user_id: 0, // Sesuaikan dengan user ID yang sesuai
          quantity: 1, // Misalnya, awalnya setiap item memiliki satu quantity
          id: 0, // Sesuaikan dengan ID yang sesuai jika diperlukan
        ),
      );
    }
    totalPrice = calculateTotalPrice();
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var cart in cartList) {
      // Cari item terkait berdasarkan ID item dari keranjang
      var relatedItem = widget.cartItems.firstWhere(
        (item) => item.id == cart.item_id,
        orElse: () => Item(id: 0, title: '', price: 0, description: '', img_name: ''),
      );
      total += relatedItem.price * cart.quantity;
    }
    return total + widget.deliveryCharge;
  }

  void _incrementOrder(int index) {
    setState(() {
      cartList[index].quantity++; // Tambahkan satu item
      totalPrice = calculateTotalPrice(); // Perbarui total harga
    });
  }

  void _decrementOrder(int index) {
    setState(() {
      if (cartList[index].quantity > 1) {
        cartList[index].quantity--; // Kurangi satu item jika jumlah > 1
      } else {
        cartList.removeAt(index); // Hapus item jika jumlah <= 1
      }
      totalPrice = calculateTotalPrice(); // Perbarui total harga
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text(
          'CART',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bagian alamat pengiriman dan pesanan Anda
          Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Alamat Pengiriman:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  shippingAddress,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Menampilkan item di keranjang
          Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Pesanan Anda:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    final cart = cartList[index];
                    final relatedItem = widget.cartItems.firstWhere(
                      (item) => item.id == cart.item_id,
                      orElse: () => Item(id: 0, title: '', price: 0, description: '', img_name: ''),
                    );
                    final totalPricePerItem = relatedItem.price * cart.quantity;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              relatedItem.img_name,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${relatedItem.title}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Rp ${relatedItem.price}'),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _decrementOrder(index);
                              },
                              icon: Icon(Icons.remove),
                            ),
                            Text('${cart.quantity}'),
                            IconButton(
                              onPressed: () {
                                _incrementOrder(index);
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                        Text('Rp $totalPricePerItem'),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 70,
                        ),
                      ),
                      child: Text(
                        'Tambah Pesanan',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bagian total pembayaran dan metode pembayaran
          Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Total Pembayaran:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Harga Makanan: Rp ${totalPrice - widget.deliveryCharge}',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Ongkos Kirim: Rp ${widget.deliveryCharge}',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Total: Rp $totalPrice',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Metode Pembayaran:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    items: <String>['Pilih Metode Pembayaran', 'Cash', 'Gopay']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          // Tombol pesan sekarang
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.pink[100],
                        title: Center(
                          child: Text(
                            "Konfirmasi Pesanan!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        content: Text("Anda yakin ingin memesan?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink[300],
                                ),
                                child: Text(
                                  'Tidak',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransaksiStatusPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink[300],
                                ),
                                child: Text(
                                  'Ya',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 70,
                  ),
                ),
                child: Text(
                  'Pesan Sekarang',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
