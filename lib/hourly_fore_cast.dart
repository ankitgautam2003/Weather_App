import 'dart:ui';

import 'package:flutter/material.dart';

class HourlyForeCast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForeCast(
    {
      super.key,
      required this.time,
      required this.icon,
      required this. temp
    }
  );

  @override
  Widget build(BuildContext context) {
    return Card(
                    elevation: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                time,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          
                              const SizedBox(
                                height: 10,
                              ),
                          
                              Icon(
                                icon,
                                size: 30
                              ),
                          
                              const SizedBox(
                                height: 10,
                              ),
                          
                              Text(temp),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
  }
}