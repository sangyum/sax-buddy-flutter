import 'package:flutter/material.dart';
import 'package:simple_sheet_music/simple_sheet_music.dart';

/// Widget for displaying sheet music notation
class NotationView extends StatelessWidget {
  final List<Measure>? measures;
  final bool isLoading;
  final double? height;
  final double? width;
  final String? title;
  final int? tempo;

  const NotationView({
    super.key,
    this.measures,
    this.isLoading = false,
    this.height,
    this.width,
    this.title,
    this.tempo,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: height ?? 200,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (measures == null || measures!.isEmpty) {
      return _EmptyNotation(height: height, width: width);
    }

    return Container(
      height: height ?? 200,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and tempo (only show if height is sufficient)
            if (height == null || height! >= 150) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title ?? 'Musical Exercise',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '♩ = ${tempo ?? 120}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Sheet music rendering area
            Expanded(child: _buildSheetMusic()),
          ],
        ),
      ),
    );
  }

  /// Build the actual sheet music widget or fallback
  Widget _buildSheetMusic() {
    try {
      // Enable horizontal scrolling for sheet music
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SimpleSheetMusic(
          height: height ?? 200,
          measures: measures!,
        ),
      );
    } catch (e) {
      return _FallbackDisplay(
        message: 'Error rendering notation: ${e.toString()}',
        height: height,
      );
    }
  }
}

/// Widget displayed when no notation data is available
class _EmptyNotation extends StatelessWidget {
  final double? height;
  final double? width;

  const _EmptyNotation({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'No notation available',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget displayed when there's an error rendering notation
class _FallbackDisplay extends StatelessWidget {
  final String message;
  final double? height;

  const _FallbackDisplay({required this.message, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.shade50,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                style: TextStyle(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
