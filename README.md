# string_collector 
## extract Dart strings to JSON 📦
A simple CLI tool to scan Dart source files and collect string literals into structured JSON files.

Perfect for:
- localization prep
- static analysis
- string audits
- i18n tooling

✨ Features
- ✅ Supports '...', "...", '''...''', """..."""
- 🔍 Filters lines and files via flexible YAML config
- 🗂️ Preserves directory structure in output
- 💡 Ideal for CLI pipelines and automation

🚀 Getting Started
```bash 
dart run string_collector --path=your_config.yaml
Or omit --path to use default_config.yaml.
```


Config 
```yaml
input_root: lib/src # Input directory for source files
output_root: strings # Output directory for collected strings
preserve_path_from: lib/src/features # Directory to preserve path structure from
patterns: # settings for string detection and filtering files
  exclude_paths:
    - "repository" # Paths repository directories
    - "debug" # Exclude debug directories
    - "test" # Exclude test directories
    - "mock" # Exclude mock directories
    - "l10n" # Exclude localization directories
    - "developer" # Exclude developer directories
  exclude_lines:
    - "///" # Exclude single-line comments with triple slashes
    - "\/\/" # Exclude single-line comments with double slashes
    - "logger\\.(i|d|e|w|v|wtf)" # Exclude logger calls
    - "log\\.(i|d|e|w|v|wtf)" # Exclude log calls
    - "l\\.(i|d|e|w|v|wtf)" # Exclude shorthand log calls
    - "\\.\\.(i|d|e|w|v|wtf)" # Exclude shorthand logger calls with cascade operator
    - "assert" # Exclude assert statements
    - "RegExp\\(" # Exclude RegExp instantiations
    - "^\\^" # Exclude lines starting with caret (^) which may indicate special syntax
  string_regex: "(?:'''(?:[^\\\\]|\\\\.|\\\\n)*?'''|\"\"\"(?:[^\\\\]|\\\\.|\\\\n)*?\"\"\"|'(?:[^\\\\'\\n]|\\\\.)*?'|\"(?:[^\\\\\"\\n]|\\\\.)*?\")" # Regex to match translatable strings, including single and multi-line strings
```