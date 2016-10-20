/// Function definitions used along the package, for a deeper description see
/// http://redux.js.org/docs/Glossary.html
library typedefs;

import 'package:greencat/src/action.dart';
import 'package:greencat/src/middleware_api.dart';
import 'package:tuple/tuple.dart';

/// Dispatches an action. This is the only way to trigger a state change.
typedef A BaseDispatch<A extends Action>(A action);

/// A dispatching function (or simply dispatch function) is a function that
/// accepts an action or an async action; it then may or may not dispatch one
/// or more actions to the store.
typedef dynamic Dispatch<A extends Action>(A action);

/// Used in the Middleware to transform a dispatch.
typedef Dispatch<A> DispatchTransformer<A extends Action>(Dispatch<A> dispatch);

/// A middleware is a higher-order function that composes a dispatch function
/// to return a new dispatch function. It often turns async actions into actions.
typedef DispatchTransformer<A> Middleware<S, A extends Action>(
    MiddlewareApi<S, A> api);

/// A reducer (also called a reducing function) is a function that accepts an
/// accumulation and a value and returns a new accumulation. They are used to
/// reduce a collection of values down to a single value.
///
/// Reducers are not unique to Redux they are a fundamental concept in functional
/// programming. Even most non-functional languages, like JavaScript, have a
/// built-in API for reducing. In JavaScript, it's Array.prototype.reduce().
///
/// N.B. Given the same arguments, it should calculate the next state and
/// return it. No surprises. No side effects. No API calls. No mutations. Just
/// a calculation.
typedef S Reducer<S, A extends Action>(A action, {S currentState});

/// Combines two reducers to operate on the cartesian product.
typedef Reducer<Tuple2<S1, S2>, A> ReducersCombinator<S1, S2, A extends Action>(
    Reducer<S1, A> first, Reducer<S2, A> second);
