library logging_middleware;

import 'package:logging/logging.dart';
import 'package:greencat/greencat.dart';

/// Middleware to handle async actions.
class LoggingMiddleware<S, A extends Action> implements Function {
  final Logger _logger;

  /// Default constructor.
  LoggingMiddleware(Logger logger) : _logger = logger;

  /// Logs the action, current state and state after applying the reducer.
  DispatchTransformer<A> call(MiddlewareApi<S, A> api) => (next) => (action) {
        _logger.fine('action: $action');
        _logger.fine('prev state: ${api.state}');
        final next2 = next(action);
        _logger.fine('next state: ${api.state}');
        _logger
            .fine('=== === === === === === === === === === === === === === ');
        return next2;
      };
}
