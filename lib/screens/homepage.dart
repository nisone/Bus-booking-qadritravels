import 'package:flutter/material.dart';
import 'package:alutabus/widgets/custom_appbar.dart';
import 'package:alutabus/widgets/custom_bottom_search.dart';
import 'package:alutabus/widgets/custom_recent_trip_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          height: 150,
        ),
        body: MainBody());
  }
}

class MainBody extends StatelessWidget {
  const MainBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController fromController = TextEditingController(),
        destinationController = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Recent Trips'),
              ),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CustomRecentTripCard(
                      dateOfTheMonth: 23,
                      dayOfTheMonth: 'Mon',
                      from: 'Zaria',
                      destination: 'Samaru',
                    ),
                    CustomRecentTripCard(
                      dateOfTheMonth: 24,
                      dayOfTheMonth: 'Tue',
                      from: 'Main Campus',
                      destination: 'Congo Campus',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomBottomSearch(
            fromController: fromController,
            destinationController: destinationController,
          )
        ],
      ),
    );
  }
}
