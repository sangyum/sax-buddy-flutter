import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

/// Widget for displaying sheet music notation using OSMD
class NotationView extends StatefulWidget {
  final String? musicXML;
  final bool isLoading;
  final String? title;
  final int? tempo;

  const NotationView({
    super.key,
    this.musicXML,
    this.isLoading = false,
    this.title,
    this.tempo,
  });

  @override
  State<NotationView> createState() => _NotationViewState();
}

class _NotationViewState extends State<NotationView> {
  late final WebViewController _controller;
  bool _isWebViewReady = false;
  bool _hasLoadedContent = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        'onViewerReady',
        onMessageReceived: (JavaScriptMessage message) {
          setState(() {
            _isWebViewReady = true;
          });
          _loadNotationIfReady();
        },
      )
      ..addJavaScriptChannel(
        'onNotationLoaded',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle successful notation loading
          debugPrint('Notation loaded successfully');
        },
      )
      ..addJavaScriptChannel(
        'onNotationError',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle notation loading errors
          debugPrint('Notation error: ${message.message}');
        },
      )
      ..loadFlutterAsset('assets/osmd_viewer.html');
  }

  void _loadNotationIfReady() {
    if (_isWebViewReady && !_hasLoadedContent) {
      _loadNotation();
    }
  }

  Future<void> _loadNotation() async {
    if (widget.isLoading) {
      await _controller.runJavaScript('showLoading();');
      return;
    }

    if (widget.musicXML == null || widget.musicXML!.isEmpty) {
      await _controller.runJavaScript('showEmpty();');
      return;
    }

    try {
      final title = widget.title ?? 'Musical Exercise';
      final tempo = widget.tempo ?? 120;
      
      // Escape the MusicXML for JavaScript
      final escapedXML = jsonEncode(widget.musicXML!);
      
      await _controller.runJavaScript('''
        loadMusicXML($escapedXML, "$title", $tempo);
      ''');
      
      setState(() {
        _hasLoadedContent = true;
      });
    } catch (e) {
      debugPrint('Error loading notation: $e');
      await _controller.runJavaScript('showError("Failed to load notation");');
    }
  }

  @override
  void didUpdateWidget(NotationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reload notation if content changed
    if (oldWidget.musicXML != widget.musicXML ||
        oldWidget.title != widget.title ||
        oldWidget.tempo != widget.tempo ||
        oldWidget.isLoading != widget.isLoading) {
      _hasLoadedContent = false;
      _loadNotationIfReady();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 400, // Fixed height for consistent layout
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }

}
