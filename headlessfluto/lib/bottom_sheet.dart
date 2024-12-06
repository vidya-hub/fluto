import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showLogDetailsDialog({
  required BuildContext context,
  required Map<String, dynamic> flutoLog,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(flutoLog["log_type"])),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text:flutoLog.toString()));
              },
              icon: const Icon(Icons.copy),
            )
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Message:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(flutoLog["log_name"]),
              if (flutoLog["log_type"] == "error") ...[
                const SizedBox(height: 10),
                const Text(
                  "Stack Trace:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(flutoLog["stacktrace"] ?? ""),
                const SizedBox(height: 10),
              ],
              const Text(
                "Timestamp:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(flutoLog["created_at"]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
