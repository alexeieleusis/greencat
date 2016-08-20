// Copyright (c) 2016, Alexei Eleusis Díaz Vera. All rights reserved. Use of this source code
// is governed by the Apache 2.0 license that can be found in the LICENSE file.

import 'package:greencat/greencat.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Awesome awesome;

    setUp(() {
      awesome = new Awesome();
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });
}
