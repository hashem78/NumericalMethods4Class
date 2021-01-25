import 'dart:io';

import 'functions.dart';

class Trapezoidal {
  static const menuItems = <String>[
    '1. Normal Trapezoidal',
    '2. Composite Trapezoidal From Iterval',
    '3. Compositre Trapezoidal From xvals',
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
        final func = requestFunction();
        stdout.write('Enter step size value (h): ');
        final h = double.parse(stdin.readLineSync());
        stdout.write('Enter a list of "x" values: ');
        final xvals =
            stdin.readLineSync().split(' ').map(double.parse).toList();
        printResult(trapezoidalRule(func, h, xvals));
        break;
      case 2:
        final func = requestFunction();
        stdout.write('Enter number of "x" vals (M+1): ');
        final numberOfxVals = int.parse(stdin.readLineSync());
        stdout.write('Enter a b for interval: ');
        final interval =
            stdin.readLineSync().split(' ').map(double.parse).toList();
        printResult(
          trapezoidalRuleCompositeFromInterval(
            func,
            numberOfxVals,
            interval,
          ),
        );
        break;
      case 3:
        final func = requestFunction();
        stdout.write('Enter a list of "x" values: ');
        final xvals =
            stdin.readLineSync().split(' ').map(double.parse).toList();
        trapezoidalRuleCompositeFromxValues(func, xvals);
        break;
    }
  }

  static double trapezoidalRule(String func, num h, List<num> xvals) {
    if (xvals.length != 2) {
      throw Exception('xValues more/less than allowed');
    }
    final evaled = xvals.map(
      (point) {
        return evaluate(func, point) as num;
      },
    ).toList();
    num sum = 0;
    evaled.forEach((val) {
      sum += val;
    });
    return (h / 2) * sum;
  }

  // M = numberOfxValues - 1
  static double trapezoidalRuleCompositeFromInterval(
    String func,
    num numberOfxValues,
    List<num> interval,
  ) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''
     h
    --- (f(a) + f(b)) + h * sum(1,M-1,fk)
     2
--> fk = f(h+i*k)''');
    print('M is numberOfxValues - 1');
    print('h is (interval.last - interval.first) / M');
    print('#######################NOTE###########################');

    final m = numberOfxValues - 1;
    final h = (interval.last - interval.first) / m;

    print('M :$m, h: $h');
    num sum = 0;
    for (var i = 0; i < m; ++i) {
      sum += trapezoidalRule(
        func,
        h,
        [interval.first + i * h, interval.first + (i + 1) * h],
      );
    }
    return sum;
  }

  // M = numberOfxValues - 1
  static double trapezoidalRuleCompositeFromxValues(
    String func,
    List<num> xvals,
  ) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''
     h
    --- (f(a) + f(b)) + h * sum(1,M-1,fk)
     2
--> fk = f(h+i*k)''');
    print('M is numberOfxValues - 1');
    print('h is (interval.last - interval.first) / M');
    print('#######################NOTE###########################');
    final m = xvals.length - 1;
    final h = (xvals.last - xvals.first) / m;

    print('M :$m, h: $h');

    num sum = 0;
    for (var i = 0; i < m; ++i) {
      sum += trapezoidalRule(
        func,
        h,
        [xvals[i], xvals[i + 1]],
      );
    }
    return sum;
  }
}

class Simpsons {
  static const menuItems = <String>[
    '1. Simpson',
    '2. Simpson 3/8',
    '3. Composite Simpson From Interval',
    '4. Compositre Simpson From xvals',
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
        final func = requestFunction();
        stdout.write('Enter step size value (h): ');
        final h = double.parse(stdin.readLineSync());
        stdout.write('Enter a list of "x" values: ');
        final xvals =
            stdin.readLineSync().split(' ').map(double.parse).toList();
        printResult(simpsonsRule(func, h, xvals));
        break;
      case 2:
        {
          final func = requestFunction();
          stdout.write('Enter step size value (h): ');
          final h = double.parse(stdin.readLineSync());
          stdout.write('Enter a list of "x" values: ');
          final xvals =
              stdin.readLineSync().split(' ').map(double.parse).toList();
          printResult(simpsonsRule3by8(func, h, xvals));
          break;
        }
        break;
      case 3:
        final func = requestFunction();
        stdout.write('Enter number of "x" vals: ');
        final numberOfxVals = int.parse(stdin.readLineSync());
        stdout.write('Enter a b for interval: ');
        final interval =
            stdin.readLineSync().split(' ').map(double.parse).toList();
        printResult(
          simpsonRuleCompositeFromInterval(
            func,
            numberOfxVals,
            interval,
          ),
        );
        break;
      case 4:
        final func = requestFunction();
        stdout.write('Enter a list of "x" values: ');
        final xvals =
            stdin.readLineSync().split(' ').map(double.parse).toList();
        simpsonRuleCompositeFromxValues(func, xvals);
        break;
    }
  }

  static double simpsonsRule(String func, num h, List<num> xValues) {
    if (xValues.length != 3) {
      throw Exception('xValues more/less than allowed');
    }
    final evaled = [
      evaluate(func, xValues[0]),
      4 * evaluate(func, xValues[1]),
      evaluate(func, xValues[2]),
    ];
    num sum = 0;
    evaled.forEach((val) {
      sum += val;
    });
    return (h / 3) * sum;
  }

  static double simpsonsRule3by8(String func, num h, List<num> xValues) {
    if (xValues.length != 4) {
      throw Exception('xValues more/less than allowed');
    }
    final evaled = [
      evaluate(func, xValues[0]),
      3 * evaluate(func, xValues[1]),
      3 * evaluate(func, xValues[2]),
      evaluate(func, xValues[3]),
    ];
    num sum = 0;
    evaled.forEach((val) {
      sum += val;
    });
    return (3 * h / 8) * sum;
  }

  // M = numberOfxValues - 1
  static double simpsonRuleCompositeFromInterval(
    String func,
    num numberOfxValues,
    List<num> interval,
  ) {
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''
     h                   2h                     4h
    --- (f(a) + f(b)) + -----  sum(1,M-1,fk) + ------ sum(1,M,f2k-1)
     3                    3                      3
--> fk = f(h+i*k)''');
    print('M is the (number of points - 1)/2 (the number of subdivisions)');
    print('######Number of points - 1 has to be even#######');
    print('h is (interval.last - interval.first) / (2 * m)');
    print('#######################NOTE###########################');

    final m = (numberOfxValues - 1) / 2;
    if ((numberOfxValues - 1) % 2 != 0) {
      print('M HAS TO BE EVEN, IE THE NUMBER OF POINTS SHOULD BE ODD!');
      return -11111111111111;
    }

    final h = (interval.last - interval.first) / (2 * m);

    print('M: $m, h: $h');

    num sum = 0;
    for (var i = 0; i < 2 * m; i += 2) {
      sum += simpsonsRule(
        func,
        h,
        [
          interval.first + i * h,
          interval.first + (i + 1) * h,
          interval.first + (i + 2) * h
        ],
      );
    }
    return sum;
  }

  static void simpsonRuleCompositeFromxValues(
    String func,
    List<num> xValues,
  ) {
    print('solve by hand');
    print('#######################NOTE###########################');
    print('The following equation can be used');
    print('''
     h                   2h                     4h
    --- (f(a) + f(b)) + -----  sum(1,M-1,fk) + ------ sum(1,M,f2k-1)
     3                    3                      3
--> fk = f(h+i*k)''');
    print('M is the number of points - 1 (the number of subdivisions)');
    print('h is (interval.last - interval.first) / (2 * m)');
    print('#######################NOTE###########################');
  }
}

class NumericalIntegration {
  static const menuItems = <String>[
    '1. Trapezoidal',
    '2. Simpson',
    "3. Booles'",
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
        Trapezoidal.menu();
        break;
      case 2:
        Simpsons.menu();
        break;
      case 3:
        final func = requestFunction();
        stdout.write('Enter step size value (h): ');
        final h = double.parse(stdin.readLineSync());
        stdout.write('Enter a list of "x" values: ');
        final xvals =
            stdin.readLineSync().split(' ').map(double.parse).toList();
        printResult(boolesRule(func, h, xvals));
        break;
    }
  }

  static double boolesRule(String func, num h, List<num> xvals) {
    if (xvals.length != 5) {
      throw Exception('xValues more/less than allowed');
    }
    final evaled = [
      7 * evaluate(func, xvals[0]),
      32 * evaluate(func, xvals[1]),
      12 * evaluate(func, xvals[2]),
      32 * evaluate(func, xvals[3]),
      7 * evaluate(func, xvals[4]),
    ];
    num sum = 0;
    evaled.forEach((val) {
      sum += val;
    });
    return (2 * h / 45) * sum;
  }
}
