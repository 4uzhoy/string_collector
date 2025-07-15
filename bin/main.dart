import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:string_collector/collector.dart';
import 'package:string_collector/config_loader.dart';



Future<void> main(List<String> args) async {
  stdout.writeln('Starting string collection...');
  
  final binDir = File(Platform.script.toFilePath()).parent;

  final defaultConfigFile = File(p.join(binDir.path, 'default_config.yaml'));

  final pathConfig = _parseArgs(args);
  File? configFile;

  if (pathConfig != null) {
    if (!File(pathConfig).existsSync()) {
      stderr.writeln('Config file not found at: $pathConfig');
      exit(1);
    } else {
      configFile = File(pathConfig);
      stdout.writeln('Using custom config file: ${configFile.path}');
    }
  }
  final rawDefaultConfig = defaultConfigFile.readAsStringSync();

  final rawConfig =
      File(pathConfig ?? defaultConfigFile.path).readAsStringSync();

  final config = ConfigLoader.load(rawConfig, rawDefaultConfig);

  stdout
    ..writeln('Using configuration:')
    ..writeln()
    ..writeln(config.toString())
    ..writeln();

  try {
    stdout.writeln('Running string collection...');
    await Collector(config: config).collect();
    stdout.writeln('✅ String collection completed successfully.');
  } on Object catch (e, st) {
    stderr
      ..writeln('❌ Collector crashed: $e')
      ..writeln(st);
    exit(1);
  }
}

String? _parseArgs(List<String> args) {
  stdout.writeln('Parsing config path from arguments...');

  final arg = args.firstWhere(
    (e) => e.contains('--path='),
    orElse: () => '',
  );
  if (arg.isNotEmpty) {
    stdout.writeln('Using config path: ${arg.replaceFirst('--path=', '')}');
  } else {
    stdout
      ..writeln('No config path provided, using default: default_config.yaml')
      ..writeln(
          'If you want to use a custom config, pass it with --path=your_config.yaml');
  }
  return arg.isNotEmpty ? arg.replaceFirst('--path=', '') : null;
}
