import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'functions.dart';

class NumericalMethods {
  static const menuItems = <String>[
    '1. Bisection of Bolonzo',
    '2. False Position',
    '3. Newton Iteration',
    '4. Accelerated Newton Iteration',
    '5. Secant Method',
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
        stdout.write('Enter a0: ');
        final a = double.parse(stdin.readLineSync());
        stdout.write('Enter b0: ');
        final b = double.parse(stdin.readLineSync());
        print(bisectionOfBolanzo(func, a, b));
        stdin.readByteSync();
        break;
      case 2:
        final func = requestFunction();
        stdout.write('Enter a0: ');
        final a = double.parse(stdin.readLineSync());
        stdout.write('Enter b0: ');
        final b = double.parse(stdin.readLineSync());
        print(falsePostion(func, a, b));
        stdin.readByteSync();
        break;
      case 3:
        final func = requestFunction();
        stdout.write('Enter p0 (intial approximation): ');
        final p0 = double.parse(stdin.readLineSync());
        stdout.write('Enter root you want to comapre against: ');
        final root = double.parse(stdin.readLineSync());
        stdout.write('Enter number of iteration: ');
        final itern = int.parse(stdin.readLineSync());

        newtonIteration(func, p0, root, numberOfIterations: itern);
        stdin.readByteSync();
        break;
      case 4:
        final func = requestFunction();
        stdout.write('Enter p0 (intial approximation): ');
        final p0 = double.parse(stdin.readLineSync());
        stdout.write('Enter root you want to comapre against: ');
        final m = double.parse(stdin.readLineSync());
        stdout.write('Enter root you want to comapre against: ');
        final root = double.parse(stdin.readLineSync());
        stdout.write('Enter number of iteration: ');
        final itern = int.parse(stdin.readLineSync());
        acceleratedNewtonIteration(func, p0, m, root,
            numberOfIterations: itern);
        stdin.readByteSync();

        break;
      case 5:
        final func = requestFunction();
        stdout.write('Enter p0 (intial approximation): ');
        final p0 = double.parse(stdin.readLineSync());
        stdout.write('Enter p1 (second intial approximation): ');
        final p1 = double.parse(stdin.readLineSync());
        stdout.write('Enter root you want to comapre against: ');
        final root = double.parse(stdin.readLineSync());

        secantMethod(func, p0, p1, root);

        break;
    }
  }

  static bool _areDifferentSigns(double a, double b) {
    return a * b < 0;
  }

  static double bisectionOfBolanzo(
    String func,
    num a,
    num b, {
    double epsilon = 5e-9,
    double delta = 5e-9,
    int maxIters = 50,
  }) {
    double c;
    double fa;
    double fb;
    double fc;
    if (!_areDifferentSigns(evaluate(func, a), evaluate(func, b))) {
      print('RANGE IS INVLAID');
      return -11111111111111112;
    }
    final n = (log(b - a) - log(delta) / log(2)).truncate();
    print('Number of iterations needed: $n');
    print('##Calcuated from int(ln(b0-a0) - ln(delta)/2)##');
    print('Termination criterion: ${b - a} < $delta');
    print('##Calcuated from (b0-a0) < delta##');
    final errorBound = (b - a) / pow(2, n + 1);
    print('error bound |r - Cn| <= $errorBound ');
    print('##Calcuated from (b0-a0)/(2^(n+1))##');

    print('''Equation for c is : ci=  (ai + bi)/2''');

    var counter = 0;

    do {
      fa = evaluate(func, a);
      fb = evaluate(func, b);

      if (!_areDifferentSigns(fa, fb)) break;

      c = (a + b) / 2;
      fc = evaluate(func, c);

      if (fc == 0) {
        a = c;
        b = c;
      } else if (_areDifferentSigns(fa, fc)) {
        b = c;
      } else {
        if (_areDifferentSigns(fc, fb)) a = c;
      }
      print('===========');
      print('k: $counter');
      print('a$counter: $a');
      print('b$counter: $b');
      print('c$counter: $c');
      print('f(c$counter): $fc');
      print('===========\n');

      if ((b - a) < delta) return c;
    } while (counter++ < n);

    return c;
  }

  static double falsePostion(
    String func,
    num a,
    num b, {
    double epsilon = 5e-9,
    double delta = 5e-9,
    int maxIters = 50,
  }) {
    double c;
    double fa;
    double fb;
    double fc;
    var counter = 0;
    var prev = 0.0;
    print('======================');
    print('Termination criterion 1: |f(Cn)| < epsilon $epsilon');
    print('Termination criterion 2: |Cn - C(n-1)| < delta $delta');

    print(
        '''Equation for c is : ci= bi - (f(bi) * (bi - ai)) / (f(bi) - f(ai))''');
    print('======================\n');

    do {
      fa = evaluate(func, a);
      fb = evaluate(func, b);

      if (!_areDifferentSigns(fa, fb)) break;

      c = b - (fb * (b - a)) / (fb - fa);
      fc = evaluate(func, c);

      if (fc == 0) {
        a = c;
        b = c;
      } else if (_areDifferentSigns(fa, fc)) {
        b = c;
      } else {
        if (_areDifferentSigns(fc, fb)) a = c;
      }
      print('===========');
      print('k: $counter');
      print('a$counter: $a');
      print('b$counter: $b');
      print('c$counter: $c');
      print('f(c$counter): $fc');
      print('===========\n');
      if (fc.abs() < epsilon) {
        print('Terminated because of 1');
        print('\nTerminated when k: $counter, |f(C$counter)| = $fc\n');
        return c;
      } else if ((c - prev).abs() < delta) {
        print('Terminated because of 2');
        print(
            '\nTerminated when k: $counter, |C$counter - C${counter - 1}| = ${c - prev}\n');
        return c;
      }

      prev = c;
    } while (counter++ < maxIters);

    return c;
  }

  static void newtonIteration(
    String func,
    num p0,
    num rootToFind, {
    int numberOfIterations = 10,
  }) {
    final derivative = derive(func);
    final derivativeAt = evaluate(derivative, rootToFind);
    print(derivative);
    print(derivativeAt);
    print('''p equation
pk = pk-1 - f(pk-1)
            --------
            f`(pk-1)
''');
    var prevp = p0;
    print('==================');
    print('k0');
    print('p0: $p0');
    print('E0: ${rootToFind - p0}');
    print('==================\n');
    for (var i = 1; i < numberOfIterations; ++i) {
      final p = prevp - evaluate(func, prevp) / evaluate(derivative, prevp);
      prevp = p;
      print('==================');
      print('k$i');
      print('p$i: $p');
      print('E$i: ${rootToFind - p}');
      print('==================\n');
    }
  }

  static void acceleratedNewtonIteration(
    String func,
    num p0,
    num M,
    num rootToFind, {
    int numberOfIterations = 10,
  }) {
    final derivative = derive(func);
    final derivativeAt = evaluate(derivative, rootToFind);
    print(derivative);
    print(derivativeAt);

    print('''
          p equation
          pk = pk-1 - M*f(pk-1)
                      --------
                      f`(pk-1)
    ''');
    var prevp = p0;
    print('==================');
    print('k0');
    print('p0: $p0');
    print('E0: ${rootToFind - p0}');
    print('==================\n');
    for (var i = 1; i < numberOfIterations; ++i) {
      final p =
          prevp - (M * evaluate(func, prevp)) / evaluate(derivative, prevp);
      prevp = p;
      print('==================');
      print('k$i');
      print('p$i: $p');
      print('E$i: ${rootToFind - p}');
      print('==================\n');
    }
  }

  static void secantMethod(
    String func,
    num p0,
    num p1,
    num rootToFind, {
    int numerOfIterations = 8,
  }) {
    final queue = Queue<num>();
    final fp = derive(func);
    final fpp = derive(fp);
    final A = pow(
        (evaluate(fpp, rootToFind) / (2 * evaluate(fp, rootToFind))).abs(),
        .618);
    print('A= $A');
    print('======Calculated from |f``(p)/2f`(p)|=========');
    print('#Note: ek+1 = |ek|^1.618 |f``(p)/2f`(p)|^.618');

    queue.addFirst(p0);
    queue.addLast(p1);

    print('p0: $p0, E0: ${rootToFind.abs() - p0.abs()}');
    print('p1: $p1, E1, ${rootToFind.abs() - p1.abs()}');
    for (var i = 2; i < numerOfIterations; ++i) {
      final prevp = queue.elementAt(i - 1);
      final prevprevp = queue.elementAt(i - 2);
      final numo = evaluate(func, prevp) * (prevp - prevprevp);
      final deno = evaluate(func, prevp) - evaluate(func, prevprevp);
      final p = prevp - numo / deno;
      final error = rootToFind.abs() - p.abs();

      print('p$i: $p, E$i = ${error.abs()}');
      if (error == 0) {
        return;
      }
      queue.addLast(p);
    }
  }
}
