class Note {
  final String id;
  final String tittle;
  final String content;
  final DateTime createdAt;

  const Note({
  required this.id,
  required this.tittle,
  required this.content,
  required this.createdAt,
});

Map<String, dynamic> toMetadataJson() {
  return {
    'id': id,
    'tittle': tittle,
    'createdAt': createdAt.toIso8601String(),
  };
}

factory Note.fromMetadataJson(Map<String, dynamic> json, String content) {
  return Note(
    id: json ['id'] as String,
    tittle: json ['tittle'] as String,
    content: content,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
}
