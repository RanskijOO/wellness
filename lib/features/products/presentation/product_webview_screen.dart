import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';

class ProductWebviewScreen extends StatefulWidget {
  const ProductWebviewScreen({
    required this.title,
    required this.url,
    super.key,
  });

  final String title;
  final String url;

  @override
  State<ProductWebviewScreen> createState() => _ProductWebviewScreenState();
}

class _ProductWebviewScreenState extends State<ProductWebviewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  Uri? _targetUri;

  @override
  void initState() {
    super.initState();
    _targetUri = Uri.tryParse(widget.url);
    if (_targetUri == null || !_targetUri!.hasScheme) {
      _hasError = true;
      _isLoading = false;
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _hasError = false;
          }),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() {
            _isLoading = false;
            _hasError = true;
          }),
        ),
      )
      ..loadRequest(_targetUri!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: widget.url.isEmpty || _controller == null
          ? const AloePageBackground(
              child: Center(
                child: Text('Немає коректного посилання для відкриття.'),
              ),
            )
          : Stack(
              children: <Widget>[
                WebViewWidget(controller: _controller!),
                if (_isLoading)
                  const AloePageBackground(
                    child: LoadingStateView(label: 'Відкриваємо сторінку...'),
                  ),
                if (_hasError)
                  AloePageBackground(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AloeSpacing.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const AloeIconBadge(
                              icon: Icons.wifi_off_rounded,
                              size: 72,
                              circular: true,
                            ),
                            const SizedBox(height: AloeSpacing.lg),
                            const Text(
                              'Не вдалося завантажити сторінку магазину.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AloeSpacing.lg),
                            FilledButton(
                              onPressed: () {
                                if (_targetUri != null) {
                                  setState(() {
                                    _hasError = false;
                                    _isLoading = true;
                                  });
                                  _controller!.loadRequest(_targetUri!);
                                }
                              },
                              child: const Text('Спробувати ще раз'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
