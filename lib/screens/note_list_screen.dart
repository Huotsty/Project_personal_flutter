import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/note.dart';
import 'note_edit_screen.dart';

String formatDate(DateTime date) {
  return DateFormat.yMMMd().format(date); // Example: Dec 16, 2024
}

enum FormMode { add, edit }

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];

  void _addOrEditNote(Note? note, FormMode formMode) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormScreen(
          formMode: formMode,
          note: note,
        ),
      ),
    );

    if (result != null && result is Note) {
      setState(() {
        if (formMode == FormMode.add) {
          notes.add(result);
        } else {
          final index = notes.indexWhere((n) => n.id == result.id);
          if (index != -1) {
            notes[index] = result;
          }
        }
      });
    }
  }

  void _deleteNoteConfirm(Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                notes.remove(note);
              });
              Navigator.of(ctx).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "No Notes Added!",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    "${note.content}\nCreated: ${formatDate(note.timeCreated)}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _addOrEditNote(note, FormMode.edit);
                      } else if (value == 'delete') {
                        _deleteNoteConfirm(note);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onLongPress: () => _deleteNoteConfirm(note),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(null, FormMode.add),
        child: const Icon(Icons.add),
      ),
    );
  }
}
