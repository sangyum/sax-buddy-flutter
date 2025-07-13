import 'package:flutter/material.dart';
import '../../practice/models/practice_routine.dart';
import 'notation_view.dart';

/// Card widget that displays a practice exercise with optional notation
class ExerciseNotationCard extends StatefulWidget {
  final PracticeExercise exercise;
  final bool showNotationByDefault;
  final VoidCallback? onTap;

  const ExerciseNotationCard({
    super.key,
    required this.exercise,
    this.showNotationByDefault = false,
    this.onTap,
  });

  @override
  State<ExerciseNotationCard> createState() => _ExerciseNotationCardState();
}

class _ExerciseNotationCardState extends State<ExerciseNotationCard> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.showNotationByDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.exercise.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Duration badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.exercise.estimatedDuration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Exercise details (tempo, key signature)
              if (widget.exercise.tempo != null || widget.exercise.keySignature != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      if (widget.exercise.tempo != null) ...[
                        Icon(
                          Icons.speed,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.exercise.tempo!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      if (widget.exercise.tempo != null && widget.exercise.keySignature != null)
                        const SizedBox(width: 16),
                      if (widget.exercise.keySignature != null) ...[
                        Icon(
                          Icons.music_note,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.exercise.keySignature!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              // Always show notation toggle button
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isExpanded ? 'Hide etude' : 'Show etude',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable notation view (always show when expanded)
              if (_isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildNotationView(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build notation view using etude data
  Widget _buildNotationView() {
    if (widget.exercise.etude == null) {
      return NotationView(
        measures: null,
        height: 200, // Increased height for consistency
      );
    }

    return NotationView(
      measures: widget.exercise.etude,
      height: 200, // Increased height for better readability
      tempo: 120, // Default tempo since we don't store it in Measure objects
      title: widget.exercise.name,
    );
  }
}