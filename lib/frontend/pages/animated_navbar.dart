import 'package:flutter/material.dart';

class AnimationBar extends StatefulWidget {
  const AnimationBar({super.key});

  @override
  State<AnimationBar> createState() => _AnimationBarState();
}

class _AnimationBarState extends State<AnimationBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Text('Home Screen')]));
  }
}