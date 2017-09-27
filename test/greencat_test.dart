import 'package:greencat/greencat.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:todo_list/todo_list.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Simple store', () {
    Store<TodoState, TodoAction<dynamic>> store;

    setUp(() {
      store = new Store.createStore(todoApp,
          initialState: const TodoState.initial());
    });

    tearDown(() {
      store.close();
    });

    test('adds a todo', () {
      expect(store.state.todos.length, 0);

      store.dispatch(addTodo('test this adds a todo'));

      expect(store.state.todos.length, 1);
    });

    test('toggles a todo', () {
      store
        ..dispatch(addTodo('test this adds a todo'))
        ..dispatch(addTodo('test this adds another todo'));

      expect(store.state.todos.elementAt(0).completed, isFalse);

      store.dispatch(toggleTodo(0));

      expect(store.state.todos.elementAt(0).completed, isTrue);
      expect(store.state.todos.elementAt(1).completed, isFalse);
    });

    test('sets visibility filter', () {
      expect(store.state.filter, VisibilityFilter.all);

      store.dispatch(setVisibilityFilter(VisibilityFilter.showCompleted));

      expect(store.state.filter, VisibilityFilter.showCompleted);
    });

    test('adds middleware', () async {
      store
        ..addMiddleware(const ThunkMiddleware())
        ..dispatch(asyncAddTodo('thunk!'));
      await store.stream.first;

      expect(store.state.todos.length, 1);
      expect(store.state.todos.last.description, 'thunk!');
    });

    test('logging middleware sends messages', () async {
      store.addMiddleware(new LoggingMiddleware(Logger.root));
      final logRecords = <LogRecord>[];
      Logger.root
        ..level = Level.FINE
        ..onRecord.listen(logRecords.add);

      store.add(addTodo('log'));

      expect(logRecords, hasLength(4));
      expect(logRecords.first.message, contains('action'));
    });
  });

  group('Combined store', () {
    Store<Tuple2<Iterable<Todo>, VisibilityFilter>, TodoAction> store;

    setUp(() {
      store = new Store.createStore(todoCombinedApp);
    });

    tearDown(() {
      store.close();
    });

    test('adds a todo', () {
      expect(store.state.item1.length, 0);

      store.dispatch(addTodo('test this adds a todo'));

      expect(store.state.item1.length, 1);
    });

    test('toggles a todo', () {
      store
        ..dispatch(addTodo('test this adds a todo'))
        ..dispatch(addTodo('test this adds another todo'));

      expect(store.state.item1.elementAt(0).completed, isFalse);

      store.dispatch(toggleTodo(0));

      expect(store.state.item1.elementAt(0).completed, isTrue);
      expect(store.state.item1.elementAt(1).completed, isFalse);
    });

    test('sets visibility filter', () {
      expect(store.state.item2, VisibilityFilter.all);

      store.dispatch(setVisibilityFilter(VisibilityFilter.showCompleted));

      expect(store.state.item2, VisibilityFilter.showCompleted);
    });

    test('adds middleware', () async {
      store
        ..addMiddleware(const ThunkMiddleware())
        ..dispatch(asyncAddTodo('thunk!'));
      await store.stream.first;

      expect(store.state.item1.length, 1);
      expect(store.state.item1.last.description, 'thunk!');
    });
  });
}
