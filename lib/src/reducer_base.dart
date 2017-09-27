library reducer_base;

import 'package:greencat/src/action.dart';
import 'package:tuple/tuple.dart';

/// Base class for all reducers, should contain a set of function to correctly map...
abstract class ReducerBase<S, A extends Action> implements Function {
  /// This method provides the class with the reducer logic.
  S call(A action, {S currentState});

  /// Combines this reducer with the provided one, resulting in a reducer which
  /// state is a Tuple2<S, S2> preserving the same action type.
  ReducerBase<Tuple2<S, S2>, A> combineWith<S2>(ReducerBase<S2, A> reducer) =>
      new _TupleReducer<S, S2, A>(this, reducer);
}

class _TupleReducer<S1, S2, A extends Action>
    extends ReducerBase<Tuple2<S1, S2>, A> {
  final ReducerBase<S1, A> first;
  final ReducerBase<S2, A> second;

  _TupleReducer(this.first, this.second);

  @override
  Tuple2<S1, S2> call(A action, {Tuple2<S1, S2> currentState}) {
    final firstState = currentState != null ? currentState.item1 : null;
    final secondState = currentState != null ? currentState.item2 : null;
    return new Tuple2<S1, S2>(first(action, currentState: firstState),
        second(action, currentState: secondState));
  }
}
