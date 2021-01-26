import 'dart:io';

import 'package:acm/curve_fitting.dart';

import 'divided_difference.dart';
import 'functions.dart';
import 'matirx_methods.dart';
import 'newton_polynomials.dart';
import 'numerical_differentiation.dart';
import 'numerical_integration.dart';
import 'numerical_methods.dart';

class Application {
  static const menuItems = <String>[
    '1. Divided difference',
    '2. Newton polynomials',
    '3. Numerical Differentiation',
    '4. Numerical Integration',
    '5. Numerical Methods',
    '6. Generate Lagrange Polynomial ',
    '7. Matrix Methods',
    '8. Curve Fitting',
    '9. Evaluate function at',
    '0. Exit'
  ];
  static void menu() {
    for (final item in menuItems) {
      print(item);
    }
    stdout.write('Enter choice: ');
    var choice = int.parse(stdin.readLineSync());
    clearConsole();
    switch (choice) {
      case 1:
        DividedDifference.menu();
        break;
      case 2:
        NewtonPolynomials.menu();
        break;
      case 3:
        NumericalDifferentiation.menu();
        break;
      case 4:
        NumericalIntegration.menu();
        break;
      case 5:
        NumericalMethods.menu();
        break;
      case 6:
        {
          final func = requestFunction();
          stdout.write('Enter the degree of the polynomial P: ');
          final n = int.parse(stdin.readLineSync());
          stdout.write('Enter a list of "x" values: ');
          final xvals =
              stdin.readLineSync().split(' ').map(double.parse).toList();

          printResult(findLagrangePolynomial(func, n, xvals));
        }

        break;

      case 7:
        MatrixMethods.menu();
        break;
      case 8:
        CurveFitting.menu();
        break;
      case 9:
        {
          final func = requestFunction();
          while (true) {
            stdout.write('Enter value: ');
            var value = double.parse(stdin.readLineSync());

            printResult(evaluate(func, value), pause: true);
          }
        }
        break;
    }
  }
}

int main() {
  while (true) {
    Application.menu();
  }
}
