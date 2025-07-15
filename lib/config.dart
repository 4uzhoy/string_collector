import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

/// {@template collector_config}
/// Configuration for the string collector utility.
/// {@endtemplate}
@immutable
final class CollectorConfig {
  /// Creates a new [CollectorConfig] instance.
  const CollectorConfig({
    required this.inputRoot,
    required this.outputRoot,
    required this.excludePaths,
    required this.preservePathFrom,
    required this.patternsExcludeLine,
    required this.patternsStringRegex,
  });

  /// The root directory to start scanning for Dart files.
  final String inputRoot;

  /// Root output directory for collected strings.
  final String outputRoot;

  /// Optional anchor directory to preserve path structure from.
  final String preservePathFrom;

  /// The regex pattern to detect translatable strings.
  final String patternsStringRegex;

  /// Path substrings to exclude (e.g., "test", "mock").
  final List<String> excludePaths;

  /// Line-level exclusion patterns (as raw regex strings).
  final List<String> patternsExcludeLine;

  /// Factory constructor that parses a YAML map into [CollectorConfig].
  /// Uses a fallback configuration if the provided YAML is missing any fields.
  factory CollectorConfig.withFallback(
      {required YamlMap? yaml, required YamlMap fallback}) {
    final inputRoot = yaml?['input_root'] ?? fallback['input_root'];
    final outputRoot = yaml?['output_root'] ?? fallback['output_root'];
    final patterns = yaml?['patterns'] ?? fallback['patterns'];
    final outputPreservePathFrom =
        yaml?['preserve_path_from'] ?? fallback['preserve_path_from'];

    final patternsStringRegex = patterns['string_regex'];
    final excludePaths = _readList(patterns['exclude_paths'] as YamlList);
    final excludeLinePatterns =
        _readList(patterns['exclude_lines'] as YamlList);

    return CollectorConfig(
      inputRoot: inputRoot as String,
      outputRoot: outputRoot as String,
      preservePathFrom: outputPreservePathFrom as String,
      patternsStringRegex: patternsStringRegex as String,
      excludePaths: excludePaths,
      patternsExcludeLine: excludeLinePatterns,
    );
  }

  static List<String> _readList(YamlList list) =>
      list.nodes.map((e) => e.value.toString()).toList();

  @override
  String toString() => (StringBuffer()
        ..writeln('CollectorConfig')
        ..writeln('inputRoot: $inputRoot')
        ..writeln('outputRoot: $outputRoot')
        ..writeln('preservePathFrom: $preservePathFrom')
        ..writeln('excludePaths: $excludePaths')
        ..writeln('patternsStringRegex: $patternsStringRegex')
        ..write('patternsExcludeLine: $patternsExcludeLine')
        ..write(''))
      .toString();
}
