import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alutabus/themes/colors.dart';
import 'package:alutabus/widgets/custom_dotted_line.dart';

class CustomStepper extends StatelessWidget {
  const CustomStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Icon(
          FontAwesomeIcons.circleDot,
          color: radicalGreen,
        ),
        CustomPaint(
          painter: LineDashedPainter(
            color: bermudaGray,
            maxValue: 35,
            dashSpace: 4,
            dashWidth: 2,
            strokeWidth: 2,
          ),
        ),
        const Icon(
          FontAwesomeIcons.circleDot,
          color: Colors.deepPurple,
        ),
      ],
    );
  }
}
