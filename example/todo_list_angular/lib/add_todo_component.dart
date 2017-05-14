library add_todo_component;

import 'dart:async';

import 'package:angular2/core.dart';

/// Provides a way to add a to-do.
@Component(
    selector: 'add-todo',
    templateUrl: 'package:todo_list_angular/add_todo_component.html',
    changeDetection: ChangeDetectionStrategy.OnPush)
class AddTodoComponent implements OnDestroy {
  final StreamController<String> _controller =
      new StreamController<String>.broadcast();

  final ChangeDetectorRef _changeDetectorRef;

  /// The text to display in the component.
  String description;

  /// Creates a new instance of the component.
  AddTodoComponent(ChangeDetectorRef changeDetectorRef)
      : _changeDetectorRef = changeDetectorRef;

  /// Propagates the click event to the container component.
  @Output()
  Stream<String> get addTodo => _controller.stream;

  @override
  void ngOnDestroy() {
    _controller.close();
  }

  /// Triggered when the li element is clicked.
  void onClick() {
    _controller.add(description);
    description = '';
    _changeDetectorRef.detectChanges();
  }
}
