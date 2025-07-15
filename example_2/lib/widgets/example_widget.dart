// ignore_for_file: prefer_single_quotes

const str1 = 'This is a string should be collected.';
const str2 = 'This is another string should be collected.';
const str3 = "This is a third string should be collected.";
const str4 =
    "This is a fourth string with a special character: \u{1F600} should be collected.";
const str5 =
    '''this is a multiline string with one line should be collected.''';

/// Docs would be ignored
void build() {
  // and comments too
  const example = 'This is an example string that should be collected.';
  lolol.v('This should not be collected');
  str('but this should be collected');
  throw UnimplementedError(
    'ExampleWidget is not implemented yet. Example: $example',
  );
}

class L {
  const L._();

  void v(Object l) {}
}

const L lolol = L._();

void str(String s) => lolol.v(s);
