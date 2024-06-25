import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:no_garco/pages/home_page.dart';
import 'package:no_garco/pages/register_page.dart';

import '../utils/toast_util.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  final auth = FirebaseAuth.instance;
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff248585),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                color: const Color(0xff70E5DE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 150,
                        ),
                        const Text(
                          "Pemesanan Nomber Antrian Gacoan",
                          style: TextStyle(color: Color(0xff248585)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailInputController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: const Icon(
                              Icons.mail,
                              color: Color(0xffD9D9D9),
                            ),
                            fillColor: const Color(0xff4ABFB8),
                            filled: true,
                            labelStyle:
                                const TextStyle(color: Color(0xffD9D9D9)),
                          ),
                          style: const TextStyle(color: Color(0xffD9D9D9)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordInputController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xffD9D9D9),
                            ),
                            fillColor: const Color(0xff4ABFB8),
                            filled: true,
                            labelStyle:
                                const TextStyle(color: Color(0xffD9D9D9)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              color: const Color(0xffD9D9D9),
                            ),
                          ),
                          style: const TextStyle(color: Color(0xffD9D9D9)),
                          obscureText: !isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                backgroundColor: const Color(0x733768E6),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Register()));
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  backgroundColor: const Color(0xffD9D9D9)),
                              child: const Text(
                                'Register',
                                style: TextStyle(color: Color(0xff248585)),
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
          ),
        ));
  }

  void login() async {
    setState(() {
      isLoading = true;
    });

    String errorMessage = "Error! Coba Lagi!";
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: emailInputController.text,
          password: passwordInputController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Alamat email Anda tampaknya tidak valid.";
          break;
        case "wrong-password":
          errorMessage = "Kata sandi Anda salah.";
          break;
        case "user-not-found":
          errorMessage = "Pengguna dengan email ini tidak ada.";
          break;
        case "user-disabled":
          errorMessage = "Pengguna dengan email ini telah dinonaktifkan.";
          break;
        case "too-many-requests":
          errorMessage = "Terlalu banyak permintaan. Coba lagi nanti.";
          break;
        case "operation-not-allowed":
          errorMessage = "Masuk dengan Email dan Kata Sandi tidak diizinkan.";
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }
      Toast().showToastMessage(errorMessage.toString());
    }

    setState(() {
      isLoading = false;
    });
  }
}
