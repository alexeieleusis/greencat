library todo_component;

import 'package:angular2/core.dart';

/// Displays a to-do and invokes the callback when clicked.
@Component(
    selector: 'todo',
    templateUrl: 'package:todo_list_angular/todo_component.html',
    styleUrls: const ['package:todo_list_angular/todo_component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class TodoComponent {
  /// The text to display in the component.
  @Input()
  String text;

  /// A flag used for styling.
  @Input()
  bool completed;
}
