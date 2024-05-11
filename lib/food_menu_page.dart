import 'package:flutter/material.dart';
import 'package:kuis_backend_kel10/api_service.dart';
import 'package:kuis_backend_kel10/cart_page.dart';
import 'package:kuis_backend_kel10/food_detail_page.dart';
import 'package:kuis_backend_kel10/item.dart';
import 'package:kuis_backend_kel10/cart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodMenuPage extends StatefulWidget {
  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  double deliveryCharge = 5000; // Biaya pengiriman
  late Future<List<Item>>
      _itemsFuture; // Future untuk menampung hasil fetchItems
  List<Item> listItemMenu = []; // List untuk menyimpan item
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();
  int userId = 0; // ID pengguna, sesuaikan dengan pengguna yang masuk
  Map<int, int> _orderQuantities =
      {}; // Properti untuk menyimpan jumlah pesanan setiap item
// Properti untuk menyimpan jumlah pesanan setiap item

  void _incrementOrder(int item_id) {
    setState(() {
      _orderQuantities.update(item_id, (value) => value + 1, ifAbsent: () => 1);
      addToCart(item_id, userId, _orderQuantities[item_id]!);
    });
  }

  void _decrementOrder(int itemId) {
    setState(() {
      if (_orderQuantities.containsKey(itemId)) {
        if (_orderQuantities[itemId]! > 1) {
          _orderQuantities.update(itemId, (value) => value - 1);
          addToCart(itemId, userId, _orderQuantities[itemId]!);
        } else {
          _orderQuantities.remove(itemId);
          removeFromCart(itemId, userId);
        }
      }
    });
  }

  Future<void> addToCart(int itemId, int userId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('http://146.190.109.66:8000/carts/'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'item_id': itemId,
          'user_id': userId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        print('Item added to cart successfully');
      } else {
        throw Exception('Failed to add item to cart');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> removeFromCart(int itemId, int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://146.190.109.66:8000/carts/$itemId/$userId'),
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Item removed from cart successfully');
      } else {
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData(); // Panggil fungsi untuk menginisialisasi data
  }

  Future<void> _initializeData() async {
    try {
      await apiService.getToken(username: 'queenxhr', password: 'hellopanda');
      setState(() {
        _itemsFuture =
            apiService.fetchItems(); // Ambil item dari API saat inisialisasi
      });
    } catch (e) {
      // Tangani error jika gagal mendapatkan token atau fetchItems
      print('Error: $e');
    }
  }

  Future<void> _searchItems(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('http://146.190.109.66:8000/search_items/${keyword}'),
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Jika permintaan berhasil, perbarui listItemMenu dengan hasil pencarian
        setState(() {
          final List<dynamic> jsonData = jsonDecode(response.body);
          listItemMenu =
              jsonData.map((itemJson) => Item.fromJson(itemJson)).toList();
        });
      } else {
        // Jika permintaan gagal, tangani kesalahan
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text(
          'BARAYA FOOD',
          style: GoogleFonts.nunito(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 87,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Nomor Kelompok: [10]',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Mhs 1:  [2200978, Ratu Syahirah Khairunnisa]',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Mhs 2:  [2200598, Jasmine Noor Fawzia]',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Saat nilai TextField berubah, lakukan pencarian
                _searchItems(value);
              },
              // onChanged: (value) {
              //   // Saat nilai TextField berubah, lakukan penyaringan data
              //   setState(() {
              //     listItemMenu = itemMenuData.where((makanan) {
              //       return makanan['title']
              //           .toLowerCase()
              //           .contains(value.toLowerCase());
              //     }).toList();
              //   });
              // },
              decoration: InputDecoration(
                hintText: 'Cari menu',
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.pink[100],
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16), // Sesuaikan dengan kebutuhan Anda
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      // Image.asset(
                      //   'assets/images/search.png',
                      //   width: 8,
                      //   height: 8,
                      // ),
                      Icon(Icons.search),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  listItemMenu =
                      snapshot.data!; // Simpan data item dari respons

                  return ListView.builder(
                    itemCount: listItemMenu.length,
                    itemBuilder: (context, index) {
                      final item = listItemMenu[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailMenuPage(item: item.toJson()),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.pink[100],
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                // leading: Container(
                                //   width: 100,
                                //   height: 100,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //     image: DecorationImage(
                                //       image: AssetImage(item.img_name),
                                //     ),
                                //   ),
                                // ),
                                leading: Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    'http://146.190.109.66:8000/items_image/${item.id}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  item.title,
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      'Rp ${item.price}',
                                      style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Text(
                                      item.description,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _decrementOrder(item.id);
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text(
                                    _orderQuantities.containsKey(item.id)
                                        ? _orderQuantities[item.id].toString()
                                        : '0',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _incrementOrder(item.id);
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cartItems: [], // Kosongkan cartItems saat ini
                        deliveryCharge: deliveryCharge,
                      ),
                    ),
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
