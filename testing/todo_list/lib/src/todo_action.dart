library todo_action;

import 'dart:async';
import 'package:greencat/greencat.dart';
import 'package:todo_list/todo_list.dart';

/// Utility function to trigger the addTodo action.
TodoAction<String> addTodo(String description) =>
    new AddTodoAction(description);

/// Utility function to asynchronously trigger the addTodo action.
TodoAction<String> asyncAddTodo(String description) =>
    new AsyncAddTodoAction(description);

/// Utility function to trigger the setVisibilityFilter action.
TodoAction<VisibilityFilter> setVisibilityFilter(VisibilityFilter filter) =>
    new VisibilityFilterTodoAction(filter);

/// Utility function to trigger the toggleTodo action.
TodoAction<int> toggleTodo(int index) => new ToggleTodoAction(index);

/// Action to add a to do.
class AddTodoAction extends TodoAction<String> {
  ///
  AddTodoAction(String payload) : super(payload);

  @override
  ActionType get type => ActionType.addTodo;
}

/// Asynchronously adds a todo to the store.
class AsyncAddTodoAction extends TodoAction<String> implements AsyncAction {
  ///
  AsyncAddTodoAction(String payload) : super(payload);

  @override
  ActionType get type => ActionType.asyncAddTodo;

  /// Adds a task asynchronously.
  @override
  Future call(MiddlewareApi api) {
    return new Future.value('').then((_) {
      api.dispatch(addTodo(payload));
    });
  }
}

/// Actions to be triggered to the app store.
abstract class TodoAction<T> extends Action<ActionType> {
  /// The payload to include.
  @override
  final T payload;

  /// Creates a new instance.
  TodoAction(this.payload);
}

/// Action to toggle a to do.
class ToggleTodoAction extends TodoAction<int> {
  ///
  ToggleTodoAction(int payload) : super(payload);

  @override
  ActionType get type => ActionType.toggleTodo;
}

/// Action to set the visibility filter.
class VisibilityFilterTodoAction extends TodoAction<VisibilityFilter> {
  ///
  VisibilityFilterTodoAction(VisibilityFilter payload) : super(payload);

  @override
  ActionType get type => ActionType.setVisibilityFilter;
}
