library middleware_api;

import 'package:greencat/src/action.dart';
import 'package:greencat/src/store.dart';
import 'package:greencat/src/typedefs.dart';

/// Middleware is the suggested way to extend Redux with custom functionality.
/// Middleware lets you wrap the store’s dispatch method for fun and profit.
/// The key feature of middleware is that it is composable. Multiple middleware
/// can be combined together, where each middleware requires no knowledge of
/// what comes before or after it in the chain.
///
/// The most common use case for middleware is to support asynchronous actions
/// without much boilerplate code or a dependency on a library like Rx. It does
/// so by letting you dispatch async actions in addition to normal actions.
class MiddlewareApi<S, A extends Action> {
  final Store<S, A> _store;

  /// Dummy constructor.
  MiddlewareApi(Store<S, A> store) : _store = store;

  /// Middleware wraps the base dispatch function. It allows the dispatch
  /// function to handle async actions in addition to actions. Middleware may
  /// transform, delay, ignore, or otherwise interpret actions or async actions
  /// before passing them to the next middleware. See below for more information.
  Dispatch<A> get dispatch => _store.dispatch;

  /// Returns the result of invoking `Store.state`.
  S get state => _store.state;
}
