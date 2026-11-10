from pathlib import Path

replacements = [
    ("lib/features/resume/resume_page.dart", "text.toUpperCase()", "context.caps(text)"),
    (
        "lib/features/case_study/case_study_page.dart",
        "label.toUpperCase()",
        "context.caps(label)",
    ),
    (
        "lib/features/case_study/widgets/case_closing_section.dart",
        "l10n.caseNextLabel.toUpperCase()",
        "context.caps(l10n.caseNextLabel)",
    ),
    (
        "lib/features/case_study/widgets/case_coming_next_section.dart",
        "status.toUpperCase()",
        "context.caps(status)",
    ),
    (
        "lib/features/case_study/widgets/case_iteration_section.dart",
        "label.toUpperCase()",
        "context.caps(label)",
    ),
    (
        "lib/features/home/sections/education_section.dart",
        "label.toUpperCase()",
        "context.caps(label)",
    ),
    (
        "lib/features/home/sections/education_section.dart",
        "org.toUpperCase()",
        "context.caps(org)",
    ),
    (
        "lib/features/case_study/widgets/case_motion_section.dart",
        "CaseStudyCopy.t(l10n, timing.titleKey).toUpperCase()",
        "context.caps(CaseStudyCopy.t(l10n, timing.titleKey))",
    ),
    (
        "lib/features/home/widgets/project_image_slot.dart",
        "label.toUpperCase()",
        "context.caps(label)",
    ),
    (
        "lib/features/case_study/widgets/case_system_section.dart",
        "label.toUpperCase()",
        "context.caps(label)",
    ),
    (
        "lib/features/case_study/widgets/lazy_hover_video.dart",
        "label.toUpperCase()",
        "context.caps(label)",
    ),
]

for path, old, new in replacements:
    p = Path(path)
    t = p.read_text(encoding="utf-8")
    if old not in t:
        print("MISS", path, old)
        continue
    p.write_text(t.replace(old, new), encoding="utf-8")
    print("OK", path)

p = Path("lib/features/home/widgets/project_chips.dart")
t = p.read_text(encoding="utf-8")
t = t.replace(
    "static String _label(AppLocalizations l10n, String slug) {",
    "static String _label(BuildContext context, AppLocalizations l10n, String slug) {",
)
t = t.replace("_ => slug.toUpperCase(),", "_ => context.caps(slug),")
t = t.replace("_label(l10n, slugs[i])", "_label(context, l10n, slugs[i])")
p.write_text(t, encoding="utf-8")
print("OK project_chips")
