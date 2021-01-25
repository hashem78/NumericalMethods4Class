import 'dart:io';

import 'divided_difference.dart';
import 'functions.dart';

class NewtonPolynomials {
  static const menuItems = <String>[
    '1. Generate from A values and X vals',
    '2. Generate from xvals',
    '0. Exit'
  ];
  static void menu() {
    for (final item in menuItems) {
      print(item);
    }
    stdout.write('Enter choice: ');
    var choice = int.parse(stdin.readLineSync());
    switch (choice) {
      case 1:
        stdout.write('Enter the degree of the polynomial: ');
        final degree = int.parse(stdin.readLineSync());
        stdout.write('Enter the a list of "a" values: ');
        final lavals = stdin.readLineSync().split(' ').map(num.parse).toList();

        stdout.write('Enter the a list of "x" values: ');
        final lxvals = stdin.readLineSync().split(' ').map(num.parse).toList();

        printResult(generateFromAandXvals(degree, lavals, lxvals));
        break;
      case 2:
        stdout.write('Enter the degree of the polynomial: ');
        final degree = int.parse(stdin.readLineSync());

        stdout.write('Enter the a list of "x" values: ');
        final lxvals = stdin.readLineSync().split(' ').map(num.parse).toList();
        final func = requestFunction();
        printResult(generateFromXvals(degree, func, lxvals));
        break;
    }
  }

  static String _generateHelper(
    int currentDegree,
    int maxDegree,
    List<num> a,
    List<num> x,
  ) {
    if (currentDegree == 0) {
      var an = a[currentDegree];
      return '$an + ' + _generateHelper(currentDegree + 1, maxDegree, a, x);
    } else if (currentDegree <= maxDegree) {
      var ans = '';
      var an = a[currentDegree];
      for (var i = 0; i < currentDegree; ++i) {
        final xi = x[i];
        ans += '(x - $xi)';
      }
      return '$an * $ans + ' +
          _generateHelper(currentDegree + 1, maxDegree, a, x);
    } else {
      return '';
    }
  }

  static String generateFromAandXvals(
    int maxDegree,
    List<num> a,
    List<num> x,
  ) {
    final solution = _generateHelper(0, maxDegree, a, x).trim();
    if (solution.endsWith('+')) {
      return solution.substring(0, solution.length - 1);
    }
    return solution;
  }

  static String generateFromXvals(
    int degree,
    String func,
    List<num> xvals,
  ) {
    final a = DividedDifference.aValueGenerator(func, xvals);
    final solution = _generateHelper(0, degree, a, xvals).trim();
    if (solution.endsWith('+')) {
      return solution.substring(0, solution.length - 1);
    }
    return solution;
  }
}
