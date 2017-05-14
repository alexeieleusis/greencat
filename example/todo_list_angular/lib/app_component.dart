import 'package:angular2/core.dart';
import 'package:greencat/greencat.dart';
import 'package:logging/logging.dart';
import 'package:todo_list/todo_list.dart';
import 'package:todo_list_angular/add_todo_component.dart';
import 'package:todo_list_angular/footer_component.dart';
import 'package:todo_list_angular/todolist_component.dart';
import 'package:tuple/tuple.dart';

/// Root component for the web app.
@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [AddTodoComponent, FooterComponent, TodoListComponent],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent implements OnInit, OnDestroy {
  /// Store built with the combine ...
  final Store<Tuple2<Iterable<Todo>, VisibilityFilter>, TodoAction>
      combinedStore = new Store.createStore(todoCombinedApp);

  /// Visibility filters to show to the user.
  Iterable<VisibilityFilter> get filters => VisibilityFilter.values;

  /// Elements displayed in the list.
  Iterable<Todo> get visibleTodos => combinedStore.state.item1.where((t) =>
      combinedStore.state.item2 == VisibilityFilter.all ||
      t.completed &&
          combinedStore.state.item2 == VisibilityFilter.showCompleted ||
      !t.completed &&
          combinedStore.state.item2 == VisibilityFilter.showPending);

  /// Dispatch the add to-do to the store.
  void addTodoHandler(String description) {
    combinedStore.dispatch(asyncAddTodo(description));
  }

  @override
  void ngOnDestroy() {
    combinedStore.close();
  }

  @override
  void ngOnInit() {
    combinedStore
      ..dispatch(addTodo('test this adds a todo'))..dispatch(
        addTodo('test this adds another todo'))..dispatch(toggleTodo(0))
      ..addMiddleware(const ThunkMiddleware<
          Tuple2<Iterable<Todo>, VisibilityFilter>,
          TodoAction>());
    Logger.root
      ..level = Level.FINE
      ..onRecord.listen((rec) {
        print('${rec.loggerName} ${rec.time}');
        print('${rec.message}');
      });

    combinedStore.addMiddleware(new LoggingMiddleware(Logger.root));
  }

  /// Handles changes to the visibility.
  void setVisibilityFilterHandler(VisibilityFilter filter) {
    combinedStore.dispatch(setVisibilityFilter(filter));
  }

  /// Dispatch the toggle to-do to the store.
  void toggleTodoHandler(int index) {
    combinedStore.dispatch(toggleTodo(index));
  }
}
