#!/usr/bin/env python3
"""Replace GoogleFonts.* style calls with AppTypography roles (best-effort)."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path("lib")

# Map GoogleFonts factory → AppTypography role
ROLE = {
    "bebasNeue": "headline",
    "lalezar": "headline",
    "reemKufi": "headline",
    "permanentMarker": "brush",
    "marhey": "brush",
    "rakkas": "brush",
    "kalam": "note",
    "playpenSans": "note",
    "tajawal": "note",
    "cairo": "body",
    "ibmPlexSansArabic": "body",
    "spaceMono": "label",
}

SKIP_FILES = {
    "lib/app/theme/app_typography.dart",
    "lib/app/theme/app_theme.dart",
}


def extract_call(src: str, start: int) -> tuple[str, int] | None:
    """Return (full_call, end_index) for a GoogleFonts.foo( ... ) starting at start."""
    m = re.match(r"GoogleFonts\.(\w+)\(", src[start:])
    if not m:
        return None
    i = start + m.end()
    depth = 1
    while i < len(src) and depth:
        c = src[i]
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
        elif c in "\"'":
            quote = c
            i += 1
            while i < len(src) and src[i] != quote:
                if src[i] == "\\":
                    i += 1
                i += 1
        i += 1
    return src[start:i], i


def transform_args(args: str, role: str) -> str:
    """Drop decoration / force-safe args; keep size, color, weight, height, spacing, style."""
    # Remove trailing commas noise later
    keep = []
    # Split top-level named args roughly
    parts = []
    buf = []
    depth = 0
    for ch in args:
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        if ch == "," and depth == 0:
            parts.append("".join(buf).strip())
            buf = []
            continue
        buf.append(ch)
    if buf:
        parts.append("".join(buf).strip())

    drop_keys = {"decoration"}
    for p in parts:
        if not p:
            continue
        if ":" not in p:
            continue
        key = p.split(":", 1)[0].strip()
        if key in drop_keys:
            continue
        if role in {"headline", "brush", "note", "body"} and key == "letterSpacing":
            # AppTypography applies locale rules; keep letterSpacing only for label EN path.
            # Passing it is OK for headline EN; AppTypography.headline accepts it.
            pass
        keep.append(p)
    return ", ".join(keep)


def process_file(path: Path) -> bool:
    rel = path.as_posix()
    if rel.replace("\\", "/") in SKIP_FILES or rel.replace("\\", "/").endswith(
        tuple(SKIP_FILES)
    ):
        return False
    text = path.read_text(encoding="utf-8")
    if "GoogleFonts." not in text:
        return False

    out = []
    i = 0
    changed = False
    while i < len(text):
        idx = text.find("GoogleFonts.", i)
        if idx < 0:
            out.append(text[i:])
            break
        out.append(text[i:idx])
        parsed = extract_call(text, idx)
        if not parsed:
            out.append(text[idx : idx + 12])
            i = idx + 12
            continue
        call, end = parsed
        m = re.match(r"GoogleFonts\.(\w+)\((.*)\)$", call, re.S)
        if not m or m.group(1) not in ROLE:
            out.append(call)
            i = end
            continue
        family = m.group(1)
        role = ROLE[family]
        args = transform_args(m.group(2).strip(), role)
        # Prefer context when available — assume build methods have context.
        if args:
            replacement = f"AppTypography.{role}(context, {args})"
        else:
            replacement = f"AppTypography.{role}(context)"
        out.append(replacement)
        changed = True
        i = end

    new_text = "".join(out)
    if not changed:
        return False

    # Fix imports
    new_text = new_text.replace(
        "import 'package:google_fonts/google_fonts.dart';\n",
        "",
    )
    typo_import = (
        "import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';\n"
    )
    if "app_typography.dart" not in new_text:
        # Insert after first package import of this project or after flutter import
        m = re.search(
            r"(import 'package:ahmed_rasmy_portfolio/[^\n]+;\n)", new_text
        )
        if m:
            new_text = new_text[: m.end()] + typo_import + new_text[m.end() :]
        else:
            m2 = re.search(r"(import 'package:flutter/[^\n]+;\n)", new_text)
            if m2:
                new_text = (
                    new_text[: m2.end()] + typo_import + new_text[m2.end() :]
                )

    # Ternaries that picked AR/EN GoogleFonts manually become redundant —
    # leave structure; analyzer will catch unused locals later.
    path.write_text(new_text, encoding="utf-8")
    print(f"updated {path}")
    return True


def main() -> None:
    count = 0
    for path in ROOT.rglob("*.dart"):
        if process_file(path):
            count += 1
    print(f"done: {count} files")


if __name__ == "__main__":
    main()
