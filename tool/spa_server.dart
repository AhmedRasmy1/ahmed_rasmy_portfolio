// ignore_for_file: avoid_print
// Local static server that serves 404.html for unknown paths (GitHub Pages SPA trick).
// Usage: dart run tool/spa_server.dart [port]
import 'dart:io';

Future<void> main(List<String> args) async {
  final port = args.isNotEmpty ? int.parse(args.first) : 8080;
  final root = Directory('build/web');
  if (!root.existsSync()) {
    stderr.writeln('build/web missing — run flutter build web --release');
    exit(1);
  }
  final fallback = File('build/web/404.html');
  if (!fallback.existsSync()) {
    File('build/web/index.html').copySync('build/web/404.html');
    print('Created build/web/404.html from index.html');
  }

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('SPA server at http://127.0.0.1:$port  (unknown paths → 404.html)');

  await for (final request in server) {
    final uriPath = Uri.decodeComponent(request.uri.path);
    var rel = uriPath.startsWith('/') ? uriPath.substring(1) : uriPath;
    if (rel.isEmpty) rel = 'index.html';

    final file = File('${root.path}/$rel');
    File serve;
    var status = HttpStatus.ok;
    if (file.existsSync() && !FileSystemEntity.isDirectorySync(file.path)) {
      serve = file;
    } else {
      final asIndex = File('${root.path}/$rel/index.html');
      if (asIndex.existsSync()) {
        serve = asIndex;
      } else {
        serve = fallback;
        status = HttpStatus.notFound;
      }
    }

    final bytes = await serve.readAsBytes();
    request.response.statusCode = status;
    request.response.headers.contentType = _contentType(serve.path);
    request.response.headers.set('Cache-Control', 'no-cache');
    request.response.add(bytes);
    await request.response.close();
  }
}

ContentType _contentType(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.html')) {
    return ContentType('text', 'html', charset: 'utf-8');
  }
  if (lower.endsWith('.js')) return ContentType('application', 'javascript');
  if (lower.endsWith('.json')) return ContentType('application', 'json');
  if (lower.endsWith('.css')) return ContentType('text', 'css');
  if (lower.endsWith('.png')) return ContentType('image', 'png');
  if (lower.endsWith('.wasm')) return ContentType('application', 'wasm');
  if (lower.endsWith('.svg')) return ContentType('image', 'svg+xml');
  return ContentType.binary;
}
