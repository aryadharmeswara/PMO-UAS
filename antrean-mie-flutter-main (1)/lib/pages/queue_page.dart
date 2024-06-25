import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:no_garco/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/toast_util.dart';

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
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Image.asset(
                          'assets/images/hero2.png',
                        ),
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
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
                                )),
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
            )));
  }

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
}
