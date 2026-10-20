import 'package:web/web.dart' as web;

Future<void> downloadAssetFile({
  required String assetPath,
  required String fileName,
}) async {
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = assetPath
    ..download = fileName
    ..style.display = 'none';
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
