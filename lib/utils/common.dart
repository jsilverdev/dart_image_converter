import 'dart:io';

void simplePrint(Object? object) {
  stdout.writeln(object);
}


void simpleErrorPrint(Object? object) {
  stderr.writeln(object);
}

void printSeparator() {
  simplePrint("\n------------------");
}