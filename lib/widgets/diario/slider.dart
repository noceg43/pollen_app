import 'package:flutter/material.dart';

class SliderStatoFisico extends StatefulWidget {
  const SliderStatoFisico({super.key});

  @override
  State<SliderStatoFisico> createState() => _SliderStatoFisicoState();
}

class _SliderStatoFisicoState extends State<SliderStatoFisico> {
  double _currentSliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue < 10 ? 10 : _currentSliderValue,
      max: 100,
      divisions: 10,
      label: (_currentSliderValue / 10).round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}

class SliderOra extends StatefulWidget {
  const SliderOra({super.key});

  @override
  State<SliderOra> createState() => _SliderOraState();
}

class _SliderOraState extends State<SliderOra> {
  double _currentSliderValue = 24;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      max: 240,
      divisions: 24,
      label: (_currentSliderValue / 10).round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}
