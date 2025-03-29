import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_task/model_class/create_todo_model.dart';

class TodoController extends GetxController {
  var todoList = <Todo>[].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch all todos from Firebase
  Future<void> fetchTodos() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('todos').get();
      todoList.value = snapshot.docs
          .map(
              (doc) => Todo.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint("Error fetching todos: $e");
    }
  }

  // Add a new todo
  Future<void> addTodo(String task) async {
    try {
      var newTodo = Todo(
        id: '',
        task: task,
        isCompleted: false,
      );
      var docRef = await firestore.collection('todos').add(newTodo.toMap());
      newTodo.id = docRef.id;
      todoList.add(newTodo);
    } catch (e) {
      debugPrint("Error adding todo: $e");
    }
  }

  // Toggle the completion status of a todo
  Future<void> toggleCompletion(Todo todo) async {
    try {
      todo.isCompleted = !todo.isCompleted;
      await firestore.collection('todos').doc(todo.id).update(todo.toMap());
      fetchTodos();
    } catch (e) {
      debugPrint("Error updating todo: $e");
    }
  }
}
