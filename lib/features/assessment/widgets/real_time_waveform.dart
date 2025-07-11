import 'package:flutter/material.dart';
import 'dart:async';

class RealTimeWaveform extends StatefulWidget {
  final Stream<List<double>> waveformStream;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;
  final int barCount;
  final double height;

  const RealTimeWaveform({
    super.key,
    required this.waveformStream,
    required this.isActive,
    this.activeColor,
    this.inactiveColor,
    this.barCount = 20,
    this.height = 40,
  });

  @override
  State<RealTimeWaveform> createState() => _RealTimeWaveformState();
}

class _RealTimeWaveformState extends State<RealTimeWaveform> {
  StreamSubscription<List<double>>? _waveformSubscription;
  List<double> _waveformData = [];
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    _initializeWaveform();
  }

  @override
  void didUpdateWidget(RealTimeWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      _initializeWaveform();
    }
  }

  void _initializeWaveform() {
    // Cancel existing subscription
    _waveformSubscription?.cancel();

    if (widget.isActive) {
      // Subscribe to real-time waveform data
      _waveformSubscription = widget.waveformStream.listen(
        (waveformData) {
          if (mounted) {
            setState(() {
              _waveformData = waveformData;
              _hasData = waveformData.isNotEmpty;
            });
          }
        },
        onError: (error) {
          debugPrint('Waveform stream error: $error');
        },
      );
    } else {
      // Reset to inactive state
      setState(() {
        _waveformData = [];
        _hasData = false;
      });
    }
  }

  List<double> _processWaveformData() {
    if (!_hasData || _waveformData.isEmpty) {
      // Return flat line when no data
      return List.filled(widget.barCount, 0.1);
    }

    // If we have fewer data points than bars, repeat the pattern
    if (_waveformData.length < widget.barCount) {
      final List<double> processed = [];
      for (int i = 0; i < widget.barCount; i++) {
        processed.add(_waveformData[i % _waveformData.length]);
      }
      return processed;
    }

    // If we have more data points than bars, downsample
    if (_waveformData.length > widget.barCount) {
      final List<double> processed = [];
      final step = _waveformData.length / widget.barCount;

      for (int i = 0; i < widget.barCount; i++) {
        final startIndex = (i * step).floor();
        final endIndex = ((i + 1) * step).floor().clamp(
          0,
          _waveformData.length,
        );

        // Average the values in this range
        double sum = 0;
        int count = 0;
        for (int j = startIndex; j < endIndex; j++) {
          sum += _waveformData[j].abs(); // Use absolute value for amplitude
          count++;
        }

        processed.add(count > 0 ? sum / count : 0.1);
      }

      return processed;
    }

    // Return data as-is if it matches our bar count
    return _waveformData.map((value) => value.abs()).toList();
  }

  @override
  void dispose() {
    _waveformSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final processedData = _processWaveformData();
    final activeColor = widget.activeColor ?? const Color(0xFF2E5266);
    final inactiveColor = widget.inactiveColor ?? const Color(0xFFE0E0E0);

    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: processedData.map((amplitude) {
          // Normalize amplitude to 0.1 - 1.0 range
          final normalizedHeight = (amplitude * 0.9 + 0.1).clamp(0.1, 1.0);

          // Determine if this bar should be active
          final isActive = widget.isActive && _hasData;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            width: 3,
            height: normalizedHeight * widget.height,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
