import 'package:flutter/material.dart';
import 'diary_page.dart';

class EditorPage extends StatefulWidget {
  final DiaryEntry? entry;

  const EditorPage({super.key, this.entry});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {

  late final TextEditingController titleController = TextEditingController(
    text: widget.entry?.title ?? '',
  );

  late final TextEditingController bodyController = TextEditingController(
    text: widget.entry?.content ?? '',
  );

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();

  }

  void saveEntry() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    final DiaryEntry newEntry = DiaryEntry(
      title: titleController.text.trim(),
      content: bodyController.text.trim(),
      created: widget.entry?.created,
    );

    Navigator.pop(context, newEntry);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.entry != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Entry' : 'New Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveEntry,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: bodyController,
                decoration: const InputDecoration(
                  hintText: 'Start writing your thoughts...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
