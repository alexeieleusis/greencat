library store;

import 'dart:async';

import 'package:greencat/src/action.dart';
import 'package:greencat/src/middleware_api.dart';
import 'package:greencat/src/typedefs.dart';

/// A store holds the whole state tree of your application.
/// The only way to change the state inside it is to dispatch an action on it.
///
/// Unlike Redux a store is a class. The api is similar to the api in Redux.
class Store<S, A extends Action> implements Sink<A> {
  Reducer<S, A> _reducer;
  S _state;
  final StreamController<S> _controller;
  final List<Middleware<S, A>> _middlewares = <Middleware<S, A>>[];

  /// Creates a Redux store that holds the complete state tree of your app.
  ///  There should only be a single store in your app.
  ///
  ///  [reducer] A reducing function that returns the next state tree, given
  ///  the current state tree and an action to handle.
  ///
  /// [initialState] The initial state. You may optionally specify it to hydrate the
  /// state from the server in universal apps, or to restore a previously
  /// serialized user session. If you produced reducer with combineReducers,
  /// this must be a plain object with the same shape as the keys passed to it.
  /// Otherwise, you are free to pass anything that your reducer can understand.
  ///
  /// [enhancer] The store enhancer. You may optionally specify it to enhance
  /// the store with third-party capabilities such as middleware, time travel,
  /// persistence, etc. The only store enhancer that ships with Redux is
  /// applyMiddleware().
  Store.createStore(Reducer<S, A> reducer,
      {S initialState, Function enhancer, bool sync: false})
      : _reducer = reducer,
        _state = initialState ?? reducer(null, currentState: null),
        _controller = new StreamController<S>.broadcast(sync: sync);

  /// Returns the current state tree of your application.
  ///  It is equal to the last value returned by the store’s reducer.
  S get state => _state;

  /// Provides access to the stream of changes, whenever `dispacth` is invoked,
  /// the result of invoking the reducer will be emmitted through this stream.
  /// This also lets this class delegate subscriptions and cancelations to the
  /// underlying Stream.
  Stream<S> get stream => _controller.stream;

  /// Same as dispatch, added since this is the method native to the Dart SDK.
  @override
  void add(A action) {
    dispatch(action);
  }

  /// Middleware is the suggested way to extend Redux with custom functionality.
  /// Middleware lets you wrap the store’s dispatch method for fun and profit.
  /// The key feature of middleware is that it is composable. Multiple
  /// middleware can be combined together, where each middleware requires no
  /// knowledge of what comes before or after it in the chain.
  void addMiddleware(Middleware<S, A> middleware) {
    _middlewares.add(middleware);
  }

  @override
  void close() {
    _controller.close();
  }

  /// Dispatches an action. This is the only way to trigger a state change.
  ///
  ///  The store’s reducing function will be called with the current getState()
  ///  result and the given action synchronously. Its return value will be
  ///  considered the next state. It will be returned from getState() from now
  ///  on, and the change listeners will immediately be notified.
  void dispatch(A action) {
    final args = new MiddlewareApi<S, A>(this);
    final Dispatch<A> zero = (A a) {
      _state = _reducer(a, currentState: _state);
      _controller.add(_state);
      return _state;
    };
    final Iterable<DispatchTransformer<A>> transformers =
        _middlewares.map((m) => m(args));
    final Dispatch<A> dispatch =
        transformers.fold(zero, (acc, transformer) => transformer(acc));
    dispatch(action);
  }

  /// Adds a change listener. It will be called any time an action is
  /// dispatched, and some part of the state tree may potentially have changed.
  /// You may then call getState() to read the current state tree inside the
  /// callback.  SubscriptionCancellation subscribe(Function listener);

  /// Replaces the reducer currently used by the store to calculate the state.
  ///
  ///  It is an advanced API. You might need this if your app implements code
  ///  splitting, and you want to load some of the reducers dynamically. You
  ///  might also need this if you implement a hot reloading mechanism for
  ///  Redux.
  // TODO: If reducer is replaceable, other than null verification, there is no
  // reason preventing _reducer from being public. Should we verify is not null
  // and invoke it since it should be pure? Probably invoke it is too much since
  // it might be expensive.
  void replaceReducer(Reducer<S, A> reducer) {
    _reducer = reducer;
  }
}
