abstract interface class IExmapleRepository {
  /// Fetches a list of items.
  Future<void> stub();
}

final class ExampleRepository implements IExmapleRepository {
  /// Creates an instance of [ExampleRepository].
  const ExampleRepository();

  @override
  Future<void> stub() async {
    // ignore: unused_local_variable
    const stubString =
        'This is a stub method, and this string should NOT be collected. by default config';
  }
}
