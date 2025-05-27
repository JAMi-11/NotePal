import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Note {
  String title;
  String content;
  String date;
  Note({required this.title, required this.content, required this.date});
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final List<Note> _notes = [];

  void _addOrEdit({Note? current, int? idx}) {
    final t = TextEditingController(text: current?.title);
    final c = TextEditingController(text: current?.content);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: t, decoration: const InputDecoration(labelText: "Title")),
            const SizedBox(height: 12),
            TextField(
                controller: c,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Note")),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  final d = DateFormat('dd MMM yyyy').format(DateTime.now());
                  final n = Note(title: t.text, content: c.text, date: d);
                  setState(() {
                    if (current != null && idx != null) {
                      _notes[idx] = n;
                    } else {
                      _notes.insert(0, n);
                    }
                  });
                  Navigator.pop(context);
                },
                child: Text(current == null ? "Save" : "Update"))
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MyDiary")),
      body: _notes.isEmpty
          ? const Center(child: Text("No notes added yet"))
          : ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (_, i) => Card(
            child: ListTile(
              title: Text(_notes[i].title),
              subtitle: Text(_notes[i].date),
              onTap: () => _addOrEdit(current: _notes[i], idx: i),
              trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => _notes.removeAt(i));
                  }),
            ),
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _addOrEdit(), child: const Icon(Icons.add)),
    );
  }
}
