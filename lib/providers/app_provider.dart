import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

class AppProvider extends InheritedWidget {
  final Student student;
  final List<Note> notes;
  final bool isLoading;
  final Function(Student) updateStudent;
  final Future<void> Function(Note) addNote;
  final Future<void> Function(String) deleteNote;

  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  static AppProvider of(BuildContext context) {
    final AppProvider? result =
        context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(result != null, 'AppProvider tidak ditemukan di dalam context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student ||
        notes != oldWidget.notes ||
        isLoading != oldWidget.isLoading;
  }
}

class AppProviderWrapper extends StatefulWidget {
  final Widget child;

  /// Konstruktor [AppProviderWrapper].
  const AppProviderWrapper({super.key, required this.child});

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _repository = NoteRepository();

  Student _student = const Student(
    name: 'Aziefa Maharani Gitaatmaja',
    nim: '25.11.6579',
    programStudi: 'S1 Informatika',
    email: 'a.maharani@students.amikom.ac.id',
  );

  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialNotes();
  }

  Future<void> _loadInitialNotes() async {
    final loadedNotes = await _repository.getAllNotes();
    if (mounted) {
      setState(() {
        _notes = loadedNotes;
        _isLoading = false;
      });
    }
  }

  void _updateStudent(Student updatedStudent) {
    setState(() {
      _student = updatedStudent;
    });
  }

  Future<void> _addNote(Note note) async {
    await _repository.saveNote(note);
    final updatedNotes = await _repository.getAllNotes();
    if (mounted) {
      setState(() {
        _notes = updatedNotes;
      });
    }
  }

  Future<void> _deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
    final updatedNotes = await _repository.getAllNotes();
    if (mounted) {
      setState(() {
        _notes = updatedNotes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoading: _isLoading,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}