import 'dart:io';

Future<void> main() async {
  String version = Platform.environment['version'] ?? "";
  if (version.isEmpty) {
    // ignore: avoid_print
    print("Error: Version environment variable is not set\n");
    exit(1); // 返回错误码，让CI正确检测到失败
  }
  
  String realVersion = version.replaceAll("release-v", "");
  
  try {
    File pubspec = File("pubspec.yaml");
    if (!pubspec.existsSync()) {
      print("Error: pubspec.yaml file not found\n");
      exit(1);
    }
    
    List<String> lines = await pubspec.readAsLines();
    bool foundVersionLine = false;
    
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      if (line.startsWith("version:")) {
        lines[i] = "version: $realVersion";
        foundVersionLine = true;
        break;
      }
    }
    
    if (!foundVersionLine) {
      print("Error: Could not find version line in pubspec.yaml\n");
      exit(1);
    }
    
    pubspec.writeAsStringSync(lines.join("\n"));
    print("Successfully updated version to: $realVersion");
  } catch (e) {
    print("Error updating version: $e");
    exit(1);
  }
}