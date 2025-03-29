import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_task/helper/helpers.dart';
import 'package:todo_task/model_class/task_model.dart';
import 'package:todo_task/screens/add_task_screen.dart';
import 'package:todo_task/screens/auth_screen.dart';
import 'history_screen.dart';
import 'package:intl/intl.dart';
// import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Task>>? _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Future<bool> onBackPressed() async {
    SystemNavigator.pop(); // Close the app or perform back action
    return Future.value(
        true); // Return a Future<bool> (true means proceed with back action)
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          if (task.status == 0)
            ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 18.0,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                '${_dateFormatter.format(task.date ?? DateTime.now())} • ${task.priority}',
                style: TextStyle(
                  fontSize: 15.0,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              trailing: Checkbox(
                onChanged: (value) {
                  task.status = value! ? 1 : 0;
                  DatabaseHelper.instance.updateTask(task);
                  Fluttertoast.showToast(
                    msg: "Task Completed",
                    gravity: ToastGravity.BOTTOM, // Position of the toast
                    timeInSecForIosWeb: 2,
                  );
                  // Toast.show("Task Completed",
                  //     duration: 2, gravity: Toast.bottom);
                  _updateTaskList();
                },
                activeColor: Theme.of(context).primaryColor,
                value: task.status == 1 ? true : false,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                    updateTaskList: _updateTaskList,
                    task: task,
                  ),
                ),
              ),
            ),
          //Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          child: const Icon(Icons.add_outlined),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(
                updateTaskList: _updateTaskList,
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          leading: const IconButton(
              icon: Icon(
                Icons.calendar_today_outlined,
                
                  color: Colors.black,
              ),
              onPressed: null),
          title: const Row(
            children: [
              Text(
                "Task",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -1.2,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Manager",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0,
                ),
              )
            ],
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.all(0),
              child: IconButton(
                  icon: const Icon(Icons.history_outlined),
                  iconSize: 25.0,
                  color: Colors.black,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => HistoryScreen()))),
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              child: IconButton(
                  icon: const Icon(Icons.logout),
                  iconSize: 25.0,
                  color: Colors.black,
                  onPressed: () async{
                     final FirebaseAuth auth = FirebaseAuth.instance;
                     await auth.signOut();
                     Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (Route<dynamic> route) => false,  // This removes all previous routes
      );
                       Fluttertoast.showToast(
                    msg: "Logout Success",
                    gravity: ToastGravity.BOTTOM, // Position of the toast
                    timeInSecForIosWeb: 2,
                  );
                    
                  } ),
            )
          ],
        ),
        body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedTaskCount = snapshot.data!
                .where((Task task) => task.status == 0)
                .toList()
                .length;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              itemCount: 1 + snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromRGBO(240, 240, 240, 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Center(
                            child: Text(
                              'You have [ $completedTaskCount ] pending task out of [ ${snapshot.data!.length} ]',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return _buildTask(snapshot.data![index - 1]);
              },
            );
          },
        ),
      ),
    );
  }
}
