import 'package:string_collector/config.dart';
import 'package:yaml/yaml.dart';

/// {@template config_loader}
///
/// A utility class to load configuration from a YAML string.
/// {@endtemplate}
abstract class ConfigLoader {
  const ConfigLoader._();

  /// read yaml content and return a [CollectorConfig] instance.
  static CollectorConfig load(String rawYaml, String defaultConfigYaml) =>
      CollectorConfig.withFallback(
          yaml: loadYaml(rawYaml) as YamlMap?,
          fallback: loadYaml(defaultConfigYaml) as YamlMap);
}
