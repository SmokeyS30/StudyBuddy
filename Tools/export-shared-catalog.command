#!/bin/zsh

set -euo pipefail

ROOT="${0:A:h:h}"
BUILD_DIR="${TMPDIR:-/private/tmp}/prepnexus-catalog-export"
MODULE_CACHE="${TMPDIR:-/private/tmp}/prepnexus-module-cache"
OUTPUT="$ROOT/Android/app/src/main/assets/exam_catalog.json"

mkdir -p "$BUILD_DIR" "$MODULE_CACHE"

xcrun swiftc \
  -module-cache-path "$MODULE_CACHE" \
  "$ROOT/StudyBuddy/Models.swift" \
  "$ROOT/StudyBuddy/ExamCatalog.swift" \
  "$ROOT/Tools/ExportSharedCatalog.swift" \
  -o "$BUILD_DIR/export-prepnexus-catalog"

"$BUILD_DIR/export-prepnexus-catalog" "$OUTPUT"
echo "Updated $OUTPUT"
