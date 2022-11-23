import 'package:flutter/material.dart';

class ListaPolline extends StatelessWidget {
  const ListaPolline({super.key, required this.data, required this.tipo});
  final dynamic data;
  final String tipo;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(3.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
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
                  image: AssetImage('assets/images/${tipo.toLowerCase()}.png'),
                  fit: BoxFit.fill),
            ),
          ),
          Text(tipo)
        ],
      ),
    );
  }
}
