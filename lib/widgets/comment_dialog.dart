import 'package:flutter/material.dart';
import '../services/api_service.dart';

void showCommentDialog(BuildContext context, String selectedText,
    {String? existingComment, Function? onSaved}) {
  TextEditingController commentController =
  TextEditingController(text: existingComment ?? "");

  bool hasComment = existingComment != null && existingComment.isNotEmpty;

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Comment for: "$selectedText"',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: hasComment ? '' : 'Enter your comment',
              ),
              readOnly: hasComment,
            ),
            const SizedBox(height: 10),
            if (!hasComment)
              ElevatedButton(
                child: const Text('Save Comment'),
                onPressed: () async {
                  String comment = commentController.text.trim();
                  if (comment.isNotEmpty) {
                    await ApiService.addComment(selectedText, comment);
                    Navigator.pop(context);
                    if (onSaved != null) onSaved();
                  }
                },
              ),
          ],
        ),
      );
    },
  );
}
