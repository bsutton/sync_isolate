// @dart=3.0

class ProcessSettings {
  ProcessSettings(
    this.command, {
    this.args = const <String>[],
    String? workingDirectory,
    this.runInShell = false,
    this.detached = false,
    this.terminal = false,
    this.privileged = false,
    this.extensionSearch = true,
  }) {
    this.workingDirectory = workingDirectory ??= '.';
  }

  final String command;
  final List<String> args;
  late final String workingDirectory;

  bool runInShell = false;
  bool detached = false;
  bool terminal = false;
  bool privileged = false;
  bool extensionSearch = true;

  bool isPriviledgedUser = false;

  /// If we are running with mode terminal or detached then
  /// we don't have access to the stdio streams.
  bool get hasStdio => !(terminal | detached);
}
