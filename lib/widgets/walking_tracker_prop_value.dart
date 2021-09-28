import 'package:flutter/material.dart';

class WalkingTrackerPropValue extends StatelessWidget {
  final String property;
  final String value;
  const WalkingTrackerPropValue({
    required this.property,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(property),
          Text(value)
        ],
      ),
    );
  }
}