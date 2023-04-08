import 'dart:convert';

class Note {
  int id;
  String title;
  String content;
  DateTime date_created;
  DateTime date_last_edited;

  Note(this.id, this.title, this.content, this.date_created,
      this.date_last_edited);

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      'title': utf8.encode(title),
      'content': utf8.encode(content),
      'date_created': date_created,
      'date_last_edited': date_last_edited,
    };
    if (forUpdate) {
      data["id"] = id;
    }
    return data;
  }
}
