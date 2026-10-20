import 'package:web/web.dart' as web;

void updateDocumentTitle(String title) {
  web.document.title = title;
}

void updateMetaDescription(String description) {
  final existing = web.document.querySelector('meta[name="description"]');
  if (existing != null) {
    existing.setAttribute('content', description);
    return;
  }
  final meta = web.document.createElement('meta');
  meta.setAttribute('name', 'description');
  meta.setAttribute('content', description);
  web.document.head?.append(meta);
}
