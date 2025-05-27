import 'package:flutter/material.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final List<Map<String, String>> _diaryEntries = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addOrEditEntry({Map<String, String>? existingEntry, int? index}) {
    if (existingEntry != null) {
      _titleController.text = existingEntry['title']!;
      _contentController.text = existingEntry['content']!;
    } else {
      _titleController.clear();
      _contentController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingEntry == null ? "New Entry" : "Edit Entry"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: "Content"),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final title = _titleController.text.trim();
              final content = _contentController.text.trim();
              if (title.isEmpty || content.isEmpty) return;

              setState(() {
                if (existingEntry == null) {
                  _diaryEntries.add({'title': title, 'content': content});
                } else {
                  _diaryEntries[index!] = {'title': title, 'content': content};
                }
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _deleteEntry(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this entry?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _diaryEntries.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Yes")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Diary"),
        backgroundColor: Colors.blue,
      ),
      body: _diaryEntries.isEmpty
          ? const Center(child: Text("No entries yet."))
          : ListView.builder(
          itemCount: _diaryEntries.length,
          itemBuilder: (context, index) {
            final entry = _diaryEntries[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(entry['title']!),
                subtitle: Text(
                  entry['content']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _addOrEditEntry(existingEntry: entry, index: index);
                    } else if (value == 'delete') {
                      _deleteEntry(index);
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text("Edit"),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text("Delete"),
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditEntry(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
