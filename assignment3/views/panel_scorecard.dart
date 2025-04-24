import 'package:flutter/material.dart';

class ScorecardPanel extends StatefulWidget {
  final String name;
  final VoidCallback? onTap;
  final int? value;
  final bool isEnabled; 

  const ScorecardPanel({
    super.key,
    required this.name,
    required this.onTap,
    required this.value,
    required this.isEnabled, 
  });

  @override
  State<ScorecardPanel> createState() => _ScorecardPanelState();
}

class _ScorecardPanelState extends State<ScorecardPanel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.isEnabled && widget.value == null) ? widget.onTap : null, 
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.value == null
              ? (widget.isEnabled ? Colors.blueAccent : Colors.grey.shade400)
              : Colors.greenAccent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              widget.value == null ? 'Select' : '${widget.value}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}