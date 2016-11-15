// Copyright (c) 2016, Alexei Eleusis Díaz Vera. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;

import 'package:butterfly/butterfly.dart';
import 'package:greencat/greencat.dart';
import 'package:logging/logging.dart';
import 'package:todo_list/todo_list.dart';
import 'package:tuple/tuple.dart';

void main() {
  runApp(new TodoApp(), html.document.querySelector('#output'));
}

/// App to manage todos.
class TodoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TodoAppState();
  }
}

class _TodoAppState extends State<TodoApp> {
  /// Store built with the combine ...
  final Store<Tuple2<Iterable<Todo>, VisibilityFilter>, TodoAction>
  combinedStore = new Store.createStore(todoCombinedApp);

  _TodoAppState() {
    combinedStore.dispatch(addTodo('take care of the green caterpillar'));
    combinedStore.dispatch(addTodo('wait until it becomes a butterfly :)'));
    combinedStore.dispatch(addTodo('teach the butterfly to flutter'));
    combinedStore.dispatch(toggleTodo(0));
    combinedStore.addMiddleware(new ThunkMiddleware<
        Tuple2<Iterable<Todo>, VisibilityFilter>,
        TodoAction>());
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.loggerName} ${rec.time}');
      print('${rec.message}');
    });

    combinedStore.addMiddleware(new LoggingMiddleware(Logger.root));
  }

  List<Element> get _buildListItems =>
      _visibleTodos
          .map((Todo todo) =>
          li()([
            div()([
              input('checkbox', attrs: const {'class': 'toggle'},
                  props: (Props props) {
                    props.checked = todo.completed;
                  }, eventListeners: {
                    EventType.click: (_) {
                      _completeMe(todo);
                    }
                  })(),
              label()([text(todo.description)])
            ])
          ]))
          .toList();

  /// Todos to be displayed in the ui.
  Iterable<Todo> get _visibleTodos =>
      combinedStore.state.item1.where((t) =>
      combinedStore.state.item2 == VisibilityFilter.all ||
          t.completed &&
              combinedStore.state.item2 == VisibilityFilter.showCompleted ||
          !t.completed &&
              combinedStore.state.item2 == VisibilityFilter.showPending);

  @override
  Node build() {
    final listItems = _buildListItems;

    return div()([
      section(attrs: const {'id': 'todoapp'})([
        header(attrs: const {'id': 'header'})([
          h1()([text('todos')]),
          input('text', attrs: const {
            'id': 'new-todo',
            'placeholder': 'What needs to be done?',
            'autofocus': '',
          }, eventListeners: {
            EventType.keyup: onKeyEnter((Event event) {
              _enterTodo(event.nativeEvent.target as html.InputElement);
            })
          })(),
        ]),
        section(attrs: const {'id': 'main'})([
          input('checkbox',
              attrs: const {'id': 'toggle-all'},
              eventListeners: {EventType.click: _toggleAll})(),
          label(attrs: const {'for': 'toggle-all'})(
              [text('Mark all as complete')]),
          ul(attrs: const {'id': 'todo-list'})(listItems),
        ]),
        footer(attrs: const {'id': 'footer'})([
          span(attrs: const {'id': 'todo-count'})(),
          // Dunno what this does, but it's in the angular2 version
          div(attrs: const {'class': 'hidden'})(),
          ul(attrs: const {'id': 'filters'})([
            li()([
              a(attrs: const {
                'href': '#/',
                'class': 'selected'
              }, eventListeners: <EventType, EventListener>{
                EventType.click: _changeFilterToAll
              })([text('All')]),
            ]),
            li()([
              a(attrs: const {
                'href': '#/active'
              }, eventListeners: <EventType, EventListener>{
                EventType.click: _changeFilterToPending
              })([text('Active')]),
            ]),
            li()([
              a(attrs: const {
                'href': '#/completed'
              }, eventListeners: <EventType, EventListener>{
                EventType.click: _changeFilterToCompleted
              })([text('Completed')]),
            ]),
          ]),
        ]),
      ]),
      footer(attrs: const {'id': 'info'})([
        p()([
          text('Created using '),
          a(attrs: const {'href': 'https://github.com/yjbanov/butterfly'})(
              [text('Butterfly')]),
        ]),
      ]),
    ]);
  }

  void _changeFilterToAll(Event event) {
    combinedStore.dispatch(setVisibilityFilter(VisibilityFilter.all));
    scheduleUpdate();
  }

  void _changeFilterToCompleted(Event event) {
    combinedStore.dispatch(setVisibilityFilter(VisibilityFilter.showCompleted));
    scheduleUpdate();
  }

  void _changeFilterToPending(Event event) {
    combinedStore.dispatch(setVisibilityFilter(VisibilityFilter.showPending));
    scheduleUpdate();
  }

  void _completeMe(Todo todo) {
    final index = _findIndex(todo);
    combinedStore.dispatch(toggleTodo(index));
    scheduleUpdate();
  }

  void _enterTodo(html.InputElement inputElement) {
    combinedStore.dispatch(asyncAddTodo(inputElement.value));
    inputElement.value = '';
    scheduleUpdate();
  }

  int _findIndex(Todo todo) => combinedStore.state.item1.toList().indexOf(todo);

  void _toggleAll(Event event) {
    combinedStore.state.item1.forEach((Todo todo) {
      combinedStore.dispatch(toggleTodo(_findIndex(todo)));
    });
    scheduleUpdate();
  }
}
