import 'package:flutter/material.dart';

class PinnedMessageSection extends StatelessWidget {
  const PinnedMessageSection({
    super.key,
    required this.senderName,
    required this.url,
    required this.moreCount,
    required this.message,
    required this.time,
    this.onTap,
  });

  final String senderName;
  final String url;
  final int moreCount;
  final String message;
  final String time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.push_pin, color: Colors.red, size: 16),
              SizedBox(width: 8),
              Text(
                senderName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(url, style: TextStyle(color: Colors.blue, fontSize: 12)),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                '$moreCount more',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message, style: TextStyle(fontSize: 14)),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
