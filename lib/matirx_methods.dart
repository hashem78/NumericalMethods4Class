import 'dart:io';

import 'functions.dart';

class MatrixMethods {
  static const menuItems = <String>[
    '1. Solve system using Gauss-Jordan elemination',
    '2. Solve system using Jacobi iteration',
    '3. Solve system using Gauss-Sidel itreation',
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
        GaussJordan.fromUser();
        break;
      case 2:
        jacobi();
        break;
      case 3:
        gaussseidel();
    }
  }

  static List<num> _requestRow(int rowNumber) {
    stdout.write(
        'Enter a list of 4 values for a,b,c,d in ax1+bx2+cx3=d for row$rowNumber: ');
    final ans = stdin.readLineSync().split(' ').map(num.parse).toList();
    ans.insert(0, 0);
    return ans;
  }

  static List<num> _seidelHelper(List<List<num>> matrix, List<num> point) {
    //final x1 = point[1];
    final x2 = point[2];
    final x3 = point[3];
    final a11 = matrix[1][1],
        a12 = matrix[1][2],
        a13 = matrix[1][3],
        b1 = matrix[1][4];
    final a21 = matrix[2][1],
        a22 = matrix[2][2],
        a23 = matrix[2][3],
        b2 = matrix[2][4];
    print('matrix[3] ${matrix[3]}');
    final a31 = matrix[3][1],
        a32 = matrix[3][2],
        a33 = matrix[3][3],
        b3 = matrix[3][4];
    final xx1 = (b1 - (a12 * x2) - (a13 * x3)) / (a11);
    final xx2 = (b2 - (a21 * xx1) - (a23 * x3)) / (a22);
    final xx3 = (b3 - (a31 * xx1) + (a32 * xx2)) / (a33);
    return [0, xx1, xx2, xx3];
  }

  static void gaussseidel() {
    final rows = [
      <num>[],
      _requestRow(1),
      _requestRow(2),
      _requestRow(3),
    ];
    stdout.write('Enter initial p1(x1,x2,x3): ');
    var p = stdin.readLineSync().split(' ').map(num.parse).toList();
    p.insert(0, 0);
    var counter = 0;

    while (true) {
      final newPoint = _seidelHelper(rows, p);
      final x1 = newPoint[1];
      final x2 = newPoint[2];
      final x3 = newPoint[3];
      print('x1$counter = $x1, x2$counter = $x2, x3$counter = $x3');
      print(newPoint);
      counter++;
      stdout.write('Press enter to do another round');
      stdin.readByteSync();
      p = newPoint;
    }
  }

  static void jacobi() {
    final rows = [
      <num>[],
      _requestRow(1),
      _requestRow(2),
      _requestRow(3),
    ];
    stdout.write('Enter initial p1(x1,x2,x3): ');
    var p = stdin.readLineSync().split(' ').map(num.parse).toList();
    p.insert(0, 0);
    var counter = 0;

    while (true) {
      final newPoint = _jacobiHelper(rows, p);
      final x1 = newPoint[1];
      final x2 = newPoint[2];
      final x3 = newPoint[3];
      print('x1$counter = $x1, x2$counter = $x2, x3$counter = $x3');
      print(newPoint);
      counter++;
      stdout.write('Press enter to do another round');
      stdin.readByteSync();
      p = newPoint;
    }
  }

  static List<num> _jacobiHelper(List<List<num>> matrix, List<num> point) {
    final x1 = point[1];
    final x2 = point[2];
    final x3 = point[3];
    final a11 = matrix[1][1],
        a12 = matrix[1][2],
        a13 = matrix[1][3],
        b1 = matrix[1][4];
    final a21 = matrix[2][1],
        a22 = matrix[2][2],
        a23 = matrix[2][3],
        b2 = matrix[2][4];
    print('matrix[3] ${matrix[3]}');
    final a31 = matrix[3][1],
        a32 = matrix[3][2],
        a33 = matrix[3][3],
        b3 = matrix[3][4];

    final xx1 = (b1 - (a12 * x2) - (a13 * x3)) / (a11);
    final xx2 = (b2 - (a21 * x1) - (a23 * x3)) / (a22);
    final xx3 = (b3 - (a31 * x1) + (a32 * x2)) / (a33);

    return [0, xx1, xx2, xx3];
  }
}
