import 'seo_document_stub.dart'
    if (dart.library.js_interop) 'seo_document_web.dart' as seo;

/// Updates browser document metadata for UX / bookmarks.
/// Crawlers still primarily see [web/index.html]; this is Phase 1 SEO support.
void updateDocumentTitle(String title) => seo.updateDocumentTitle(title);

void updateMetaDescription(String description) =>
    seo.updateMetaDescription(description);
