import 'dart:io';
import 'dart:math';

import 'functions.dart';

class NumericalDifferentiation {
  static const menuItems = <String>[
    '1. First Derivative',
    '2. Second Derivative',
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
        NumericalDifferentiationFirstDir.menu();
        break;
      case 2:
        NumericalDifferentiationSecondDir.menu();
        break;
    }
  }
}

class NumericalDifferentiationFirstDir {
  static const menuItems = <String>[
    '1. Central Difference of Order 2',
    '2. Optimum Central Difference of Order 2',
    '3. Central Difference of Order 4',
    '4. Optimum Central Difference of Order 4',
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
        {
          final func = requestFunction();
          stdout.write('Enter x value: ');
          final x = double.parse(stdin.readLineSync());
          stdout.write('Enter step size (h) value: ');
          final h = double.parse(stdin.readLineSync());
          printResult(centralDiffernceO2(func, x, h));
        }
        break;
      case 2:
        {
          print('Enter order of root M: ');
          final m = int.parse(stdin.readLineSync());
          print('Enter the value of epsilon: ');
          final epsilon = int.parse(stdin.readLineSync());
          printResult(optimumCentralDifferenceO2(m, epsilon));
        }
        break;
      case 3:
        {
          final func = requestFunction();
          stdout.write('Enter x value: ');
          final x = double.parse(stdin.readLineSync());
          stdout.write('Enter step size (h) value: ');
          final h = double.parse(stdin.readLineSync());
          printResult(centralDiffernceO4(func, x, h));
        }
        break;
      case 4:
        {
          print('Enter order of root M: ');
          final m = int.parse(stdin.readLineSync());
          print('Enter the value of epsilon: ');
          final epsilon = int.parse(stdin.readLineSync());
          printResult(optimumCentralDifferenceO4(m, epsilon));
        }
        break;
    }
  }

  static double centralDiffernceO2(String func, num x, num h) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''f(x+h)-f(x+h)/(2*h)''');
    print('#######################NOTE###########################');

    final derivative = derive(func);
    final actual = evaluate(derivative, x);
    final approximation =
        (evaluate(func, x + h) - evaluate(func, x - h)) / (2.0 * h);
    print('error in central difference is: ${actual - approximation}');
    return approximation;
  }

  // M is the maximum value for the function
  static double optimumCentralDifferenceO2(num M, num epsilon) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''(3*epsilon/M)^1/3''');
    print('where M is the maximal value of the function');
    print('#######################NOTE###########################');
    return pow(3 * epsilon / M, 1 / 3);
  }

  static double centralDiffernceO4(String func, num x, num h) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''-f(x+2h)+8*f(x+h)-8*f(x-h)+f(x-2h)/(12*h)''');
    print('#######################NOTE###########################');

    final derivative = derive(func);
    final actual = evaluate(derivative, x);
    final approximation = (-evaluate(func, x + 2 * h) +
            8 * evaluate(func, x + h) -
            8 * evaluate(func, x - h) +
            evaluate(func, x - 2 * h)) /
        (12.0 * h);
    print('error in central difference is: ${actual - approximation}');
    return approximation;
  }

  // M is the maximum value for the function
  static double optimumCentralDifferenceO4(num M, num epsilon) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''(45*epsilon/(4M)^1/5''');
    print('where M is the maximal value of the function');
    print('#######################NOTE###########################');
    return pow(45 * epsilon / (4 * M), 1 / 5);
  }
}

class NumericalDifferentiationSecondDir {
  static const menuItems = <String>[
    '1. Central Difference of Order 2',
    '2. Optimum Central Differnece of Order 2',
    '3. Forward Difference Lagrange of Order 2',
    '4. Backward Difference Lagrandge of Order 2',
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
        {
          final func = requestFunction();
          stdout.write('Enter x value: ');
          final x = double.parse(stdin.readLineSync());
          stdout.write('Enter step size (h) value: ');
          final h = double.parse(stdin.readLineSync());
          printResult(centralDiffernceO2(func, x, h));
        }
        break;
      case 2:
        {
          stdout.write('Enter order of root M: ');
          final m = int.parse(stdin.readLineSync());
          stdout.write('Enter the value of epsilon: ');
          final epsilon = double.parse(stdin.readLineSync());
          printResult(optimumCentralDifferenceO2(m, epsilon));
        }
        break;
      case 3:
        {
          final func = requestFunction();
          stdout.write('Enter x value: ');
          final x = double.parse(stdin.readLineSync());
          stdout.write('Enter step size (h) value: ');
          final h = double.parse(stdin.readLineSync());
          printResult(forwardDifferenceLagrangeO2(func, x, h));
        }
        break;
      case 4:
        {
          final func = requestFunction();
          stdout.write('Enter x value: ');
          final x = double.parse(stdin.readLineSync());
          stdout.write('Enter step size (h) value: ');
          final h = double.parse(stdin.readLineSync());
          printResult(backwardDifferenceLagrangeO2(func, x, h));
        }
        break;
    }
  }

  static double centralDiffernceO2(String func, num x, num h) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''(f(x+h)-2*f(x) + f(x-h)) /(h*h)''');
    print('#######################NOTE###########################');

    final derivative = derive(func);
    final actual = evaluate(derivative, x);
    final approximation = (evaluate(func, x + h) -
            2 * evaluate(func, x) +
            evaluate(func, x - h)) /
        (pow(h, 2));
    print('error in central difference is: ${actual - approximation}');
    return approximation;
  }

  // M is the maximum value for the function
  static double optimumCentralDifferenceO2(num m, num epsilon) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''(48*epsilon/M)^1/4''');
    print('where M is the maximal value of the function');
    print('#######################NOTE###########################');
    return pow(48 * epsilon / m, 1 / 4);
  }

  static double forwardDifferenceLagrangeO2(String func, num x, num h) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''(2 * f0 - 5 * f1 + 4 * f2 - f3) / pow(h, 2)''');
    print('where M is the maximal value of the function');
    print('#######################NOTE###########################');

    final f0 = evaluate(func, x);
    final f1 = evaluate(func, x + h);
    final f2 = evaluate(func, x + 2 * h);
    final f3 = evaluate(func, x + 3 * h);
    return (2 * f0 - 5 * f1 + 4 * f2 - f3) / pow(h, 2);
  }

  static double backwardDifferenceLagrangeO2(String func, num x, num h) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''(2 * f0 - 5 * f-1 + 4 * f-2 - f-3) / pow(h, 2)''');
    print('where M is the maximal value of the function');
    print('#######################NOTE###########################');

    final f0 = evaluate(func, x);
    final fneg1 = evaluate(func, x - h);
    final fneg2 = evaluate(func, x - 2 * h);
    final fneg3 = evaluate(func, x - 3 * h);
    return (2 * f0 - 5 * fneg1 + 4 * fneg2 - fneg3) / pow(h, 2);
  }
}
