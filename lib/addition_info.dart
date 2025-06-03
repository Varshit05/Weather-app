import 'package:flutter/material.dart';

class AdditionInfo extends StatelessWidget{
  final IconData icon;
  final String label;
  final String value;
  const AdditionInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(children: [
        Icon(
          icon,
          size: 50,
        ),
        const SizedBox(height: 10,),
        Text(label,
          style: const TextStyle(
            fontSize: 20,
          ),),
        const SizedBox(height: 10,),
        Text(value,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),)
      ],),
    );
  }
}