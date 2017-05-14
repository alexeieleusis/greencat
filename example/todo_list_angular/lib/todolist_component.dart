library todolist_component;

import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:todo_list/todo_list.dart';
import 'package:todo_list_angular/todo_component.dart';

/// Displays a to-do and invokes the callback when clicked.
@Component(
    selector: 'todolist',
    templateUrl: 'package:todo_list_angular/todolist_component.html',
    directives: const [TodoComponent, NgFor],
    changeDetection: ChangeDetectionStrategy.OnPush)
class TodoListComponent implements OnDestroy {
  final StreamController<int> _controller =
      new StreamController<int>.broadcast();

  /// The todos to display.
  @Input()
  Iterable<Todo> todos;

  /// Propagates the toggle to-do event.
  @Output()
  Stream<int> get toggleTodo => _controller.stream;

  @override
  void ngOnDestroy() {
    _controller.close();
  }

  /// Propagates the click event.
  void toggleTodoHandler(int index) {
    _controller.add(index);
  }
}
