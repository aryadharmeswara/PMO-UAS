import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:no_garco/pages/home_page.dart';

import '../utils/toast_util.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterPage createState() => RegisterPage();
}

class RegisterPage extends State<Register> {
  final auth = FirebaseAuth.instance;
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailInputController.dispose();
    passwordInputController.dispose();
    confirmPasswordInputController.dispose();
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
                        TextFormField(
                          controller: confirmPasswordInputController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
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
                                isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible;
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
                        ElevatedButton(
                          onPressed: register,
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
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void register() async {
    setState(() {
      isLoading = true;
    });

    String errorMessage = "Error! Coba Lagi!";
    if (passwordInputController.text == confirmPasswordInputController.text) {
      try {
        await auth.createUserWithEmailAndPassword(
            email: emailInputController.text,
            password: passwordInputController.text);
        Toast().showToastMessage("Registrasi berhasil. Silahkan Login");
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
    } else {
      errorMessage = "Kata sandi dan konfirmasi kata sandi berbeda!";
      Toast().showToastMessage(errorMessage.toString());
    }

    setState(() {
      isLoading = false;
    });
  }
}
