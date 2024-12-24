import 'package:flutter/material.dart';

import '/models/note.dart';
import 'note_list_screen.dart';

class NoteFormScreen extends StatefulWidget {
  final FormMode formMode;
  final Note? note;

  const NoteFormScreen({
    super.key,
    required this.formMode,
    this.note,
  });

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';
    _selectedDate = widget.note?.timeCreated ?? DateTime.now();
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newNote = Note(
        id: widget.note?.id ?? DateTime.now().toIso8601String(),
        title: _title,
        content: _content,
        timeCreated: _selectedDate,
      );

      Navigator.of(context).pop(newNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formMode == FormMode.add ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date Created: ${_selectedDate.toLocal()}'.split(' ')[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
