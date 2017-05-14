library action;

import 'dart:async';

import 'package:greencat/src/middleware_api.dart';

/// Actions are payloads of information that send data from your application to
/// your store. They are the only source of information for the store. You send
/// them to the store using `store.dispatch()`.
///
/// Uses ideas from https://github.com/acdlite/flux-standard-action
abstract class Action<T> {
  /// The optional error property _may_ be set to true if the action represents an
  /// error.
  ///
  /// An action whose error is true is analogous to a rejected Future. By
  /// convention, the payload _should_ be an error object.
  ///
  /// If error has any other value besides true, including undefined and null,
  /// the action _must not_ be interpreted as an error.
  ///
  /// This property is migrated to preserve the same API than Redux, but handling
  /// errors without using it is preferred.
  @deprecated
  bool get isError => false;

  /// The optional payload property _may_ be any type of value. It represents the
  /// payload of the action. Any information about the action that is not the
  /// type or status of the action should be part of the payload field.
  ///
  /// By convention, if error is true, the payload _should_ be an error object.
  /// This is akin to rejecting a promise with an error object.
  // TODO: Consider using the Option or Either type to convey an error.
  dynamic get payload;

  /// The type of an action identifies to the consumer the nature of the action
  /// that has occurred. Two actions with the same type and equivalent payloads
  /// _must_  equivalent iff their payloads (using `operator==` or `identical`)
  /// should produce the same result when a reducer is applied on them. By
  /// convention, type is usually string constant or a Symbol, it is
  /// recommended, to use an enumeration for this property.
  T get type;

  @override
  String toString() => 'Action { type: $type, payload: $payload }';
}

/// Base type for actions that trigger side effects.
abstract class AsyncAction<T> extends Action<T> implements Function {
  /// Async actions are functions that return a future, it is OK to have side
  /// effects within the body of an async action, also a [Future] should be
  /// returned that resolves when all async effects from this action are resolved.
  Future<dynamic> call(MiddlewareApi api);
}
