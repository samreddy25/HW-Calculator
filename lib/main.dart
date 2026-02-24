import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // THEME
  bool isDark = true;

  // CALC STATE
  String display = "0";
  double? firstNumber;
  String operator = "";
  bool shouldClear = false;

  // ---- COLORS (match your screenshot style) ----
  Color get bg => isDark ? const Color(0xFF1F2432) : const Color(0xFFF3F4F8);
  Color get card => isDark ? const Color(0xFF252B3B) : Colors.white;
  Color get displayBg => isDark ? const Color(0xFF151A25) : const Color(0xFFE9EBF3);
  Color get numBtn => isDark ? const Color(0xFF2E3445) : const Color(0xFFF0F2F8);
  Color get opBtn => const Color(0xFF8E7CFF);
  Color get textColor => isDark ? Colors.white : const Color(0xFF1B1E2A);
  Color get displayColor => isDark ? Colors.greenAccent : const Color(0xFF1A8F4A);

  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        display = "0";
        firstNumber = null;
        operator = "";
        shouldClear = false;
        return;
      }

      // optional: quick +/- and % (basic)
      if (value == "±") {
        if (display != "0" && display != "Error") {
          if (display.startsWith("-")) {
            display = display.substring(1);
          } else {
            display = "-$display";
          }
        }
        return;
      }

      if (value == "%") {
        if (display != "Error") {
          final d = double.tryParse(display) ?? 0;
          display = _fmt(d / 100);
        }
        return;
      }

      if (value == "+" || value == "-" || value == "×" || value == "÷") {
        if (display == "Error") return;
        firstNumber = double.tryParse(display) ?? 0;
        operator = value;
        shouldClear = true;
        return;
      }

      if (value == "=") {
        if (display == "Error") return;
        if (firstNumber == null || operator.isEmpty) return;

        final secondNumber = double.tryParse(display) ?? 0;
        double result = 0;

        if (operator == "+") result = firstNumber! + secondNumber;
        if (operator == "-") result = firstNumber! - secondNumber;
        if (operator == "×") result = firstNumber! * secondNumber;
        if (operator == "÷") {
          if (secondNumber == 0) {
            display = "Error";
            return;
          }
          result = firstNumber! / secondNumber;
        }

        display = _fmt(result);
        firstNumber = null;
        operator = "";
        shouldClear = true;
        return;
      }

      // digits or decimal
      if (value == ".") {
        if (shouldClear) {
          display = "0.";
          shouldClear = false;
          return;
        }
        if (!display.contains(".")) {
          display += ".";
        }
        return;
      }

      // number pressed
      if (display == "0" || shouldClear) {
        display = value;
        shouldClear = false;
      } else {
        display += value;
      }
    });
  }

  String _fmt(double v) {
    // remove trailing .0
    final s = v.toString();
    if (s.endsWith(".0")) return s.substring(0, s.length - 2);
    return s;
  }

  Widget buildButton(String text, {bool isOperator = false}) {
    final bgColor = isOperator ? opBtn : numBtn;
    final fgColor = isOperator ? Colors.white : textColor;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => buttonPressed(text),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.12),
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: fgColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          "Calculator",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            tooltip: isDark ? "Switch to Light" : "Switch to Dark",
            onPressed: () => setState(() => isDark = !isDark),
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: textColor),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 330,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.55 : 0.15),
                blurRadius: 18,
                offset: const Offset(5, 10),
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 100,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: displayBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  display,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 38,
                    color: displayColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: [
                    buildButton("C", isOperator: true),
                    buildButton("±", isOperator: true),
                    buildButton("%", isOperator: true),
                    buildButton("÷", isOperator: true),
                    buildButton("7"),
                    buildButton("8"),
                    buildButton("9"),
                    buildButton("×", isOperator: true),
                    buildButton("4"),
                    buildButton("5"),
                    buildButton("6"),
                    buildButton("-", isOperator: true),
                    buildButton("1"),
                    buildButton("2"),
                    buildButton("3"),
                    buildButton("+", isOperator: true),
                    buildButton("0"),
                    buildButton("."),
                    buildButton("=", isOperator: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}