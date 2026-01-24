import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final bool hasTask;
  final bool canCreate;
  final VoidCallback onCreate;
  final VoidCallback onComplete;

  const ActionButton({super.key, required this.hasTask, required this.canCreate, required this.onCreate, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 48,
      child: ElevatedButton(
        onPressed: hasTask
            ? onComplete
            : (canCreate ? onCreate : null),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4B400),
          disabledBackgroundColor: const Color(0x66F4B400),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          hasTask ? 'C’est fait' : 'Créer',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
