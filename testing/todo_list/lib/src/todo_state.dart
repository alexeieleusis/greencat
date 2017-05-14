library todo_state;

import 'package:tuple/tuple.dart';

import 'action_type.dart';
import 'todo.dart';

/// State for the todoApp.
class TodoState {
  /// Controls which todos are visible.
  final VisibilityFilter filter;

  /// Todos available in the app.
  final Iterable<Todo> todos;

  /// Todos visible in the ui.
  final Iterable<Todo> visibleTodos;

  /// Creates a new instance.
  TodoState(this.filter, this.todos)
      : visibleTodos = todos.where((t) {
          switch (filter) {
            case VisibilityFilter.all:
              return true;
            case VisibilityFilter.showPending:
              return !t.completed;
            case VisibilityFilter.showCompleted:
              return t.completed;
          }
        }).toList(growable: false);

  /// Default state for the app, used when is not explicitly initialized.
  const TodoState.initial()
      : this.filter = VisibilityFilter.all,
        this.todos = const <Todo>[],
        this.visibleTodos = const <Todo>[];

  /// Clones this instance changing the specified filters.
  TodoState copy({VisibilityFilter filter, Iterable<Todo> todos}) =>
      new TodoState(filter ?? this.filter, todos ?? this.todos);

  @override
  String toString() =>
      'TodoState{filter: $filter, todos: $todos, visibleTodos: $visibleTodos}';

  /// Converts the state to a tuple.
  Tuple2<Iterable<Todo>, VisibilityFilter> toTuple() =>
      new Tuple2(todos, filter);
}
