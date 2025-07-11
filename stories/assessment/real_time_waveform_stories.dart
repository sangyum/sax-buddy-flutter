import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sax_buddy/features/assessment/widgets/real_time_waveform.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

double doubleInRange(Random source, num start, num end) =>
    source.nextDouble() * (end - start) + start;

List<double> generateListOfDoubles(int count) {
  final random = Random(DateTime.now().millisecond);
  final List<double> doubles = [];
  for (var i = 0; i < count; i++) {
    doubles.add(doubleInRange(random, 1.0, 10.0));
  }

  return doubles;
}

Stream<List<double>> streamFunc() async* {
  yield generateListOfDoubles(30);
  yield generateListOfDoubles(30);
  yield generateListOfDoubles(30);
  yield generateListOfDoubles(30);
  yield generateListOfDoubles(30);
  yield generateListOfDoubles(30);
  yield generateListOfDoubles(30);
  yield generateListOfDoubles(30);
  yield generateListOfDoubles(30);
}

final realTimeWaveformStories = [
  Story(
    name: 'Real Time Waveform/Active',
    builder: (context) => RealTimeWaveform(
      waveformStream: streamFunc(),
      isActive: true,
      activeColor: Colors.blue,
      inactiveColor: Colors.grey,
    ),
  ),
  Story(
    name: 'Real Time Waveform/Inactive',
    builder: (context) => RealTimeWaveform(
      waveformStream: streamFunc(),
      isActive: false,
      activeColor: Colors.blue,
      inactiveColor: Colors.grey,
    ),
  ),
  Story(
    name: 'Real Time Waveform/Custom Colors',
    builder: (context) => RealTimeWaveform(
      waveformStream: streamFunc(),
      isActive: true,
      activeColor: Colors.green,
      inactiveColor: Colors.red,
    ),
  ),
];
