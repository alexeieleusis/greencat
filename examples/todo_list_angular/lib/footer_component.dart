library footer_component;

import 'dart:async';

import 'package:angular2/common.dart';
import 'package:angular2/core.dart';
import 'package:todo_list/todo_list.dart';

/// Provides a way to add a to-do.
@Component(
    selector: 'footer',
    templateUrl: 'package:todo_list_angular/footer_component.html',
    directives: const [NgFor],
    changeDetection: ChangeDetectionStrategy.OnPush)
class FooterComponent implements OnDestroy {
  StreamController<VisibilityFilter> _controller =
      new StreamController<VisibilityFilter>.broadcast();

  /// Provides labels suitable to display in the ui.
  final Map<VisibilityFilter, String> labels = const {
    VisibilityFilter.all: 'All',
    VisibilityFilter.showCompleted: 'Completed',
    VisibilityFilter.showPending: 'Pending',
  };

  /// Text to be displayed.
  @Input()
  Iterable<VisibilityFilter> filters;

  /// Gets the stream of visibility changes that should be propagated to the
  /// store when the user clicks a visibility filter.
  @Output()
  Stream<VisibilityFilter> get setVisibilityFilter => _controller.stream;

  @override
  void ngOnDestroy() {
    _controller.close();
  }

  /// Handles the click event to a particular link.
  void setVisibilityHandler(int i) {
    _controller.add(filters.elementAt(i));
  }
}
