import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Científica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101014),
      ),
      home: const CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String visor = '0';
  double? primeiroNumero;
  String? operacao;
  bool iniciarNovoNumero = false;

  final List<List<String>> linhas = const [
    ['AC', '⌫', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
    ['1', '2', '3', '+'],
    ['√', '0', '.', '^'],
    ['±', '00', '='],
  ];

  double? get numeroAtual => double.tryParse(visor);

  String formatar(double valor) {
    if (!valor.isFinite) return 'Erro';
    if (valor.abs() < 1e-10) valor = 0;
    if (valor == valor.truncateToDouble()) return valor.toInt().toString();
    return valor.toStringAsPrecision(10).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void pressionar(String tecla) {
    setState(() {
      if (tecla == 'AC') {
        limpar();
      } else if (tecla == '⌫') {
        if (iniciarNovoNumero || visor == 'Erro') {
          visor = '0';
          iniciarNovoNumero = false;
        } else if (visor.length > 1) {
          visor = visor.substring(0, visor.length - 1);
          if (visor == '-') visor = '0';
        } else {
          visor = '0';
        }
      } else if (tecla == '.') {
        if (iniciarNovoNumero || visor == 'Erro') {
          visor = '0.';
          iniciarNovoNumero = false;
        } else if (!visor.contains('.')) {
          visor += '.';
        }
      } else if (_ehDigito(tecla)) {
        if (iniciarNovoNumero || visor == 'Erro') {
          visor = tecla == '00' ? '0' : tecla;
          iniciarNovoNumero = false;
        } else if (tecla == '00' && visor == '0') {
          // Mantém zero à esquerda sem criar "000".
          visor = '0';
        } else if (visor == '0') {
          visor = tecla;
        } else {
          visor += tecla;
        }
      } else if (tecla == '√') {
        final valor = numeroAtual;
        if (valor == null || valor < 0) {
          _erro('Não existe raiz real de número negativo.');
        } else {
          visor = formatar(math.sqrt(valor));
          iniciarNovoNumero = true;
        }
      } else if (tecla == '%') {
        final valor = numeroAtual;
        if (valor == null) {
          _erro('Número inválido.');
        } else {
          visor = formatar(valor / 100);
          iniciarNovoNumero = true;
        }
      } else if (tecla == '±') {
        final valor = numeroAtual;
        if (valor != null && valor != 0) visor = formatar(-valor);
      } else if (['+', '−', '×', '÷', '^'].contains(tecla)) {
        final valor = numeroAtual;
        if (valor == null) {
          _erro('Digite um número válido.');
        } else {
          primeiroNumero = valor;
          operacao = tecla;
          iniciarNovoNumero = true;
        }
      } else if (tecla == '=') {
        calcular();
      }
    });
  }

  bool _ehDigito(String tecla) =>
      RegExp(r'^\d+$').hasMatch(tecla);

  void limpar() {
    visor = '0';
    primeiroNumero = null;
    operacao = null;
    iniciarNovoNumero = false;
  }

  void _erro(String mensagem) {
    visor = 'Erro';
    primeiroNumero = null;
    operacao = null;
    iniciarNovoNumero = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(mensagem)));
    });
  }

  void calcular() {
    final a = primeiroNumero;
    final b = numeroAtual;
    final op = operacao;

    if (a == null || b == null || op == null) return;

    double resultado;
    switch (op) {
      case '+':
        resultado = a + b;
        break;
      case '−':
        resultado = a - b;
        break;
      case '×':
        resultado = a * b;
        break;
      case '÷':
        if (b == 0) {
          _erro('Não é possível dividir por zero.');
          return;
        }
        resultado = a / b;
        break;
      case '^':
        resultado = math.pow(a, b).toDouble();
        break;
      default:
        return;
    }

    if (!resultado.isFinite) {
      _erro('O resultado não é um número válido.');
      return;
    }

    visor = formatar(resultado);
    primeiroNumero = null;
    operacao = null;
    iniciarNovoNumero = true;
  }

  Color _corBotao(String texto) {
    if (texto == '=') return const Color(0xFF8B5CF6);
    if (['AC', '⌫'].contains(texto)) return const Color(0xFF63343B);
    if (['%', '÷', '×', '−', '+', '^', '√', '±'].contains(texto)) {
      return const Color(0xFF30264A);
    }
    return const Color(0xFF202027);
  }

  Widget _botao(String texto) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 62,
          child: ElevatedButton(
            onPressed: () => pressionar(texto),
            style: ElevatedButton.styleFrom(
              backgroundColor: _corBotao(texto),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                texto,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora Científica',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF101014),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF18181F),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          visor,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: visor.length > 16 ? 30 : 44,
                            fontWeight: FontWeight.w300,
                            color: visor == 'Erro'
                                ? const Color(0xFFFF8A8A)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: linhas
                          .map((linha) => Expanded(
                                child: Row(
                                  children: linha.map(_botao).toList(),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Operações: +  −  ×  ÷  √  potência  %',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
