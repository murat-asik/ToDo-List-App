import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_list/model/todo.dart';
import 'package:flutter_app_todo_list/screens/todo_detail.dart';
import 'package:flutter_app_todo_list/utils/dbHelper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
        body: todoListItems(),
        appBar: AppBar(
          title: Text("Todos"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Todo("", 3, ""));
          },
          tooltip: 'Add New Todo',
          child: Icon(Icons.add),
        ));
  }

  ListView todoListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) => Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(this.todos[position].priority),
                child: Text(
                  this.todos[position].id.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(this.todos[position].title),
              subtitle: Text(this.todos[position].description),
              onTap: () {
                navigateToDetail(this.todos[position]);
              },
            )));
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));
    if (result == true) {
      getData();
    }
  }

  void getData() {
    final todosFuture = helper.getTodos();
    todosFuture.then((result) => {
          setState(() {
            todos = result;
            count = todos.length;
          })
        });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.green;
    }
  }
}
