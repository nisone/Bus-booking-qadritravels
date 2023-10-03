import 'package:alutabus/screens/Bookings.dart';
import 'package:alutabus/screens/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alutabus/screens/booking_confirm.dart';
import 'package:alutabus/screens/confirm_booking.dart';
import 'package:alutabus/screens/homepage.dart';
import 'package:alutabus/screens/myaccount.dart';
import 'package:alutabus/screens/notification_page.dart';
import 'package:alutabus/screens/search_buses.dart';
import 'package:alutabus/screens/seat_selection.dart';
import 'package:alutabus/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Alutabus());
}

class Alutabus extends StatelessWidget {
  const Alutabus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aluta Bus',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Lato',
        colorSchemeSeed: const Color(0xFF50C878),
      ),
      getPages: [
        GetPage(name: '/home', page: () => const MyHomePage()),
        GetPage(
            name: '/confirmBooking',
            page: () => const ConfirmBooking(),
            transition: Transition.rightToLeft),
        GetPage(name: '/seatSelection', page: () => const SeatSelection()),
        GetPage(name: '/myaccount', page: () => const MyAccount()),
        GetPage(name: '/searchBuses', page: () => const SearchBuses()),
        GetPage(name: '/startScreen', page: () => const StartScreen()),
        GetPage(
            name: '/notificationPage', page: () => const NotificationPage()),
        GetPage(name: '/bookingConfirm', page: () => const BookingConfirm()),
        GetPage(name: '/mybookings', page: () => const Bookings()),
        GetPage(name: '/notifications', page: () => const Notifications()),
      ],
      home: const StartScreen(),
    );
  }
}
