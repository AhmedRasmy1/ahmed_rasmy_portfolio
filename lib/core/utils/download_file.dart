import 'download_file_stub.dart'
    if (dart.library.js_interop) 'download_file_web.dart' as impl;

/// Triggers a browser download for a bundled asset (web) or no-ops elsewhere.
Future<void> downloadAssetFile({
  required String assetPath,
  required String fileName,
}) =>
    impl.downloadAssetFile(assetPath: assetPath, fileName: fileName);
