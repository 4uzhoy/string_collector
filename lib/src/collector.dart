import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:string_collector/src/config.dart';

/// {@template string_collector}
/// Core utility to extract localizable strings from Dart files.
/// {@endtemplate}
final class Collector {
  /// Creates a [Collector] with the provided [config].
  const Collector({required this.config});

  /// User configuration.
  final CollectorConfig config;

  /// Run the string collection process.
  Future<void> collect() async {
    final files = Directory(config.inputRoot)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) {
      final path = file.path;
      return path.endsWith('.dart') && !config.excludePaths.any(path.contains);
    });

    final stringRegexp = RegExp(config.patternsStringRegex);
    final excludeLineRegexesFormatted = config.patternsExcludeLine.join('|');
    final result = <String, List<Map<String, String>>>{};

    for (final file in files) {
      stdout.writeln('Processing file: ${file.path}');
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains(RegExp(excludeLineRegexesFormatted))) continue;

        for (final match in stringRegexp.allMatches(line)) {
          final relativePath = p.relative(file.path, from: config.inputRoot);
          result.putIfAbsent(relativePath, () => []).add({
            'line': '$relativePath:${i + 1}',
            'src': match.group(0)!,
          });
        }
      }
    }
    stdout.writeln('Collected ${result.length} files with strings.');
    _writeResult(result);
    stdout.writeln('Results written to ${config.outputRoot}');
  }

  // bool isLoggerOrDocs(String line) => line.contains(
  //       RegExp(
  //         r'\/\/\//|\/\/|logger\.(i|d|e|w|v|wtf)|l\.(i|d|e|w|v|wtf)|\.\.(i|d|e|w|v|wtf)',
  //       ),
  //     );

  // bool isExludeLine(String line, List<String> exludePatterns) => line.contains(
  //       RegExp(
  //         '////|//|logger.(i|d|e|w|v|wtf)|l.(i|d|e|w|v|wtf)|..(i|d|e|w|v|wtf)',
  //       ),
  //     );

  // bool isAssert(String line) => line.contains('assert');

  // bool isRegExp(String line) => line.contains('RegExp(') || line.contains('^');

  void _writeResult(Map<String, List<Map<String, String>>> data) {
    final projectRoot = Directory.current;
    for (final entry in data.entries) {
      final path = p.joinAll([projectRoot.path, config.outputRoot, entry.key]);

      final fileName = p.basenameWithoutExtension(entry.key);
      final outputDir = Directory(path);
      if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

      final outputFile = File(p.join(outputDir.path, '$fileName.json'));
      stdout.writeln('Writing to: ${p.relative(outputFile.path)}');
      outputFile.writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(entry.value));
    }
  }
}
