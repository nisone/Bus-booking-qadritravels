import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bookings extends StatelessWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tickets')
              .where('uid',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size == 0) {
                return const Center(
                  child: Text('No booking record available.'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> e = snapshot.data!.docs[index].data();
                  return ListTile(
                    onTap: () => e['status']
                        ? showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog.adaptive(
                                title: const Text('Warning!'),
                                content: const Column(
                                  children: [
                                    Text('Cancel reservation?'),
                                    Text(
                                      'Note: Ticket price is not refundable.',
                                      style: TextStyle(fontSize: 8),
                                    )
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        cancelTicket(
                                            e['busId'],
                                            e['seatsNumber'],
                                            snapshot
                                                .data!.docs[index].reference);
                                        Navigator.of(_).pop();
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () => Navigator.of(_).pop(),
                                      child: const Text('No')),
                                ],
                              );
                            },
                          )
                        : null,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      color: e['status'] ? Colors.green : Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Seats #',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            e['seatsNumber'].join(','),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    title: Text('${e['origin']} - ${e['destination']}'),
                    subtitle:
                        Text('${e['departureTime']} - ${e['arrivalTime']}'),
                    trailing: Column(
                      children: [
                        Text('${e['seatsCount']} seat'),
                        Text('${e['totalPrice']}'),
                      ],
                    ),
                  );
                },
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }),
    );
  }

  Future<bool> cancelTicket(String busId, List<dynamic> reserveSeat,
      DocumentReference ticketRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('buses')
        .where('id', isEqualTo: busId)
        .limit(1)
        .get();
    QueryDocumentSnapshot<Map<String, dynamic>> myBus = snapshot.docs.first;
    var seats = myBus.get('seats').map((element) {
      return element.split(',').map((e) => int.tryParse(e)).toList();
    }).toList();
    List n1DList = [];
    for (var row in seats) {
      for (var seat in row) {
        n1DList.add(seat);
      }
    }

    n1DList.printInfo();

    for (var val in reserveSeat) {
      n1DList[int.parse(val)] = 1;
    }

    n1DList.printInfo();
    var n1DListCounter = 0;
    for (var i = 0; seats.length > i; i++) {
      for (var j = 0; seats[i].length > j; j++) {
        seats[i][j] = n1DList[n1DListCounter];
        n1DListCounter++;
      }
    }

    var status = await FirebaseFirestore.instance
        .runTransaction<bool>((transaction) async {
      var freshSnapshot = await transaction.get(myBus.reference);
      transaction.update(myBus.reference, {
        'seats': seats.map((e) => e.join(',')).toList(),
      });
      transaction.update(ticketRef, {
        "status": false,
      });
      return true;
    });

    if (status) {
      return status;
    }

    return false;
  }
}
