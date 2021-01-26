import 'dart:io';

import 'dart:math';

import 'package:acm/functions.dart';

class DataLinearization {
  static const menuItems = <String>[
    '1. Functions of the form y = Ce^(Ax)',
    '2. Functions of the form y = A/x + B',
    '3. Functions of the form y = Cxe^-Dx',
    '0. Exit',
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
        exponential();
        break;
      case 2:
        squareRoot();
        break;
      case 3:
        cxe();
        break;
    }
  }

  static void cxe() {
    final transform = (double number) {
      return sqrt(number);
    };
    final userSums =
        prompt('Do you want to use ready sums?(y/n): ').contains('y')
            ? true
            : false;
    double sx;
    double sy;
    double sx2;
    double sxy;
    List<double> xvals;
    List<double> yvals;
    List<double> transformedYvals;
    double n;

    if (!userSums) {
      xvals = prompt('Enter a list of x values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      yvals = prompt('Enter a list of y values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      print('N (number of points): ${xvals.length}');
      if (xvals.length != yvals.length) {
        print('XY length different');

        return;
      }
      final yoverx = <double>[];
      for (var i = 0; i < xvals.length; ++i) {
        yoverx.add(yvals[i] / xvals[i]);
      }
      transformedYvals = yoverx.map(transform).toList();
      sx = CurveFitting._sum(xvals);
      sy = CurveFitting._sum(transformedYvals);
      sx2 = CurveFitting._sum(xvals, power: 2);
      sxy = CurveFitting._sumxy(xvals, transformedYvals);
    } else {
      sx = promptNum('Enter sum of x: ');
      sy = promptNum('Enter sum of ln(y/x): ');
      sx2 = promptNum('Enter sum of x^2: ');
      sxy = promptNum('Enter sum of xy: ');

      n = promptNum('Enter the number of data points(N): ');
    }
    final matrix = GaussJordan.solve(
      [
        [sx, xvals == null ? n : xvals.length.toDouble(), sy],
        [sx2, sx, sxy],
      ],
    );
    final transformedA = matrix[0][2];
    final transformedB = matrix[1][2];
    final c = exp(transformedB);
    final d = -transformedA;

    print('A = $transformedA');
    print('B = $transformedB');
    print('C = $c');
    print('D = $d');

    print('The equation is:  Y = ${-d}X + ${log(c)}');
    stdin.readByteSync();
  }

  static void squareRoot() {
    final transform = (double number) {
      return sqrt(number);
    };
    final userSums =
        prompt('Do you want to use ready sums?(y/n): ').contains('y')
            ? true
            : false;
    double sx;
    double sy;
    double sx2;
    double sxy;
    List<double> xvals;
    List<double> yvals;
    List<double> transformedYvals;
    double n;

    if (!userSums) {
      xvals = prompt('Enter a list of x values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      yvals = prompt('Enter a list of y values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      print('N (number of points): ${xvals.length}');
      if (xvals.length != yvals.length) {
        print('XY length different');

        return;
      }
      transformedYvals = yvals.map(transform).toList();
      sx = CurveFitting._sum(xvals);
      sy = CurveFitting._sum(transformedYvals);
      sx2 = CurveFitting._sum(xvals, power: 2);
      sxy = CurveFitting._sumxy(xvals, transformedYvals);
    } else {
      sx = promptNum('Enter sum of x: ');
      sy = promptNum('Enter sum of sqrt(y): ');
      sx2 = promptNum('Enter sum of x^2: ');
      sxy = promptNum('Enter sum of xy: ');

      n = promptNum('Enter the number of data points(N): ');
    }
    final matrix = GaussJordan.solve(
      [
        [sx, xvals == null ? n : xvals.length.toDouble(), sy],
        [sx2, sx, sxy],
      ],
    );
    final transformedA = matrix[0][2];
    final transformedB = matrix[1][2];

    print('A = $transformedA');
    print('B = $transformedB');

    print('The equation is: y = $transformedA x +  $transformedB');
    stdin.readByteSync();
  }

  static void exponential() {
    final transform = (double number) {
      return log(number);
    };
    final userSums =
        prompt('Do you want to use ready sums?(y/n): ').contains('y')
            ? true
            : false;
    double sx;
    double sy;
    double sx2;
    double sxy;
    List<double> xvals;
    List<double> yvals;
    List<double> transformedYvals;
    double n;

    if (!userSums) {
      xvals = prompt('Enter a list of x values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      yvals = prompt('Enter a list of y values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      print('N (number of points): ${xvals.length}');
      if (xvals.length != yvals.length) {
        print('XY length different');

        return;
      }
      transformedYvals = yvals.map(transform).toList();
      sx = CurveFitting._sum(xvals);
      sy = CurveFitting._sum(transformedYvals);
      sx2 = CurveFitting._sum(xvals, power: 2);
      sxy = CurveFitting._sumxy(xvals, transformedYvals);
    } else {
      sx = promptNum('Enter sum of x: ');
      sy = promptNum('Enter sum of ln(y): ');
      sx2 = promptNum('Enter sum of x^2: ');
      sxy = promptNum('Enter sum of xln(y): ');
      n = promptNum('Enter the number of data points(N): ');
    }
    final matrix = GaussJordan.solve(
      [
        [sx, xvals == null ? n : xvals.length.toDouble(), sy],
        [sx2, sx, sxy],
      ],
    );
    final transformedA = matrix[0][2];
    final transformedB = matrix[1][2];
    final transformedC = exp(transformedB);
    print('A = $transformedA');
    print('B = $transformedB');
    print('C = $transformedC');

    print('transorming back using: C=e^B');
    print('The equation is: y = $transformedC e^($transformedA)');
    stdin.readByteSync();
  }
}

class CurveFitting {
  static void lineFitUser() {
    final ans = prompt('Do you want to use ready sums?(y/n): ').contains('y')
        ? true
        : false;
    double sx;
    double sy;
    double sx2;
    double sxy;
    double n;
    List<double> xvals;
    List<double> yvals;

    if (ans) {
      xvals = prompt('Enter a list of x values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      yvals = prompt('Enter a list of y values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      print('N (number of points): ${xvals.length}');
      if (xvals.length != yvals.length) {
        print('XY length different');

        return;
      }
      sx = _sum(xvals);
      sy = _sum(yvals);
      sx2 = _sum(xvals, power: 2);
      sxy = _sumxy(xvals, yvals);
    } else {
      sx = promptNum('Enter sum of x: ');
      sy = promptNum('Enter sum of y: ');
      sx2 = promptNum('Enter sum of x^2: ');
      sxy = promptNum('Enter sum of xy: ');
      n = promptNum('Enter the number of data points(N): ');
    }

    print('sum of x vals: $sx');
    print('sum of y vals: $sy');
    print('sum of x^2 vals: $sx2');
    print('sum of x*y vals: $sxy');

    print('''Using the equations:
    (SUM(K=1 to N) (Xk)^2) * A + (SUM(K=1 to N) (Xk))*B = (SUM(K=1 to N) (Xk*Yk))
    (SUM(K=1 to N) (Xk)) * A + N*B = (SUM(K=1 to N) (Yk))
    ''');
    final matrix = GaussJordan.solve(
      [
        [sx, xvals == null ? n : xvals.length.toDouble(), sy],
        [sx2, sx, sxy],
      ],
    );
    print('A = ${matrix[0][2]}');
    print('B = ${matrix[1][2]}');
    print('The equation is: y = ${matrix[0][2]}x + ${matrix[1][2]}');
    stdin.readByteSync();
  }

  static double _sum(List<double> values, {double power = 1}) {
    var sum = 0.0;
    for (var i = 0; i < values.length; ++i) {
      sum += pow(values[i], power);
    }
    return sum;
  }

  static double _sumxy(List<double> xvals, List<double> yvals) {
    var sum = 0.0;
    for (var i = 0; i < xvals.length; ++i) {
      sum += xvals[i] * yvals[i];
    }
    return sum;
  }

  static double _sumxMy(List<double> xvals, List<double> yvals, double m) {
    var sum = 0.0;
    for (var i = 0; i < xvals.length; ++i) {
      sum += pow(xvals[i], m) * yvals[i];
    }
    return sum;
  }

  static void powerFit() {
    List<double> xvals;
    List<double> yvals;
    double sx2m;
    double sxmy;
    double a;
    final sums = prompt('Use ready sums?(y/n) : ').contains('y') ? true : false;

    if (!sums) {
      xvals = prompt('Enter a list of x values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      yvals = prompt('Enter a list of y values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      print('N (number of points): ${xvals.length}');
      if (xvals.length != yvals.length) {
        print('XY length different');

        return;
      }
    }
    final m =
        promptNum('Enter a M(highest polynomial power in equation given): ');

    if (sums) {
      sx2m = _sum(xvals, power: 2 * m);
      sxmy = _sumxMy(xvals, yvals, m);
      print('sum of x^(2M): $sx2m');
      print('sum of x^(M) * Y: $sxmy');
      a = sxmy / sx2m;
    } else {
      sx2m = promptNum('Enter sum of x^(2M): ');
      sxmy = promptNum('Enter sum of xy: ');
    }
    print('A = $a');
    print('The equation is: y=$a x^($m)');
    stdin.readByteSync();
  }

  static void parabola() {
    final sums = prompt('Use ready sums?(y/n) : ').contains('y') ? true : false;
    List<double> xvals;
    List<double> yvals;
    double _sx4;
    double _sx3;
    double _sx2;
    double _sx;
    double _sx2y;
    double _sxy;
    double _sy;
    double n;

    if (!sums) {
      xvals = prompt('Enter a list of x values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      yvals = prompt('Enter a list of y values: : ')
          .split(' ')
          .map(double.parse)
          .toList();
      print('N (number of points): ${xvals.length}');
      _sx4 = _sum(xvals, power: 4);
      _sx3 = _sum(xvals, power: 3);
      _sx2 = _sum(xvals, power: 2);
      _sx = _sum(xvals);
      _sx2y = _sumxMy(xvals, yvals, 2);
      _sxy = _sumxMy(xvals, yvals, 1);
      _sy = _sum(yvals);
      if (xvals.length != yvals.length) {
        print('XY length different');

        return;
      }
    } else {
      _sx4 = promptNum('Enter sum of x^4: ');
      _sx3 = promptNum('Enter sum of x^3: ');
      _sx2 = promptNum('Enter sum of x^2: ');
      _sx = promptNum('Enter sum of x: ');
      _sx2y = promptNum('Enter sum of x^(2)y: ');
      _sxy = promptNum('Enter sum of x*y: ');
      _sy = promptNum('Enter sum of y: ');
      n = promptNum('Enter number of data points (N): ');
    }

    final matrix = GaussJordan.solve(
      [
        [_sx4, _sx3, _sx2, _sx2y],
        [_sx3, _sx2, _sx, _sxy],
        [_sx2, _sx, xvals == null ? n : xvals.length.toDouble(), _sy]
      ],
      supress: true,
    );
    print('A = ${matrix[0][3]}, B = ${matrix[1][3]}, C = ${matrix[2][3]}');
    print(
        'Equation is: ${matrix[0][3]}x^2 + ${matrix[1][3]}x + ${matrix[2][3]}');
    stdin.readByteSync();
  }

  static const menuItems = <String>[
    '1. Line fit',
    '2. Power fit',
    '3. Polynomial fit (least square parabola)',
    '4. Data linearization',
    '0. Exit',
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
        lineFitUser();
        break;
      case 2:
        powerFit();
        break;
      case 3:
        parabola();
        break;
      case 4:
        DataLinearization.menu();
    }
  }
}
