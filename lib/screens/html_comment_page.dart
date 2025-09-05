import 'package:flutter/material.dart';
import '../flutter_content.dart';
import '../services/api_service.dart';
import '../widgets/comment_dialog.dart';

class HtmlCommentPage extends StatefulWidget {
  const HtmlCommentPage({super.key});

  @override
  _HtmlCommentPageState createState() => _HtmlCommentPageState();
}

class _HtmlCommentPageState extends State<HtmlCommentPage> {
  Map<String, String> comments = {};
  TextSelection? currentSelection;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final data = await ApiService.fetchComments();
      setState(() {
        comments = data;
      });
    } catch (e) {
      print(e);
    }
  }

  void _handleAddComment() {
    if (currentSelection != null &&
        currentSelection!.textInside(FlutterContent.htmlContent).trim().isNotEmpty) {
      String selectedText = currentSelection!.textInside(FlutterContent.htmlContent).trim();
      String? existingComment = comments[selectedText];
      showCommentDialog(
        context,
        selectedText,
        existingComment: existingComment,
        onSaved: _loadComments,
      );
      currentSelection = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select some text first.')),
      );
    }
  }

  List<TextSpan> _buildHighlightedTextSpans(String content, Map<String, String> comments) {
    List<TextSpan> spans = [];
    int start = 0;

    while (start < content.length) {
      bool matched = false;

      for (final entry in comments.entries) {
        final commentText = entry.key;
        final index = content.indexOf(commentText, start);

        if (index == start) {
          spans.add(TextSpan(
            text: commentText,
            style: TextStyle(
             // background: Paint()..color = Colors.yellowAccent,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ));
          start += commentText.length;
          matched = true;
          break;
        }
      }
      if (!matched) {
        spans.add(TextSpan(
          text: content[start],
          style: const TextStyle(color: Colors.black),
        ));
        start++;
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Development')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectionArea(
                  child: SelectableText.rich(
                    TextSpan(
                      children: _buildHighlightedTextSpans(
                        FlutterContent.htmlContent,
                        comments,
                      ),
                      style: const TextStyle(fontSize: 18, height: 1.5),
                    ),
                    showCursor: true,
                    cursorColor: Colors.blue,
                    cursorWidth: 2,
                    onSelectionChanged: (selection, cause) {
                      setState(() {
                        currentSelection = selection;
                      });
                    },
                  ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddComment,
        tooltip: 'Add Comment for Selected Text',
        child: const Icon(Icons.comment),
      ),
    );
  }
}
