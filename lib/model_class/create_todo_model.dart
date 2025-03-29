class Todo {
  String id;
  String task;
  bool isCompleted;

  Todo({
    required this.id,
    required this.task,
    required this.isCompleted,
  });

  // Convert a Todo object to a Map to store it in Firestore
  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'isCompleted': isCompleted,
    };
  }

  // Convert a Map to a Todo object
  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      task: map['task'],
      isCompleted: map['isCompleted'],
    );
  }
}
