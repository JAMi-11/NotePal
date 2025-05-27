import 'package:flutter/material.dart';
import 'editor_page.dart';


class DiaryEntry {
  String title;
  String content;
  DateTime created;

  DiaryEntry({
    required this.title,
    required this.content,
    DateTime? created,
  }) : created = created ?? DateTime.now();
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() {
    return _DiaryPageState();
  }
}

class _DiaryPageState extends State<DiaryPage> {
  final List<DiaryEntry> _entries = [];


  Future<void> _openEditor({DiaryEntry? entry, int? index}) async {
    final DiaryEntry? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return EditorPage(entry: entry);
        },
      ),
    );

    if (result != null) {
      setState(() {
        if (index == null) {
          _entries.insert(0, result);
        } else {
          _entries[index] = result;
        }
      });
    }
  }


  void delete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete entry?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _entries.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MyDiary',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _entries.isEmpty
          ? const Center(
        child: Text('No entries yet'),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _entries.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            title: Text(_entries[i].title),
            subtitle: Text(formatDate(_entries[i].created)),
            onTap: () {
              _openEditor(entry: _entries[i], index: i);
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                delete(i);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openEditor();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
