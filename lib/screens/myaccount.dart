import 'package:alutabus/screens/AdminScreen.dart';
import 'package:alutabus/screens/Bookings.dart';
import 'package:alutabus/screens/BusFinderScreen.dart';
import 'package:alutabus/screens/Notifications.dart';
import 'package:alutabus/screens/Trips.dart';
import 'package:alutabus/screens/homepage.dart';
import 'package:alutabus/screens/map_screen.dart';
import 'package:alutabus/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:alutabus/themes/colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  MyAccountState createState() => MyAccountState();
}

class MyAccountState extends State<MyAccount> {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<User> _handleSignIn() async {
  //   //final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   //final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //   // final AuthCredential credential = GoogleAuthProvider.credential(
  //   //   idToken: googleAuth.idToken,
  //   //   accessToken: googleAuth.accessToken,
  //   // );
  //
  //   final User user = (await _auth.signInWithCredential(credential)).user;
  //   print('Signed in ' + user.displayName);
  //   return user;
  // }

  List<Map<String, dynamic>> settings = [
    {'label': 'Admin', 'routeWidget': const AdminScreen()},
    {'label': 'Bus finder ', 'routeWidget': const BusFinderScreen()},
    {'label': 'Buses location', 'routeWidget': const MapScreen()},
    {'label': 'My bookings', 'routeWidget': const Bookings()},
    {'label': 'Recent trips', 'routeWidget': const Trips()},
    {'label': 'Notifications', 'routeWidget': const Notifications()},
    // {'label': 'Settings', 'routeWidget': null},
    {'label': 'Sign Out', 'routeWidget': const StartScreen()},
  ];

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //double screenWidth = (MediaQuery.of(context).size.width / 2) / 2;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: radicalGreen,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        color: radicalGreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width / 2),
                    border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 2.0)),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: Hero(
                      tag: 'profileAvatar',
                      child: Image.asset('assets/placeholder.png',
                          fit: BoxFit.fill)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                auth.currentUser != null
                    ? auth.currentUser!.email.toString()
                    : 'Username',
              ),
            ),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 8,
                        spreadRadius: 8)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: backgroundColor,
                ),
                child: ListView(
                  children: settings.map((item) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(item['label'],
                              style: const TextStyle(
                                  color: smoky, fontWeight: FontWeight.bold)),
                          onTap: () async {
                            if (item['label'] == 'Sign Out') {
                              final User? user = auth.currentUser;
                              if (user != null) {
                                await auth.signOut();
                                Get.offAll(item['routeWidget']);
                              }
                            }
                            if (item['label'] == 'Admin') {
                              TextEditingController code =
                                  TextEditingController();
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog.adaptive(
                                    title: const Text('Admin login'),
                                    content: Column(
                                      children: [
                                        Text('Enter admin code.'),
                                        TextFormField(
                                          controller: code,
                                        )
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            if (code.text == '2023') {
                                              Navigator.of(_).pop();
                                              Get.to(item['routeWidget']);
                                            } else {
                                              EasyLoading.showError(
                                                  'Invalid code!');
                                            }
                                          },
                                          child: const Text('Submit')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(_).pop(),
                                          child: const Text('Cancel')),
                                    ],
                                  );
                                },
                              );
                              return;
                            }
                            Get.to(item['routeWidget'] ?? const MyHomePage());
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// void _signOut() async {
//   await _auth.signOut();
// }
}
