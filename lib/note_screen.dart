import 'package:flutter/material.dart';
import 'package:flutter_localdb/models/note.dart';

class NoteScreen extends StatefulWidget {
  Note note;
  NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _popScreen(),
      child: Scaffold(
        appBar: AppBar(),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          EditableText(
              controller: _titleController,
              focusNode: _titleFocus,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              cursorColor: Colors.blue,
              backgroundCursorColor: Colors.blue),
          const Divider(
            color: Colors.black,
          ),
          EditableText(
              controller: _contentController,
              focusNode: _contentFocus,
              style: const TextStyle(fontSize: 20),
              cursorColor: Colors.blue,
              backgroundCursorColor: Colors.blue)
        ],
      ),
    );
  }

  _popScreen() {
    Note updateNote = widget.note;
    updateNote.title = _titleController.text;
    updateNote.content = _contentController.text;
  }
}
