library thunk_middleware;

import 'package:greencat/greencat.dart';

/// Middleware to handle async actions.
class ThunkMiddleware<S, A extends Action> implements Function {
  /// Default const constructor.
  const ThunkMiddleware();

  /// Invokes the next transformer on the action it receives, but if the action
  /// is async, it invokes it first.
  DispatchTransformer<A> call(MiddlewareApi<S, A> api) => (next) => (action) {
        if (action is AsyncAction) {
          final AsyncAction asyncAction = action;
          asyncAction(api);
        }

        return next(action);
      };
}
