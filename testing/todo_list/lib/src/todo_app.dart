library todo_app;

import 'package:greencat/greencat.dart';
import 'package:tuple/tuple.dart';

import 'action_type.dart';
import 'todo.dart';
import 'todo_action.dart';
import 'todo_state.dart';

/// The reducer for the TodoApp.
TodoState todoApp(TodoAction<dynamic> action, {TodoState currentState}) {
  if (currentState == null) {
    return const TodoState.initial();
  }

  switch (action.type) {
    case ActionType.setVisibilityFilter:
      return currentState.copy(filter: action.payload);
    case ActionType.addTodo:
    case ActionType.toggleTodo:
      return currentState.copy(
          todos: _todos(action, currentState: currentState.todos));
    default:
      return currentState;
  }
}

/// Reducer built with the combine method in ReducerBase class.
ReducerBase<Tuple2<Iterable<Todo>, VisibilityFilter>, TodoAction>
    todoCombinedApp =
    new TodosReducer().combineWith(new VisibilityFilterReducer());

Iterable<Todo> _todos(TodoAction<dynamic> action,
    {Iterable<Todo> currentState}) {
  switch (action.type) {
    case ActionType.addTodo:
      return (new List<Todo>.from(currentState)
        ..add(new Todo(action.payload)))
          .toList(growable: false);
    case ActionType.toggleTodo:
      final originalTodo = currentState.elementAt(action.payload);
      final todo = originalTodo.copy(completed: !originalTodo.completed);
      Todo replaceTodo(Todo t) => t == originalTodo ? todo : t;
      return currentState.map(replaceTodo).toList(growable: false);
    default:
      return currentState;
  }
}

/// Reducer for Iterable<To do> state.
class TodosReducer extends ReducerBase<Iterable<Todo>, TodoAction> {
  @override
  Iterable<Todo> call(TodoAction action, {Iterable<Todo> currentState}) {
    if (currentState == null) {
      return const <Todo>[];
    }

    switch (action.type) {
      case ActionType.addTodo:
        return (new List<Todo>.from(currentState)
          ..add(new Todo(action.payload)))
            .toList(growable: false);
      case ActionType.toggleTodo:
        final originalTodo = currentState.elementAt(action.payload);
        final todo = originalTodo.copy(completed: !originalTodo.completed);
        Todo _replaceTodo(t) => t == originalTodo ? todo : t;
        return currentState.map(_replaceTodo).toList(growable: false);
      default:
        return currentState;
    }
  }
}

/// Reducer for VisibilityFilter state.
class VisibilityFilterReducer
    extends ReducerBase<VisibilityFilter, VisibilityFilterTodoAction> {
  @override
  VisibilityFilter call(TodoAction action, {VisibilityFilter currentState}) {
    if (currentState == null) {
      return VisibilityFilter.all;
    }
    switch (action.type) {
      case ActionType.setVisibilityFilter:
        return action.payload;
      default:
        return currentState;
    }
  }
}
