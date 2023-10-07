import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Trips extends StatelessWidget {
  const Trips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tickets')
              .where('status', isEqualTo: true)
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
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
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
                          trailing: Column(
                            children: [
                              Text('${e['seatsCount']} seat'),
                              Text('${e['totalPrice']}'),
                            ],
                          ),
                        ),
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
}
