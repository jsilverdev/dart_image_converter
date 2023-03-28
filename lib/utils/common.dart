import 'dart:io';

void simplePrint(String text) {
  stdout.writeln(text);
}


void simpleErrorPrint(String text) {
  stderr.writeln(text);
}

void printSeparator() {
  simplePrint("\n------------------");
}