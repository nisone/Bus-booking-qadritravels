import 'package:alutabus/utils/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alutabus/themes/colors.dart';
import 'package:alutabus/utils/bus.dart';
import 'package:alutabus/widgets/departure_arrival_widget.dart';

class ConfirmBooking extends StatelessWidget {
  const ConfirmBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var seats = Get.arguments;
    List<Map> seat = seats[0];
    Bus bus = seats[1];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: radicalGreen,
        elevation: 2,
        title: const Text('Confirm Booking'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    elevation: 16.0,
                    color: radicalGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${bus.from} - ${bus.destination}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                              color: cadetBlue,
                            ),
                          ),
                          Text(
                            bus.busType,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: cadetBlue,
                            ),
                          ),
                          const Divider(
                            color: backgroundColor,
                          ),
                          const DepartureArrivalWidget(),
                          const Divider(color: backgroundColor),
                          Text(
                            'Total seats: ${seat.length} |  ₦${bus.ticketPrice}/ticket',
                            style: const TextStyle(
                                color: mystic,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total Price: ₦${bus.ticketPrice * seat.length}',
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: mystic),
                          ),
                          Flexible(
                            child: ListView.builder(
                                itemCount: seats.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      //TODO: save booking data to firestore
                      Ticket myTicket = Ticket(
                        uid: uid,
                        busId: bus.id,
                        totalPrice: (bus.ticketPrice * seat.length).toDouble(),
                        origin: bus.from,
                        destination: bus.destination,
                        seatsCount: seat.length,
                        seatsNumber: seat.map((e) => e['label']).toList(),
                        departureTime: bus.departureTime,
                        arrivalTime: bus.arrivalTime,
                        status: true,
                        isPaid: false,
                      );

                      await FirebaseFirestore.instance
                          .collection('tickets')
                          .doc()
                          .set(myTicket.toJson());

                      if (await updateBusSeat(bus, seat)) {
                        // TODO: handle payments
                        // TODO: send ticket data to user email
                        Get.toNamed('bookingConfirm');
                      } else {
                        Get.showSnackbar(
                            const GetSnackBar(message: 'booking failed!'));
                      }
                    } on Exception catch (e) {
                      e.printError();
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bolt, color: Colors.amberAccent.shade100),
                      const Text('Instant Book',
                          style: TextStyle(fontSize: 20.0)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> updateBusSeat(
      Bus bus, List<Map<dynamic, dynamic>> reserveSeat) async {
    var seats = bus.seats;
    List n1DList = [];
    for (var row in seats) {
      for (var seat in row) {
        n1DList.add(seat);
      }
    }
    seats.printInfo();
    n1DList.printInfo();

    for (var val in reserveSeat) {
      n1DList[val['index']] = 2;
    }

    n1DList.printInfo();
    var n1DListCounter = 0;
    for (var i = 0; seats.length > i; i++) {
      for (var j = 0; seats[i].length > j; j++) {
        seats[i][j] = n1DList[n1DListCounter];
        n1DListCounter++;
      }
    }
    seats.printInfo();

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('buses')
        .where('id', isEqualTo: bus.id)
        .limit(1)
        .get();
    QueryDocumentSnapshot<Map<String, dynamic>> myBus = snapshot.docs.first;
    var status = await FirebaseFirestore.instance
        .runTransaction<bool>((transaction) async {
      var freshSnapshot = await transaction.get(myBus.reference);
      transaction.update(myBus.reference, {
        'seats': seats.map((e) => e.join(',')).toList(),
      });
      return true;
    });

    if (status) {
      return status;
    }

    return false;
  }
}
