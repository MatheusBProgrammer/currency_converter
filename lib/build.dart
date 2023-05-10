import 'package:flutter/material.dart';

class BuildTextField extends StatefulWidget {
  const BuildTextField({
    Key? key,
    required this.label,
    required this.prefix,
    required this.controller,
    this.onChanged, // Made optional by removing the parentheses and using square brackets
  }) : super(key: key);

  final String label;
  final String prefix;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged, // Add this line to handle the onChanged callback
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.amberAccent, fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          prefixText: widget.prefix,
          
        ),
        style: const TextStyle(color: Colors.amberAccent),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),

      ),
    );
  }
}
