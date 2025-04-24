import 'package:flutter/material.dart';

class RollButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final int count;

  const RollButton({this.onPressed, required this.count, super.key});

  @override
  State<RollButton> createState() => _RollButtonState();
}

class _RollButtonState extends State<RollButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: widget.count > 0 ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 8, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), 
          ),
          backgroundColor: widget.count > 0
              ? Colors.yellowAccent.shade700 
              : Colors.grey.shade400, 
          foregroundColor: Colors.black, 
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(
              widget.count > 0 ? Icons.casino : Icons.cancel, 
              size: 24,
              color: Colors.black, 
            ),
            const SizedBox(width: 10),
            Text(
              widget.count > 0
                  ? 'Rolls left: ${widget.count} 😊'
                  : 'Out of rolls 😢',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


