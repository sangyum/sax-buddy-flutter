import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveformPlaceholder extends StatefulWidget {
  final bool isActive;

  const WaveformPlaceholder({
    super.key,
    required this.isActive,
  });

  @override
  State<WaveformPlaceholder> createState() => _WaveformPlaceholderState();
}

class _WaveformPlaceholderState extends State<WaveformPlaceholder>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<double> _heights = List.generate(20, (index) => 0.3);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    if (widget.isActive) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(WaveformPlaceholder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startAnimation();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAnimation();
    }
  }

  void _startAnimation() {
    _animationController.repeat();
    _animationController.addListener(() {
      setState(() {
        for (int i = 0; i < _heights.length; i++) {
          _heights[i] = 0.2 + math.Random().nextDouble() * 0.6;
        }
      });
    });
  }

  void _stopAnimation() {
    _animationController.stop();
    setState(() {
      for (int i = 0; i < _heights.length; i++) {
        _heights[i] = 0.1;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _heights.asMap().entries.map((entry) {
          final index = entry.key;
          final height = entry.value;
          final isActive = widget.isActive && index < (_heights.length * 0.6);
          
          return Container(
            width: 3,
            height: height * 40,
            decoration: BoxDecoration(
              color: isActive 
                  ? const Color(0xFF2E5266) 
                  : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }).toList(),
      ),
    );
  }
}