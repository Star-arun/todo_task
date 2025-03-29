import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_task/model_class/create_todo_model.dart';

import 'todo_list_controller.dart';

class TodoListScreen extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My To-Do List"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.todoList.isEmpty) {
                  return Center(
                    child: Text('No tasks yet! Add some.',
                        style: TextStyle(fontSize: 18, color: Colors.white70)),
                  );
                }

                return ListView.builder(
                  itemCount: controller.todoList.length,
                  itemBuilder: (context, index) {
                    final todo = controller.todoList[index];
                    return TodoCard(todo: todo);
                  },
                );
              }),
            ),
            AddTodoWidget(),
          ],
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  const TodoCard({required this.todo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Toggle completion when card is tapped
        final controller = Get.find<TodoController>();
        controller.toggleCompletion(todo);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: todo.isCompleted ? Colors.green[300] : Colors.blue[300],
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            todo.task,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: Icon(
            todo.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class AddTodoWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.find();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter a new task",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.blueGrey[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.blueGrey[700],
            ),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                todoController.addTodo(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
