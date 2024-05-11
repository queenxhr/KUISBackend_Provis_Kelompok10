import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuis_backend_kel10/food_menu_page.dart'; // Mengimpor file 'beranda.dart'
import 'package:http/http.dart' as http;
import 'dart:convert';

late Future<int> respPost;
String url = "http://146.190.109.66:8000//users/";

Future<int> postData() async {
  final response = await http.post(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  }, body: """
    {"username": "",
    "password"}""");
  return response.statusCode;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';
  bool showError = false;
  bool isPasswordVisible = false; // Tambahkan ini
  void _handleLogin() async {
    try {
      if ((username.isEmpty && password.isEmpty) || username.isEmpty || password.isEmpty) {
        // Tampilkan peringatan jika username atau password kosong
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Peringatan"),
              content: Text("Harap isi username dan password."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
        return; // Hentikan eksekusi metode jika username atau password kosong
      }
      // Buat body permintaan dengan data login
      var requestBody = {
        'username': username,
        'password': password,
      };

      // Buat permintaan HTTP POST ke endpoint
      var response = await http.post(
        Uri.parse('http://146.190.109.66:8000/login'),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Periksa kode respons
      if (response.statusCode == 200) {
        // Jika login berhasil, lanjutkan ke halaman selanjutnya
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodMenuPage(),
          ),
        );
      } else {
        // Jika login gagal, tampilkan pesan kesalahan
        setState(() {
          showError = true;
        });
      }
    } catch (e) {
      // Tangani kesalahan jika terjadi
      print("Error: $e");
    }
  }

  // Tambahkan metode ini
  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Image.asset(
                    'images/logo.png',
                    height: 300,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Selamat Datang di Baraya Food',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Username',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            prefixStyle: TextStyle(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Kata Sandi',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          obscureText: !isPasswordVisible, // Ubah di sini
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            prefixStyle: TextStyle(
                              color: Colors.transparent,
                            ),
                            suffixIcon: IconButton(
                              // Tambahkan ini
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        SizedBox(height: 30),
                        ElevatedButton(
                          // onPressed: _handleLogin,
                          onPressed: _handleLogin,
                          child: Text(
                            'Masuk',
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 80,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Aksi ketika tombol daftar ditekan
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          child: Text(
                            'Daftar',
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 80,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          if (showError)
            GestureDetector(
              onTap: () {
                setState(() {
                  showError = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Username atau Kata Sandi Salah!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showError = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                                backgroundColor: Colors.pink[300],
                              ),
                              child: Text(
                                'Kembali',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showError = false;
                                });
                                // Reset fields or any other action required for login again
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                                backgroundColor: Color(0xFFF93A4C),
                              ),
                              child: Text(
                                'Login Ulang',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = '';
  String password = '';
  bool isAllFieldsFilled = false;
  bool _isObscure = true;

  void _checkFields() {
    setState(() {
      isAllFieldsFilled = username.isNotEmpty && password.isNotEmpty;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.pink[100],
          title: Center(
            child: Text(
              "Konfirmasi Data",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            "Apakah Data yang Anda isi sudah benar?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
                    'Kembali',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                  ),
                  child: Text(
                    'Lanjutkan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _register() async {
    if (isAllFieldsFilled) {
      try {
        // Buat body permintaan dengan data pendaftaran
        var requestBody = {
          'username': username,
          'password': password,
        };

        // Buat permintaan HTTP POST ke endpoint
        var response = await http.post(
          Uri.parse('http://146.190.109.66:8000/users/'),
          body: json.encode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        // Periksa kode respons
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          var userId = responseData['id'];
          // Registrasi berhasil
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Pendaftaran Berhasil"),
                content: Text("Akun Anda berhasil didaftarkan. ID Pengguna: $userId"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage()), // Mengarahkan ke BerandaPage
                        (route) => false, // Menghapus semua halaman di atasnya
                      ); // Tutup halaman pendaftaran
                    },
                    child: Text("Login"),
                  ),
                ],
              );
            },
          );
        } else {
          // Registrasi gagal, tampilkan pesan kesalahan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Pendaftaran Gagal"),
                content: Text(
                    "Terjadi kesalahan saat mendaftar. Silakan coba lagi."),
                actions: <Widget>[
                  TextButton(
                    child: Text("Tutup"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // Tangani kesalahan jika terjadi
        print("Error: $e");
      }
    } else {
      // Tampilkan pesan jika semua kolom belum diisi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pendaftaran Gagal"),
            content: Text("Harap isi semua kolom dengan benar."),
            actions: <Widget>[
              TextButton(
                child: Text("Tutup"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                  _checkFields();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Masukkan username Anda',
                  filled: true,
                  fillColor: Colors.pink[100],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Kata Sandi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                  _checkFields();
                },
                obscureText: _isObscure,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Masukkan kata sandi Anda',
                  filled: true,
                  fillColor: Colors.pink[100],
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: isAllFieldsFilled ? _showConfirmationDialog : null,
                child: Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 80,
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