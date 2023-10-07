import 'package:alutabus/utils/seat_arrangement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alutabus/themes/colors.dart';
import 'package:alutabus/utils/bus.dart';

class SearchBuses extends StatefulWidget {
  final String? from;
  final String? destination;

  const SearchBuses({Key? key, this.from, this.destination}) : super(key: key);

  @override
  SearchBusesState createState() => SearchBusesState();
}

class SearchBusesState extends State<SearchBuses> {
  final List<Bus> buses = [
    Bus('bus_id_c7890', 'Phase II', 'Medicine', defaultSeats, 'NON-AC', 250,
        '09:00', '10:00', 'heading', true),
    Bus('bus_id_c7890', 'Gym', 'Phase II', defaultSeats, 'NON-AC', 250, '09:00',
        '10:00', 'heading', true),
    Bus('bus_id_c7890', 'Samaru', 'Congo', defaultSeats, 'AC', 650, '09:00',
        '10:00', 'heading', true),
    Bus('bus_id_c7890', 'Samaru', 'Phase II', defaultSeats, 'AC', 450, '09:00',
        '10:00', 'heading', true),
    Bus('bus_id_c7890', 'ABUTH Shika', 'Congo', defaultSeats, 'AC', 1500,
        '09:00', '10:00', 'heading', true),
    Bus('bus_id_c7890', 'Flyover', 'Congo', defaultSeats, 'AC', 1700, '09:00',
        '10:00', 'heading', true),
    Bus('bus_id_c7890', 'Samaru', 'IAR', defaultSeats, 'AC', 350, '09:00',
        '10:00', 'heading', true),
    Bus('bus_id_c7890', 'Flyover', 'ABUTH Shika', defaultSeats, 'AC', 210,
        '09:00', '10:00', 'heading', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buses Found',
          style: TextStyle(color: smoky, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white10,
        iconTheme: const IconThemeData(
          color: smoky,
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('buses')
                .where('from', isEqualTo: widget.from!)
                .where('destination', isEqualTo: widget.destination!)
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                snapshot.data!.docs.length.printInfo();
                var busesDocs = snapshot.data!.docs
                    .map<Bus>((busDoc) => Bus(
                        busDoc['id'],
                        busDoc['from'],
                        busDoc['destination'],
                        (busDoc['seats']).map((element) {
                          return element
                              .split(',')
                              .map((e) => int.tryParse(e))
                              .toList();
                        }).toList(),
                        busDoc['busType'],
                        busDoc['ticketPrice'],
                        busDoc['departureTime'],
                        busDoc['arrivalTime'],
                        busDoc['heading'],
                        busDoc['status']))
                    .toList();
                return ListView.builder(
                    itemCount: busesDocs.length,
                    itemBuilder: (context, index) {
                      return BusCard(
                        bus: busesDocs[index],
                      );
                    });
              }

              if (snapshot.hasError) {
                snapshot.error.printError();
              }

              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }),
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  const BusCard({
    Key? key,
    required this.bus,
  }) : super(key: key);

  final Bus bus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 8),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(1, 1),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.elliptical(8, 8)),
            color: backgroundColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${bus.from} - ${bus.destination}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: darkAccent),
                  ),
                  Text(
                    '₦${bus.ticketPrice}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: radicalGreen),
                  ),
                ],
              ),
              Text(
                bus.busType,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.grey[500]),
              ),
              const Flexible(child: Divider()),
              BusRouteWidget(bus: bus),
            ],
          ),
        ),
      ),
    );
  }
}

class BusRouteWidget extends StatelessWidget {
  const BusRouteWidget({Key? key, required this.bus}) : super(key: key);

  final Bus bus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: 'Departure\n',
              style: Theme.of(context).textTheme.labelSmall,
              children: [
                TextSpan(
                    text: bus.departureTime,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kobi)),
              ]),
        ),
        const Icon(
          Icons.arrow_forward,
          color: kobi,
        ),
        RichText(
          text: TextSpan(
              text: 'Arrival\n',
              style: Theme.of(context).textTheme.labelSmall,
              children: [
                TextSpan(
                  text: bus.arrivalTime,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: kobi),
                ),
              ]),
        ),
        ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(3.0),
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => radicalGreen)),
            child: const Text(
              'Book Now',
              style: TextStyle(color: mystic),
            ),
            onPressed: () {
              Get.toNamed('seatSelection', arguments: bus);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SeatSelection()));
            }),
      ],
    );
  }
}
