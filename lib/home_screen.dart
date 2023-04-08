import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localdb/models/db.dart';
import 'package:flutter_localdb/models/note.dart';
import 'package:flutter_localdb/note_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

enum ViewType { list, staggered }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ViewType current = ViewType.list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: _appBarAction(),
      ),
      body: SafeArea(
        child: StaggeredWidget(currentView: current),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  _newNote(BuildContext context) {
    Note newNote = Note(-1, "", "", DateTime.now(), DateTime.now());
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteScreen(note: newNote)));
  }

  _appBarAction() {
    return [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () => _changeView(),
            child: current == ViewType.list
                ? Icon(Icons.view_headline)
                : Icon(Icons.developer_board)),
      )
    ];
  }

  _changeView() {
    setState(() {
      if (current == ViewType.list) {
        current = ViewType.staggered;
      } else {
        current = ViewType.list;
      }
    });
  }
}

class StaggeredWidget extends StatefulWidget {
  ViewType currentView;
  StaggeredWidget({required this.currentView});

  @override
  State<StaggeredWidget> createState() => _StaggeredWidgetState();
}

class _StaggeredWidgetState extends State<StaggeredWidget> {
  var noteDB = NotesDBHandler();
  List<Map<String, dynamic>> _allNotes = [];

  @override
  void initState() {
    super.initState();
    retrieveAllNotesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    //get all data from database
    //add to _allNotes
    return StaggeredGrid.count(
      crossAxisCount: widget.currentView == ViewType.list ? 1 : 2,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: List.generate(_allNotes.length, (index) {
        var note = _allNotes[index];
        Note existNote = Note(note['id'], note['title'], note['content'],
            note['date_created'], note['date_last_update']);
        return GestureDetector(
            onTap: () => NoteScreen(note: existNote),
            child: Text(existNote.title));
      }),
    );
  }

  void retrieveAllNotesFromDatabase() async {
    try {
      List<Map<String, dynamic>> notes = await noteDB.selectAllNotes();
      setState(() {
        _allNotes = notes;
      });
    } catch (e) {
      print('Error retrieving notes from the database: $e');
    }
  }
}
