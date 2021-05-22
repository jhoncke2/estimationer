import 'dart:io';

String callFixture(String name) => File('test/fixtures/$name').readAsStringSync();
