import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF090814),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF090814),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProfitCalculator78App());
}

class ProfitCalculator78App extends StatelessWidget {
  const ProfitCalculator78App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '78 Profit Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090814),
      ),
      home: const CalculatorWebViewScreen(),
    );
  }
}

class CalculatorWebViewScreen extends StatefulWidget {
  const CalculatorWebViewScreen({super.key});

  @override
  State<CalculatorWebViewScreen> createState() => _CalculatorWebViewScreenState();
}

class _CalculatorWebViewScreenState extends State<CalculatorWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF090814))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        ),
      )
      ..loadFlutterAsset('assets/78_profit_calculator.html');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          await _controller.goBack();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF090814),
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF9333EA),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
