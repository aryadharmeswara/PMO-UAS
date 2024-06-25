# no_garco

Aplikasi pemesanan mie

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

1. Aplikasi pemesanan NoGarco berbasis aplikasi adalah solusi digital yang memudahkan pengguna dalam mengatur dan mengelola antrean. Aplikasi ini dilengkapi dengan fitur login dan register untuk keamanan dan personalisasi, pemesanan no antrean yang memungkinkan pengguna untuk mendapatkan no antrean pada aplikasi NoGarco,  riwayat no antrean untuk melihat dan mengelola antrean sebelumnya, serta pembatalan no antrean untuk fleksibilitas dalam pengelolaan waktu. Fitur logout memastikan keamanan dan privasi data pengguna. Dengan antarmuka yang ramah pengguna, aplikasi ini meningkatkan efisiensi dan kenyamanan dalam mengatur antrean.


2. https://github.com/aryadharmeswara/FigmaNoGarco


3. ## penjelasan kodingan kamera
ImagePicker Instance:
ImagePicker imagePicker = ImagePicker();
Membuat instance dari ImagePicker untuk mengakses fungsionalitas pengambilan gambar.
Mengambil Gambar:
XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
pickImage: Metode ini membuka kamera perangkat untuk mengambil gambar.
source: ImageSource.camera: Menentukan bahwa sumber gambar adalah kamera.
Cek Jika Gambar Tidak Diambil:
if (file == null) return;
Jika pengguna tidak mengambil gambar atau membatalkan tindakan, file akan null dan fungsi akan berhenti di sini.
Generate Unique File Name:
String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
Membuat nama file unik berdasarkan timestamp saat ini.
Firebase Storage Reference:
Reference referenceRoot = FirebaseStorage.instance.ref();
Reference referenceDirImages = referenceRoot.child('images');
Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
Mendapatkan referensi root dari Firebase Storage.
Membuat referensi untuk direktori images.
Membuat referensi untuk file gambar yang akan diupload dengan nama file unik.
Upload File:
await referenceImageToUpload.putFile(File(file.path));
imageUrl = await referenceImageToUpload.getDownloadURL();
putFile(File(file.path)): Mengupload file gambar ke Firebase Storage.
getDownloadURL(): Mendapatkan URL download untuk gambar yang diupload.
Menampilkan Pesan Toast:
Toast().showToastMessage("Gambar berhasil diambil.");
Menampilkan pesan toast yang menunjukkan bahwa gambar berhasil diambil.
Menangani Kesalahan:
catch (error) {
  Toast().showToastMessage("Error mengambil gambar, Coba lagi!");
}
Menangani kesalahan jika terjadi masalah saat mengambil atau mengupload gambar, dan menampilkan pesan kesalahan menggunakan toast.


## penjelasan kodingan login
Pengaturan State Awal:
setState(() {
  isLoading = true;
});
Bagian ini mengubah state isLoading menjadi true. Tujuannya adalah untuk menampilkan indikator pemuatan (loading indicator) saat proses login sedang berlangsung, memberi tahu pengguna bahwa aplikasi sedang memproses permintaan login.
Deklarasi Pesan Kesalahan Default:
String errorMessage = "Error! Coba Lagi!";
Variabel errorMessage diinisialisasi dengan pesan kesalahan default. Pesan ini akan ditampilkan kepada pengguna jika terjadi kesalahan yang tidak terduga selama proses login.
Blok try untuk Mencoba Login:
try {
  final user = await auth.signInWithEmailAndPassword(
      email: emailInputController.text,
      password: passwordInputController.text);
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const Home()));
}

Bagian ini mencoba untuk melakukan login menggunakan Firebase Authentication.
auth.signInWithEmailAndPassword adalah metode dari Firebase Authentication yang memerlukan dua parameter: email dan password yang diambil dari emailInputController dan passwordInputController.
Jika login berhasil, pengguna akan diarahkan ke halaman Home menggunakan Navigator.pushReplacement. Metode ini mengganti halaman saat ini dengan halaman Home, sehingga pengguna tidak dapat kembali ke halaman login dengan tombol kembali (back button).
Blok catch untuk Menangani Kesalahan:
on FirebaseAuthException catch (e) {
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
Jika terjadi kesalahan selama proses login, blok ini menangkap FirebaseAuthException.
switch (e.code) memeriksa kode kesalahan yang dikembalikan oleh Firebase dan mengatur errorMessage sesuai dengan jenis kesalahan yang terjadi.
Setiap kasus kesalahan (seperti "invalid-email", "wrong-password", dll.) memiliki pesan kesalahan yang sesuai untuk memberikan umpan balik yang spesifik kepada pengguna.
Setelah menentukan pesan kesalahan yang sesuai, Toast().showToastMessage(errorMessage.toString()) digunakan untuk menampilkan pesan kesalahan tersebut dalam bentuk toast (popup notifikasi singkat) di layar.
Mengatur State Akhir:
setState(() {
  isLoading = false;
});
Bagian ini mengubah state isLoading kembali menjadi false setelah proses login selesai (baik berhasil maupun gagal), sehingga indikator pemuatan (loading indicator) disembunyikan.


## penjelasan kodingan register
ElevatedButton(
  onPressed: () {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Register()));
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

Penjelasan Komponen Register
onPressed:
Merupakan properti pada ElevatedButton yang menentukan aksi yang akan dijalankan saat tombol ditekan.
Pada kode ini, menggunakan Navigator.push untuk menavigasi ke halaman baru.
context digunakan untuk mendapatkan akses ke navigator yang terkait dengan aplikasi.
MaterialPageRoute adalah widget yang menentukan jenis transisi halaman dengan gaya material design.
Dalam contoh ini, builder: (context) => const Register() digunakan untuk membuat dan menunjukkan halaman Register.
style:
Properti untuk menyesuaikan gaya tombol.
ElevatedButton.styleFrom digunakan untuk menetapkan beberapa atribut gaya sekaligus.
padding mengatur jarak dalam tombol.
shape menentukan bentuk tombol, di sini menggunakan RoundedRectangleBorder dengan radius sudut sebesar 12.0 untuk menampilkan sudut tombol yang melengkung.
backgroundColor menetapkan warna latar belakang tombol menjadi Color(0xffD9D9D9).
child:
Merupakan properti yang mendefinisikan isi dari ElevatedButton.
Dalam hal ini, menggunakan Text widget dengan teks "Register".
Properti style pada Text mengatur gaya teks dengan warna teks ditetapkan sebagai Color(0xff248585).



## penjelasan kodingan firebase

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

FirebaseOptions: Diimpor dari firebase_core.dart. Ini adalah kelas yang digunakan untuk menyediakan opsi konfigurasi Firebase seperti apiKey, appId, projectId, dan lain-lain.
defaultTargetPlatform: Diimpor dari flutter/foundation.dart. Ini adalah variabel yang memberikan informasi tentang platform target aplikasi Flutter saat ini.
kIsWeb dan TargetPlatform: Variabel dan enum yang memberikan informasi tambahan tentang platform yang sedang berjalan.
DefaultFirebaseOptions Class
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

currentPlatform: Metode statis yang mengembalikan FirebaseOptions sesuai dengan platform target saat ini.
kIsWeb Check: Jika aplikasi sedang berjalan di web (kIsWeb true), sebuah UnsupportedError dilemparkan karena opsi Firebase belum dikonfigurasi untuk web.
Switch Case on defaultTargetPlatform: Memeriksa defaultTargetPlatform dan mengembalikan FirebaseOptions yang sesuai untuk platform yang sedang berjalan seperti Android (android) dan iOS (ios). Platform lain seperti macOS, Windows, dan Linux akan melemparkan UnsupportedError karena belum dikonfigurasi.


## penjelasan kodingan antrian dan cancel

Stateful Widget dan State Initialization:
class Queue extends StatefulWidget {
  const Queue({super.key});

  @override
  QueuePage createState() => QueuePage();
}

class QueuePage extends State<Queue> {
  int number = 0;
  String name = "";
  String time = "";
  bool isLoading = false;
}

Queue adalah StatefulWidget yang memiliki QueuePage sebagai State-nya.
State (QueuePage) memiliki variabel number untuk menyimpan nomor antrian, name untuk menyimpan nama pengantre, time untuk menyimpan waktu pembuatan antrian, dan isLoading untuk mengontrol tampilan saat sedang memuat.
initState dan getQueueData:
@override
void initState() {
  super.initState();
  getQueueData();
}

void getQueueData() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  setState(() {
    number = localStorage.getInt('queuedNumber')!;
    name = localStorage.getString('queuedName')!;
    time = localStorage.getString('queuedTime')!;
  });
}

initState() dipanggil saat Widget pertama kali diinisialisasi. Di dalamnya, getQueueData() dipanggil untuk mengambil data antrian dari SharedPreferences dan mengupdate state number, name, dan time.
Build Method:
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xff248585),
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xff248585),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      title: Image.asset(
        'assets/images/logo2.png',
        width: 250,
      ),
      centerTitle: true,
    ),
    body: ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Nama pengantre",
                style: TextStyle(color: Color(0xffD9D9D9), fontSize: 20),
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xffD9D9D9),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image.asset('assets/images/hero2.png'),
                  Column(
                    children: <Widget>[
                      Card.outlined(
                        color: const Color(0x99D9D9D9),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text(
                                "Nomor Antrean Anda",
                                style: TextStyle(fontSize: 30),
                              ),
                              Text(
                                number.toString(),
                                style: const TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card.outlined(
                        color: const Color(0x99D9D9D9),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text(
                                "Antrean Dibuat Pada",
                                style: TextStyle(fontSize: 25),
                              ),
                              Text(
                                time,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: cancelQueue,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: const Color(0xff3768E6),
                        ),
                        child: const Text(
                          'Batalkan Antrean',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

build(BuildContext context) mengatur tata letak halaman antrian.
AppBar digunakan untuk menampilkan logo aplikasi.
ModalProgressHUD digunakan untuk menampilkan indikator loading saat isLoading true.
Column digunakan untuk menata konten vertikal di tengah halaman.
Text menampilkan nama pengantre yang diambil dari name.
Stack digunakan untuk menumpuk gambar hero dan konten kartu.
Card.outlined digunakan untuk menampilkan nomor antrian dan waktu pembuatan antrian.
ElevatedButton memberikan opsi untuk membatalkan antrian dengan memanggil fungsi cancelQueue() saat ditekan.
Fungsi cancelQueue:
void cancelQueue() async {
  setState(() {
    isLoading = true;
  });

  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String queuedNumber = localStorage.getInt('queuedNumber').toString() ?? '';

  if (queuedNumber.isNotEmpty) {
    try {
      DatabaseReference queueRef =
          FirebaseDatabase.instance.ref().child('queues');
      DatabaseReference queueEntryRef =
          queueRef.child('numbers').child(queuedNumber);

      await queueEntryRef.remove();

      DatabaseReference currentNumberRef = queueRef.child('current_number');
      DataSnapshot snapshot = await currentNumberRef.get();
      int? currentNumber = snapshot.value as int?;
      if (currentNumber != null && currentNumber > 0) {
        await currentNumberRef.set(currentNumber - 1);
      }

      localStorage.remove('isQueued');
      localStorage.remove('queuedNumber');
      localStorage.remove('queuedName');
      localStorage.remove('queuedTime');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (error) {
      Toast().showToastMessage("Gagal membatalkan antrean!");
    }
  }

  setState(() {
    isLoading = false;
  });
}

cancelQueue() digunakan untuk membatalkan antrian pengguna.
Memuat indikator loading dengan mengatur isLoading menjadi true.
Mengambil nomor antrian yang sedang di-queue dari SharedPreferences.
Menghapus entri antrian dari Firebase Realtime Database menggunakan FirebaseDatabase.instance.ref().
Mengupdate nomor antrian saat ini di Firebase jika berhasil menghapus.
Menghapus data antrian dari SharedPreferences.
Mengarahkan pengguna kembali ke halaman utama (Home) setelah membatalkan antrian.
Menghentikan indikator loading dengan mengatur isLoading menjadi false setelah selesai.

## penjelasan kodingan lokasi (google maps)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:no_garco/utils/toast_util.dart';

dart:async: Digunakan untuk mendefinisikan tipe-tipe Future yang digunakan dalam operasi operasi asyncronous.
flutter/material.dart: Paket dasar dari Flutter untuk membangun UI.
geocoding: Paket untuk mengonversi koordinat geografis menjadi alamat.
geolocator: Paket untuk mengambil data lokasi perangkat pengguna.
toast_util.dart: Berkemungkinan paket utilitas untuk menampilkan pesan toast.
Fungsi handleLocationPermission:
Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Toast().showToastMessage('Ijin akses lokasi diperlukan!');
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Toast().showToastMessage('Ijin akses lokasi diperlukan!');
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Toast().showToastMessage('Ijin akses lokasi ditolak. Anda tidak akan dapat membuat antrean!');
    return false;
  }
  return true;
}

Fungsi ini bertujuan untuk menangani izin akses lokasi:
Memeriksa apakah layanan lokasi aktif.
Memeriksa dan meminta izin akses lokasi jika belum diizinkan atau ditolak.
Menampilkan pesan toast sesuai dengan status izin akses.
Fungsi getCurrentPositions:
Future<String> getCurrentPositions() async {
  final hasPermission = await handleLocationPermission();
  late String address;

  if (!hasPermission) return 'error';
  try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    address = '${placemark.street}, ${placemark.subLocality}, ${placemark.subAdministrativeArea}, ${placemark.postalCode}';
  } catch (e) {
    debugPrint(e as String?);
    return 'error';
  }
  return address;
}
Fungsi ini bertujuan untuk mendapatkan posisi saat ini (latitude dan longitude) dan mengonversinya menjadi alamat:
Memanggil handleLocationPermission() untuk memastikan izin lokasi telah diberikan.
Jika izin tidak ada, fungsi mengembalikan 'error'.
Jika izin diberikan, mendapatkan posisi terkini dengan akurasi yang diinginkan (LocationAccuracy.high).
Mengambil data alamat dari koordinat menggunakan placemarkFromCoordinates.
Mengembalikan alamat yang terdiri dari jalan, sub-lokasi, sub-administrative area, dan kode pos.



4.  flutter pub get
    flutter run