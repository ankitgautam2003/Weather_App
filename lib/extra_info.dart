import 'package:flutter/material.dart';

class ExtraInfo extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  const ExtraInfo(
    {
      super.key,
      required this.icon,
      required this.lable,
      required this.value,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 34,
        ),
        
        const SizedBox(
          height: 8,
        ),
    
        Text(lable),
        
        const SizedBox(
          height: 8,
        ),
    
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        )
      ]
    );
  }
}