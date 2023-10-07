import 'dart:math';

import 'package:alutabus/utils/bus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BusFinderScreen extends StatelessWidget {
  const BusFinderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('buses').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size == 0) {
                return const Center(
                  child: Text('No bus available.'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> e = snapshot.data!.docs[index].data();
                  return ListTile(
                    onTap: !e['status']
                        ? () => EasyLoading.showError('Bus not available!')
                        : () {
                            Get.toNamed('seatSelection',
                                arguments: Bus(
                                    e['id'],
                                    e['from'],
                                    e['destination'],
                                    (e['seats']).map((element) {
                                      return element
                                          .split(',')
                                          .map((e) => int.tryParse(e))
                                          .toList();
                                    }).toList(),
                                    e['busType'],
                                    e['ticketPrice'],
                                    e['departureTime'],
                                    e['arrivalTime'],
                                    e['heading'],
                                    e['status']));
                          },
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      color: e['status'] ? Colors.green : Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            e['id'].toString().toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    title: Text('Bus from ${e['from']} to ${e['destination']}'),
                    subtitle: Text(e['status']
                        ? 'Arrived at ${e['heading']}'
                        : 'Arriving to ${e['from']} in ${Random(DateTime.now().millisecondsSinceEpoch.abs()).nextInt(15) + 1} mins'),
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
}
