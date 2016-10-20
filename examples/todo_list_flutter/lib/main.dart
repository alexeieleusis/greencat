import 'package:flutter/material.dart';
import 'package:greencat/greencat.dart';
import 'package:todo_list/todo_list.dart';

void main() {
  runApp(new MaterialApp(
      title: 'Flutter Redux Demo',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new TodoListHome()));
}

/// Entry point for the app.
class TodoListHome extends StatefulWidget {
  /// Constructor required by base class api.
  TodoListHome({Key key}) : super(key: key);

  @override
  _TodoListState createState() => new _TodoListState();
}

class _TodoListState extends State<TodoListHome> {
  /// Store providing the stream of state changes for the app.
  final Store<TodoState, TodoAction<dynamic>> store =
      new Store.createStore(todoApp, initialState: const TodoState.initial());

  final TextStyle linethrough =
      new TextStyle(decoration: TextDecoration.lineThrough);

  void _addTodo() {
    store.dispatch(addTodo('description'));
  }

  @override
  Widget build(BuildContext context) {
    final todosTexts = store.state.todos
        .map(/*<Widget>*/(t) => new GestureDetector(
            child: new Text(t.description,
                style: t.completed ? linethrough : null),
            onTap: () {
              store.dispatch(toggleTodo(store.state.todos.toList().indexOf(t)));
            }))
        .toList();
    return new Scaffold(
        appBar: new AppBar(title: new Text('Redux Todo List')),
        body: new Flex(
            children: todosTexts,
            direction: FlexDirection.vertical,
            crossAxisAlignment: CrossAxisAlignment.start),
        floatingActionButton: new FloatingActionButton(
            onPressed: _addTodo,
            tooltip: 'Add a todo',
            child: new Icon(Icons.add)));
  }

  @override
  void initState() {
    super.initState();
    store.stream.listen((TodoState state) {
      setState(() {});
    });
    store.dispatch(addTodo('test this adds a todo'));
    store.dispatch(addTodo('test this adds another todo'));
    store.dispatch(toggleTodo(0));
  }

  @override
  void dispose() {
    super.dispose();
    store.close();
  }
}
