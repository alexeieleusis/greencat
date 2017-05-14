library logging_middleware;

import 'package:greencat/greencat.dart';
import 'package:logging/logging.dart';

/// Middleware to handle async actions.
class LoggingMiddleware<S, A extends Action> implements Function {
  final Logger _logger;

  /// Default constructor.
  LoggingMiddleware(Logger logger) : _logger = logger;

  /// Logs the action, current state and state after applying the reducer.
  DispatchTransformer<A> call(MiddlewareApi<S, A> api) => (next) => (action) {
        final next2 = next(action);
        _logger..fine('action: $action')..fine(
            'prev state: ${api.state}')..fine('next state: ${api.state}')..fine(
            '=== === === === === === === === === === === === === === ');
        return next2;
      };
}
