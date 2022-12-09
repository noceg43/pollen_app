import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';

class SchedaInfoParticella extends StatelessWidget {
  const SchedaInfoParticella({super.key, required this.p});
  final Particella p;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: const Color(0xFFF1F1F1),
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0.0, -50.0),
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/${p.tipo.toLowerCase()}.png'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0.0, -50.0),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut dictum turpis quis quam pharetra eleifend. Nunc maximus est sed turpis gravida, quis hendrerit urna maximus. Praesent elementum velit nec mi ultricies sollicitudin. Nulla in urna est. Nulla neque velit, consectetur vitae facilisis non, consequat sed libero. Donec auctor libero a rhoncus tempus. Ut urna lorem, maximus sed est efficitur, euismod vestibulum lorem. Praesent nec ligula vitae metus malesuada iaculis. Mauris lacinia est quis accumsan suscipit. Proin ex lectus, rhoncus at orci sit amet, dictum efficitur ligula. In hac habitasse platea dictumst. Maecenas convallis mattis quam, sed cursus arcu sollicitudin sagittis.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
