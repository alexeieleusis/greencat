library todo;

/// Represents a to-do in the application.
class Todo {
  /// A label describing what is needed to do.
  final String description;

  /// A flag indicating if the task is completed.
  final bool completed;

  /// Creates a new instance.
  Todo(this.description, this.completed);

  /// Copies this instance into a new one changing the specifies values.
  Todo copy({String description, bool completed}) =>
      new Todo(description ?? this.description, completed ?? this.completed);

  @override
  String toString() {
    return 'Todo{description: $description, completed: $completed}';
  }
}
