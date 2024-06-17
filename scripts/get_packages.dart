// ignore_for_file: avoid_print

import 'dart:io';

void main() async {
  final currentDir = Directory.current;
  final projectPath = '${currentDir.path.split('coffee_app')[0]}coffee_app';

  final modules = Process.runSync('ls', ['$projectPath/modules']).stdout.toString().split('\n')..removeWhere((element) => element == '');
  for (String module in modules) {
    print('get packages in $projectPath/modules/$module');
    final result = await Process.run('flutter', ['pub', 'get', '--directory', '$projectPath/modules/$module']);
    if (result.stderr != null && result.stderr.toString().isNotEmpty) {
      print('Unable to get packages in $module: ${result.stderr.toString()}');
    }
  }
}
