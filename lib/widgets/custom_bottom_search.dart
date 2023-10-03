import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alutabus/screens/search_buses.dart';
import 'package:alutabus/themes/colors.dart';
import 'package:get/get.dart';

class CustomBottomSearch extends StatelessWidget {
  final TextEditingController? fromController;
  final TextEditingController? destinationController;
  final double? elevation;
  final Color? color;

  const CustomBottomSearch(
      {Key? key,
      this.fromController,
      this.destinationController,
      this.elevation,
      this.color})
      : super(key: key);

  static const locations = [
    'Samaru',
    'Congo',
    'ABUTH',
    'Site II',
    'IAR',
    'Gym',
    'Faculty of Physical Science'
  ];

  @override
  Widget build(BuildContext context) {
    String from = '', destination = '';

    return Card(
      clipBehavior: Clip.antiAlias,
      color: color,
      margin: EdgeInsets.zero,
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: fromController,
                    keyboardType: TextInputType.none,
                    onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (_) => Container(
                              padding: const EdgeInsets.all(20),
                              child: ListView.builder(
                                  itemCount: locations.length,
                                  itemBuilder: (_, index) => ListTile(
                                        title: Text(locations[index]),
                                        onTap: () {
                                          fromController!.text =
                                              locations[index];
                                          Navigator.of(_).pop();
                                        },
                                      )),
                            )),
                    style: const TextStyle(fontSize: 14.0, color: radicalGreen),
                    decoration: const InputDecoration(
                        icon: Icon(
                          FontAwesomeIcons.circleDot,
                          color: radicalGreen,
                        ),
                        labelText: 'From',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: bermudaGray)),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 38),
                    child: Divider(
                      color: bermudaGray,
                    ),
                  ),
                  TextField(
                    controller: destinationController,
                    keyboardType: TextInputType.none,
                    onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (_) => Container(
                              padding: const EdgeInsets.all(20),
                              child: ListView.builder(
                                  itemCount: locations.length,
                                  itemBuilder: (_, index) => ListTile(
                                        title: Text(locations[index]),
                                        onTap: () {
                                          destinationController!.text =
                                              locations[index];
                                          Navigator.of(_).pop();
                                        },
                                      )),
                            )),
                    style: const TextStyle(
                        fontSize: 14.0, color: Colors.deepPurple),
                    decoration: const InputDecoration(
                        icon: Icon(
                          FontAwesomeIcons.circleDot,
                          color: Colors.deepPurple,
                        ),
                        border: InputBorder.none,
                        labelText: 'Destination',
                        labelStyle: TextStyle(color: bermudaGray)),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                backgroundColor: Get.theme.colorScheme.primary,
                onPressed: () {
                  if (fromController == null || destinationController == null) {
                    Get.showSnackbar(const GetSnackBar(
                        message: 'input controllers not found!'));

                    return;
                  }
                  try {
                    from = fromController!.text;
                    destination = destinationController!.text;
                    if (from.isEmpty || destination.isEmpty) {
                      Get.showSnackbar(const GetSnackBar(
                          message: 'origin or destination is missing!'));
                      return;
                    }
                    debugPrint('$from - $destination');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchBuses(
                                  from: from,
                                  destination: destination,
                                )));
                  } on Exception catch (e) {
                    e.printError();
                    Get.showSnackbar(GetSnackBar(
                        message:
                            'failed to search a bus for route $from-$destination'));
                  }
                },
                child: Icon(
                  Icons.search,
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
