import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    this.onDocumentTap,
    this.onCameraTap,
    this.onImageTap,
    this.onSendTap,
    this.controller,
    this.hintText = 'Aa',
  });

  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onImageTap;
  final VoidCallback? onSendTap;
  final TextEditingController? controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.description, color: Colors.orange),
            onPressed: onDocumentTap,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.orange),
            onPressed: onCameraTap,
          ),
          IconButton(
            icon: Icon(Icons.image, color: Colors.orange),
            onPressed: onImageTap,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
