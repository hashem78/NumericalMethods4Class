import 'dart:io';
import 'package:math_expressions/math_expressions.dart';

String requestMathExpressionFromUser() {
  return stdin.readLineSync();
}

String simplify(String func) {
  final p = Parser();
  final exp = p.parse(func);

  return exp.simplify().toString();
}

String derive(String func) {
  final p = Parser();
  final exp = p.parse(func);

  return exp.derive('x').simplify().toString();
}

dynamic evaluate(String func, num val, {String variable = 'x'}) {
  final p = Parser();
  final exp = p.parse(func);
  final cm = ContextModel();
  final x = Variable('x');

  cm.bindVariable(x, Number(val));
  return exp.evaluate(EvaluationType.REAL, cm);
}

String findLagrangePolynomial(String y, int N, List<num> xvals,
    {int precision = 6}) {
  var ans = '';
  // Evaluate xValues.
  final fxValues = xvals
      .map((x) =>
          double.parse((evaluate(y, x) as num).toStringAsFixed(precision)))
      .toList();

  final lnk = (int k, num fk) {
    var ans = fk;
    var finalLNK = '';
    for (var j = 0; j <= N; ++j) {
      if (j != k) {
        finalLNK += simplify('(x - ${xvals[j]})');
        ans = ans / (xvals[k] - xvals[j]);
      }
    }
    return '${ans.toStringAsFixed(precision)} * $finalLNK';
  };
  for (var k = 0; k <= N; ++k) {
    final yk = fxValues[k];
    final lnkExp = lnk(k, yk);
    if (lnkExp[0] == '-') {
      ans += lnkExp;
    } else {
      ans += ' + $lnkExp';
    }
  }
  ans = ans.trim();
  if (ans.lastIndexOf('+') == ans.length - 1) {
    return ans.substring(0, ans.lastIndexOf('+'));
  }
  return ans;
}

class GaussJordan {
  static List<List<double>> solve(List<List<double>> matrix,
      {bool supress = false}) {
    var lead = 0, rowCount = matrix.length, columnCount = matrix[1].length;
    for (var r = 0; r < rowCount; r++) {
      if (columnCount <= lead) break;
      var i = r;
      while (matrix[i][lead] == 0) {
        i++;
        if (i == rowCount) {
          i = r;
          lead++;
          if (columnCount == lead) {
            lead--;
            break;
          }
        }
      }
      for (var j = 0; j < columnCount; j++) {
        var temp = matrix[r][j];
        matrix[r][j] = matrix[i][j];
        matrix[i][j] = temp;
      }
      var div = matrix[r][lead];
      if (div != 0) {
        for (var j = 0; j < columnCount; j++) {
          matrix[r][j] /= div;
        }
      }
      for (var j = 0; j < rowCount; j++) {
        if (j != r) {
          var sub = matrix[j][lead];
          for (var k = 0; k < columnCount; k++) {
            matrix[j][k] -= (sub * matrix[r][k]);
          }
        }
      }
      lead++;
      if (!supress) {
        print('Matrix on iteration #$r');
        printMatrix(matrix);
      }
    }
    if (!supress) {
      print('');
    }
    return matrix;
  }

  static void fromUser() {
    stdout.write('Enter the number of rows: ');
    var rowSize = int.parse(stdin.readLineSync());
    var matrix = <List<double>>[];

    for (var i = 0; i < rowSize; i++) {
      var input = stdin.readLineSync();
      var rowString = input.split(' ');
      var rows = <double>[];
      rowString.forEach((r) {
        rows.add(double.parse(r));
      });
      matrix.add(rows);
    }

    var rref = GaussJordan.solve(matrix);

    print('========Final Matrix======');
    printMatrix(rref);
  }

  static void printMatrix(List<List<double>> matrix) {
    for (final x in matrix) {
      for (final y in x) {
        stdout.write('$y ');
      }
      print('');
    }
  }
}

Future<void> taylorSeries() async {
  await openUrl('https://tinyurl.com/yd66sxau');
}

Future<ProcessResult> openUrl(String url) {
  return Process.run(_command, [url], runInShell: true);
}

String get _command {
  if (Platform.isWindows) {
    return 'start';
  } else if (Platform.isLinux) {
    return 'xdg-open';
  } else if (Platform.isMacOS) {
    return 'open';
  } else {
    throw UnsupportedError('Operating system not supported by the open_url '
        'package: ${Platform.operatingSystem}');
  }
}

String requestFunction() {
  stdout.write('Enter a function: ');
  return stdin.readLineSync();
}

void printResult(dynamic val, {bool pause = false}) {
  if (!pause) {
    stdin.readByteSync();
  }

  clearConsole();
  print('\n=============Result=============');
  print(val);
  print('=============Result=============\n');
  stdin.readByteSync();
  clearConsole();
}

void clearConsole() {
  if (Platform.isWindows) {
    // not tested, I don't have Windows
    // may not to work because 'cls' is an internal command of the Windows shell
    // not an executeable
    print(Process.runSync('cls', [], runInShell: true).stdout);
  } else {
    print(Process.runSync('clear', [], runInShell: true).stdout);
  }
}

String prompt(String message) {
  stdout.write(message);
  return stdin.readLineSync();
}

double promptNum(String message) {
  stdout.write(message);
  return double.parse(stdin.readLineSync());
}
