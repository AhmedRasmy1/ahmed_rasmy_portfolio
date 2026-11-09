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

void updateCanonicalUrl(String url) {
  final existing = web.document.querySelector('link[rel="canonical"]');
  if (existing != null) {
    existing.setAttribute('href', url);
    return;
  }
  final link = web.document.createElement('link');
  link.setAttribute('rel', 'canonical');
  link.setAttribute('href', url);
  web.document.head?.append(link);
}
