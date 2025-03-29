import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_task/model_class/task_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_task/model_class/task_model.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._instance();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   DatabaseHelper._instance();

//   String tasksCollection = 'tasks'; // Firestore collection name

//   // Fetch all tasks
//   Future<List<Task>> getTaskList() async {
//     try {
//       final querySnapshot = await _db.collection(tasksCollection).get();
//       final taskList = querySnapshot.docs.map((doc) {
//         return Task.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         );
//       }).toList();

//       taskList.sort((taskA, taskB) => taskA.date!.compareTo(taskB.date!));
//       return taskList;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Insert a task
//   Future<void> insertTask(Task task) async {
//     try {
//       await _db.collection(tasksCollection).add(task.toMap());
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Update a task
//   Future<void> updateTask(Task task) async {
//     try {
//       await _db.collection(tasksCollection).doc(task.id).update(task.toMap());
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Delete a task
//   Future<void> deleteTask(String id) async {
//     try {
//       await _db.collection(tasksCollection).doc(id).delete();
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Delete all tasks (Not a common operation in Firestore, but possible)
//   Future<void> deleteAllTasks() async {
//     try {
//       final snapshot = await _db.collection(tasksCollection).get();
//       final batch = _db.batch();
//       for (var doc in snapshot.docs) {
//         batch.delete(doc.reference);
//       }
//       await batch.commit();
//     } catch (e) {
//       rethrow;
//     }
//   }
// }



//============================


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseHelper._instance();

  String tasksCollection = 'tasks'; // Firestore collection name

  // Fetch tasks for the currently logged-in user
  Future<List<Task>> getTaskList() async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      final querySnapshot = await _db
          .collection(tasksCollection)
          .where('userId', isEqualTo: userId) // Filter tasks by userId
          .get();

      final taskList = querySnapshot.docs.map((doc) {
        return Task.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();

      taskList.sort((taskA, taskB) => taskA.date!.compareTo(taskB.date!));
      return taskList;
    } catch (e) {
      rethrow;
    }
  }

  // Insert a task
  Future<void> insertTask(Task task) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      await _db.collection(tasksCollection).add({
        ...task.toMap(),
        'userId': userId, // Add userId to the task
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    try {
      await _db.collection(tasksCollection).doc(task.id).update(task.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _db.collection(tasksCollection).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
