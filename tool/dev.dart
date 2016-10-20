library tool.dev;

import 'dart:async';
import 'package:dart_dev/dart_dev.dart' show dev /*, config*/;

Future<Null> main(List<String> args) async {
  // https://github.com/Workiva/dart_dev

  // Perform task configuration here as necessary.

  // Available task configurations:
  // config.analyze
  // config.copyLicense
  // config.coverage
  // config.docs
  // config.examples
  // config.format
  // config.test

  await dev(args);
}
