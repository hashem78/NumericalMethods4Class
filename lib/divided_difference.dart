import 'dart:collection';
import 'dart:io';

import 'functions.dart';

class DividedDifference {
  static const menuItems = <String>[
    '1. Calculate divided difference',
    "2. Generate 'a' values",
    '3. Generate divided differnece table from function',
    '4. Generate divided dfference table from points (x,f(x))',
    '0. Exit',
  ];
  static void menu() {
    for (final item in menuItems) {
      print(item);
    }
    stdout.write('Enter choice: ');
    var choice = int.parse(stdin.readLineSync());
    switch (choice) {
      case 1:
        {
          final func = requestFunction();
          stdout.write('Enter a list of x values: ');
          final xvals = stdin.readLineSync().split(' ').map(num.parse).toList();

          printResult(calculate(func, xvals));
        }
        break;
      case 2:
        {
          final func = requestFunction();
          stdout.write('Enter a list of x values: ');
          final xvals = stdin.readLineSync().split(' ').map(num.parse).toList();
          printResult(aValueGenerator(func, xvals));
          stdin.readByteSync();
        }
        break;
      case 3:
        {
          final func = requestFunction();
          stdout.write('Enter a list of x values: ');
          final xvals = stdin.readLineSync().split(' ').map(num.parse).toList();
          generateTable(func, xvals);
        }
        break;
      case 4:
        {
          stdout.write('Enter a list of x values: ');
          final xvals = stdin.readLineSync().split(' ').map(num.parse).toList();
          stdout.write('Enter a list of f(x) values: ');
          final yvals = stdin.readLineSync().split(' ').map(num.parse).toList();
          generateTableFromPoints(xvals, yvals);
        }
        break;
    }
  }

  static void generateTableFromPoints(List<num> xValues, List<num> yValues) {
    print('=========Note that the a values are the diagonals=======');
    for (var i = 0; i < xValues.length; ++i) {
      final line = Queue<String>();

      for (var j = 0; j < i + 1; ++j) {
        final subX = xValues.sublist(j, i + 1);
        final subY = yValues.sublist(j, i + 1);
        line.addFirst(calculateFromPoints(subX, subY).toString() + ' ');
      }
      line.addFirst('x$i = ${xValues[i]} | ');
      print(line.join(' '));
    }
  }

  static num calculateFromPoints(List<num> xvals, List<num> yvals) {
    if (xvals.length == 1) {
      return yvals.first;
    }
    final lhs = xvals.getRange(1, xvals.length).toList();
    final lhsX = yvals.getRange(1, yvals.length).toList();
    final rhs = xvals.getRange(0, xvals.length - 1).toList();
    final rhsY = yvals.getRange(0, yvals.length - 1).toList();

    if (lhs.length == 1 && rhs.length == 1) {
      return (lhsX.first - rhsY.first) / (lhs.last - rhs.first);
    }
    final ans =
        (calculateFromPoints(lhs, lhsX) - calculateFromPoints(rhs, rhsY)) /
            (lhs.last - rhs.first);
    return ans;
  }

  static void generateTable(String func, List<num> xValues) {
    print('=========Note that the a values are the diagonals=======');
    for (var i = 0; i < xValues.length; ++i) {
      final line = Queue<String>();

      for (var j = 0; j < i + 1; ++j) {
        final sub = xValues.sublist(j, i + 1);
        line.addFirst(calculate(func, sub).toString() + ' ');
      }
      line.addFirst('x$i = ${xValues[i]} | ');
      print(line.join(' '));
    }
  }

  static num calculate(String func, List<num> xvals) {
    if (xvals.length == 1) {
      return evaluate(func, xvals.first);
    }
    final lhs = xvals.getRange(1, xvals.length).toList();
    final rhs = xvals.getRange(0, xvals.length - 1).toList();
    if (lhs.length == 1 && rhs.length == 1) {
      return (evaluate(func, lhs.first) - evaluate(func, rhs.first)) /
          (lhs.last - rhs.first);
    }
    final ans =
        (calculate(func, lhs) - calculate(func, rhs)) / (lhs.last - rhs.first);
    return ans;
  }

  static List<num> aValueGenerator(String func, List<num> xValues) {
    final ans = <num>[];

    for (var i = 0; i < xValues.length; ++i) {
      ans.add(calculate(func, xValues.sublist(0, i + 1)));
    }
    return ans;
  }
}
