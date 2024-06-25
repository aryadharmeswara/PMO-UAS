import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:no_garco/pages/login_page.dart';
import 'package:no_garco/pages/queue_page.dart';
import 'package:no_garco/utils/location_util.dart';
import 'package:no_garco/utils/toast_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> {
  final auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xff248585),
      body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/hero.png'),
                const Text(
                  "Silakan Masukan Nama Anda",
                  style: TextStyle(color: Color(0xffD9D9D9)),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      fillColor: const Color(0xffD9D9D9),
                      filled: true,
                      labelStyle: const TextStyle(color: Color(0xff248585)),
                    ),
                    style: const TextStyle(color: Color(0xff248585)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan nama';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.camera);

                      if (file == null) return;
                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');

                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      try {
                        await referenceImageToUpload.putFile(File(file.path));
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                        Toast().showToastMessage("Gambar berhasil diambil.");
                      } catch (error) {
                        Toast().showToastMessage(
                            "Error mengambil gambar, Coba lagi!");
                      }
                    },
                    icon: const Icon(Icons.camera_alt)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (imageUrl.isEmpty) {
                      Toast().showToastMessage("Gambar belum diambil!");
                    } else {
                      addQueueNumber();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    backgroundColor: const Color(0xff3768E6),
                  ),
                  child: const Text(
                    'Konfirmasi',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    backgroundColor: const Color(0xffff0000),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )),
    ));
  }

  Future<void> addQueueNumber() async {
    setState(() {
      isLoading = true;
    });
    String name = _nameController.text;
    if (name.isEmpty) {
      setState(() {
        isLoading = false;
      });
      Toast().showToastMessage("Nama tidak boleh kosong!");
      return;
    }

    // get address
    String address = await getCurrentPositions();

    try {
      DatabaseReference queueRef =
          FirebaseDatabase.instance.ref().child('queues');
      DatabaseReference currentNumberRef = queueRef.child('current_number');

      DataSnapshot snapshot = await currentNumberRef.get();

      int? currentNumber = 0;
      String timeNow = DateFormat('dd-MM-yyyy HH:mm')
          .format(DateTime.now().add(const Duration(hours: 8)));
      if (snapshot.exists) {
        currentNumber = snapshot.value as int?;
        if (currentNumber == null) {
          currentNumber = 0;
          await currentNumberRef.set(currentNumber);
        }

        currentNumber += 1;
        await currentNumberRef.set(currentNumber);
      } else {
        currentNumber += 1;
        await currentNumberRef.set(currentNumber);
      }

      await queueRef.child('numbers').child((currentNumber).toString()).set({
        'name': name,
        'time': timeNow,
        'image': imageUrl,
        'address': address
      });

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setBool('isQueued', true);
      localStorage.setInt('queuedNumber', currentNumber);
      localStorage.setString('queuedName', name);
      localStorage.setString('queuedTime', timeNow);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Queue()));
    } catch (error) {
      Toast().showToastMessage("Error, Coba Lagi!");
    }

    setState(() {
      isLoading = false;
    });
  }

  void logout() {
    setState(() {
      isLoading = true;
    });

    auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));

    setState(() {
      isLoading = false;
    });
  }
}
