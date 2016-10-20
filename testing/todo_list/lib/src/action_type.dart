library action_type;

/// The type of actions on the TodoApp.
enum ActionType {
  /// Indicates to add a to-do to the list.
  addTodo,

  /// Indicates to add a to-do to the list.
  asyncAddTodo,

  /// Indicates to toggle.
  toggleTodo,

  /// Indicates changing displayed items.
  setVisibilityFilter
}

/// Indicates which elements should be visible.
enum VisibilityFilter {
  /// All items.
  all,

  /// Non completed ones.
  showPending,

  /// Completed
  showCompleted
}
