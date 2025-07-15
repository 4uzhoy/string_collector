import 'package:string_collector/src/config_loader.dart';
import 'package:test/test.dart';

void main() {
  group('YAML config tests', () {
    const fullYaml = '''
input_root: lib/src
output_root: out/strings
preserve_path_from: lib/src/features
patterns:
  string_regex: "'[^']*[\u0400-\u04FF][^']*'"
  exclude_paths:
    - test
    - mock
  exclude_lines:
    - "//"
    - "assert"
''';

    test('loads config from YAML with all fields', () {
      final config = ConfigLoader.load(fullYaml, fullYaml);

      expect(config.inputRoot, 'lib/src');
      expect(config.outputRoot, 'out/strings');
      expect(config.preservePathFrom, 'lib/src/features');
      expect(config.patternsStringRegex, "'[^']*[\u0400-\u04FF][^']*'");
      expect(config.excludePaths, ['test', 'mock']);
      expect(config.patternsExcludeLine, ['//', 'assert']);
    });

    test('loads config with partial override (only output_root)', () {
      const partialYaml = '''
output_root: custom/output
''';

      final config = ConfigLoader.load(partialYaml, fullYaml);

      expect(config.inputRoot, 'lib/src'); // from fallback
      expect(config.outputRoot, 'custom/output'); // overridden
      expect(config.preservePathFrom, 'lib/src/features');
      expect(config.patternsStringRegex, "'[^']*[\u0400-\u04FF][^']*'");
      expect(config.excludePaths, ['test', 'mock']);
      expect(config.patternsExcludeLine, ['//', 'assert']);
    });
  });
}
