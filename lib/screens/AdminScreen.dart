import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

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
                  return Column(
                    children: [
                      ListTile(
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
                        title: Text(
                            'Bus from ${e['from']} to ${e['destination']}'),
                        subtitle: Text(e['status']
                            ? 'Arrived at ${e['from']}'
                            : 'Arriving to ${e['from']} in ${Random(DateTime.now().millisecondsSinceEpoch.abs()).nextInt(15)} mins'),
                        trailing: Column(
                          children: [
                            Text('${e['seatsCount']} seat'),
                            Text('${e['totalPrice']}'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  EasyLoading.show();
                                  await FirebaseFirestore.instance
                                      .collection('buses')
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({
                                    'seats': [
                                      "0,0,0,0,0,0,1,1",
                                      "0,0,0,0,1,1,1,1",
                                      "0,0,0,0,1,1,1,1"
                                    ],
                                    'status': true
                                  });
                                  EasyLoading.dismiss();
                                } on Exception catch (e) {
                                  EasyLoading.showError(e.toString());
                                }
                              },
                              child: Text('Free Bus')),
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  EasyLoading.show();
                                  await FirebaseFirestore.instance
                                      .collection('buses')
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({'status': false});
                                  EasyLoading.dismiss();
                                } on Exception catch (e) {
                                  EasyLoading.showError(e.toString());
                                }
                              },
                              child: Text('Start Trip'))
                        ],
                      )
                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
