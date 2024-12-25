import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/note.dart';
import '/screens/note_edit_screen.dart';
import '../test_data/note_test_data.dart';

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
  List<Note> notes = generateTestNotes();
  bool _isSortedByNewest = true; // Controls sorting order

  void _toggleSortOrder() {
    setState(() {
      _isSortedByNewest = !_isSortedByNewest;
      notes.sort((a, b) => _isSortedByNewest
          ? b.timeCreated.compareTo(a.timeCreated)
          : a.timeCreated.compareTo(b.timeCreated));
    });
  }

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
        // Reapply the sorting after any addition or update
        notes.sort((a, b) => _isSortedByNewest
            ? b.timeCreated.compareTo(a.timeCreated)
            : a.timeCreated.compareTo(b.timeCreated));
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
        title: Text('Notes (${notes.length})'),
        actions: [
          IconButton(
            onPressed: _toggleSortOrder,
            icon: Icon(
              _isSortedByNewest ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            tooltip: 'Sort by Date',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: notes.isEmpty
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
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Date: ${formatDate(note.timeCreated)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
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
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditNote(null, FormMode.add),
        label: const Text("Add Note"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
