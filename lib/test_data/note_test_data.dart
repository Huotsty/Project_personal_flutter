import '../models/note.dart';

List<Note> generateTestNotes() {
  return [
    Note(
      id: '1',
      title: 'Grocery List',
      content: 'Buy milk, eggs, and bread.',
      timeCreated: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Note(
      id: '2',
      title: 'Meeting Notes',
      content: 'Discuss project milestones and deadlines.',
      timeCreated: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Note(
      id: '3',
      title: 'Workout Plan',
      content: 'Monday: Chest\nTuesday: Back\nWednesday: Legs',
      timeCreated: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Note(
      id: '4',
      title: 'Books to Read',
      content: '1. 1984 by George Orwell\n2. Brave New World by Aldous Huxley',
      timeCreated: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Note(
      id: '5',
      title: 'Vacation Ideas',
      content: '1. Beach in Bali\n2. Road trip across Europe',
      timeCreated: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}
