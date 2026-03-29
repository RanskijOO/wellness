import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';

bool shouldShowWebViewErrorOverlay(bool? isForMainFrame) =>
    isForMainFrame ?? true;

class ProductWebviewScreen extends ConsumerStatefulWidget {
  const ProductWebviewScreen({
    required this.title,
    required this.url,
    super.key,
  });

  final String title;
  final String url;

  @override
  ConsumerState<ProductWebviewScreen> createState() =>
      _ProductWebviewScreenState();
}

class _ProductWebviewScreenState extends ConsumerState<ProductWebviewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  bool _canGoBack = false;
  bool _canGoForward = false;
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
          onPageFinished: (_) async {
            if (!mounted) {
              return;
            }
            setState(() => _isLoading = false);
            await _refreshNavigationState();
          },
          onWebResourceError: (WebResourceError error) {
            if (!shouldShowWebViewErrorOverlay(error.isForMainFrame)) {
              return;
            }
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(_targetUri!);
  }

  Future<void> _refreshNavigationState() async {
    final WebViewController? controller = _controller;
    if (controller == null || !mounted) {
      return;
    }

    final bool canBack = await controller.canGoBack();
    final bool canForward = await controller.canGoForward();

    if (!mounted) {
      return;
    }

    setState(() {
      _canGoBack = canBack;
      _canGoForward = canForward;
    });
  }

  Future<void> _openInBrowser() async {
    try {
      await ref.read(appServicesProvider).externalLinks.open(widget.url);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не вдалося відкрити сторінку у зовнішньому браузері.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            tooltip: 'Назад',
            onPressed: _canGoBack
                ? () async {
                    await _controller?.goBack();
                    await _refreshNavigationState();
                  }
                : null,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          IconButton(
            tooltip: 'Вперед',
            onPressed: _canGoForward
                ? () async {
                    await _controller?.goForward();
                    await _refreshNavigationState();
                  }
                : null,
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          IconButton(
            tooltip: 'Оновити',
            onPressed: _controller == null
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await _controller?.reload();
                  },
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Відкрити в браузері',
            onPressed: widget.url.isEmpty ? null : _openInBrowser,
            icon: const Icon(Icons.open_in_browser_rounded),
          ),
        ],
      ),
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
                            FilledButton.tonal(
                              onPressed: widget.url.isEmpty
                                  ? null
                                  : _openInBrowser,
                              child: const Text('Відкрити в браузері'),
                            ),
                            const SizedBox(height: AloeSpacing.sm),
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
