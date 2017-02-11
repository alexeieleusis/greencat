library todo_app;

import 'package:greencat/greencat.dart';
import 'action_type.dart';
import 'todo.dart';
import 'todo_action.dart';
import 'todo_state.dart';
import 'package:tuple/tuple.dart';

/// The reducer for the TodoApp.
Reducer<TodoState, TodoAction> todoApp =
    (TodoAction<dynamic> action, {TodoState currentState}) {
  if (currentState == null) {
    return new TodoState.initial();
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
};

/// Reducer built with the combine method in ReducerBase class.
ReducerBase<Tuple2<Iterable<Todo>, VisibilityFilter>, TodoAction>
    todoCombinedApp =
    new TodosReducer().combineWith(new VisibilityFilterReducer());

Reducer<Iterable<Todo>, TodoAction<dynamic>> _todos =
    (TodoAction<dynamic> action, {Iterable<Todo> currentState}) {
  switch (action.type) {
    case ActionType.addTodo:
      return currentState = (new List<Todo>.from(currentState)
            ..add(new Todo(action.payload, false)))
          .toList(growable: false);
    case ActionType.toggleTodo:
      final originalTodo = currentState.elementAt(action.payload);
      final todo = originalTodo.copy(completed: !originalTodo.completed);
      final replaceTodo = (Todo t) => t == originalTodo ? todo : t;
      return currentState =
          currentState.map(replaceTodo).toList(growable: false);
    default:
      return currentState;
  }
};

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
              ..add(new Todo(action.payload, false)))
            .toList(growable: false);
      case ActionType.toggleTodo:
        final originalTodo = currentState.elementAt(action.payload);
        final todo = originalTodo.copy(completed: !originalTodo.completed);
        final replaceTodo = (Todo t) => t == originalTodo ? todo : t;
        return currentState.map(replaceTodo).toList(growable: false);
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
