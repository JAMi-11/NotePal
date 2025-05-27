import 'package:flutter/material.dart';
import 'diary_page.dart';

class EditorPage extends StatefulWidget {
  final DiaryEntry? entry; // null ⇒ new
  const EditorPage({super.key, this.entry});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final _titleCtrl = TextEditingController(text: widget.entry?.title);
  late final _bodyCtrl  = TextEditingController(text: widget.entry?.content);

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      return;
    }
    final newEntry = DiaryEntry(
      title: _titleCtrl.text.trim(),
      content: _bodyCtrl.text.trim(),
      created: widget.entry?.created, // keep original date if editing
    );
    Navigator.pop(context, newEntry);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Entry' : 'New Entry'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _bodyCtrl,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
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
