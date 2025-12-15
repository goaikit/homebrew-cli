#!/usr/bin/env bash
set -euo pipefail

# Auto-generated formula update script
# Usage: ./generate_formula.sh [--version VERSION]

APP_NAME="aikit"
GITHUB_REPO="goaikit/aikit"
FORMULA_CLASS="Aikit"
BINARY_NAME="aikit"

check_gh_available() {
    if ! command -v gh &> /dev/null; then
        echo "Error: GitHub CLI (gh) is not installed or not in PATH"
        echo "Please install gh: https://cli.github.com/"
        echo "Or ensure it is in your PATH"
        exit 1
    fi
    
    if ! gh auth status &> /dev/null; then
        echo "Error: GitHub CLI (gh) is not authenticated"
        echo "Please run: gh auth login"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is not installed or not in PATH"
        echo "Please install jq: https://stedolan.github.io/jq/"
        echo "Or ensure it is in your PATH"
        exit 1
    fi
}

check_gh_available

VERSION="${2:-latest}"

if [ "$VERSION" = "latest" ] || [ -z "$VERSION" ]; then
    echo "Fetching latest release..."
    RELEASE_TAG=$(gh release view --repo "$GITHUB_REPO" --json tagName -q .tagName)
    VERSION=$(echo "$RELEASE_TAG" | sed 's/^v//')
    echo "Latest version: $VERSION"
else
    VERSION=$(echo "$VERSION" | sed 's/^v//')
    echo "Using version: $VERSION"
    RELEASE_TAG="v$VERSION"
    if ! gh release view "$RELEASE_TAG" --repo "$GITHUB_REPO" &> /dev/null; then
        RELEASE_TAG="$VERSION"
        if ! gh release view "$RELEASE_TAG" --repo "$GITHUB_REPO" &> /dev/null; then
            echo "Error: Release $VERSION not found"
            exit 1
        fi
    fi
fi

# Get release data
RELEASE_DATA=$(gh api "repos/$GITHUB_REPO/releases/tags/$RELEASE_TAG")

# Find Linux GNU and MUSL assets and their SHA256 digests
LINUX_GNU_ASSET=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("linux-gnu")) | .browser_download_url' | head -1)
LINUX_MUSL_ASSET=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("linux-musl")) | .browser_download_url' | head -1)

if [ -z "$LINUX_GNU_ASSET" ] && [ -z "$LINUX_MUSL_ASSET" ]; then
    echo "Error: Could not find Linux release assets"
    exit 1
fi

# Extract SHA256 from GitHub API digest field
LINUX_GNU_SHA256=""
LINUX_MUSL_SHA256=""

if [ -n "$LINUX_GNU_ASSET" ] && [ "$LINUX_GNU_ASSET" != "null" ]; then
    LINUX_GNU_SHA256=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("linux-gnu")) | .digest' | sed 's/sha256://' | head -1)
    if [ -z "$LINUX_GNU_SHA256" ] || [ "$LINUX_GNU_SHA256" = "null" ]; then
        echo "Error: Could not find SHA256 digest for GNU binary in GitHub API"
        exit 1
    fi
fi

if [ -n "$LINUX_MUSL_ASSET" ] && [ "$LINUX_MUSL_ASSET" != "null" ]; then
    LINUX_MUSL_SHA256=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("linux-musl")) | .digest' | sed 's/sha256://' | head -1)
    if [ -z "$LINUX_MUSL_SHA256" ] || [ "$LINUX_MUSL_SHA256" = "null" ]; then
        echo "Error: Could not find SHA256 digest for MUSL binary in GitHub API"
        exit 1
    fi
fi

# Generate formula
FORMULA_FILE="Formula/${APP_NAME}.rb"
cat > "$FORMULA_FILE" <<FORMULA_EOF
# typed: false
# frozen_string_literal: true

class ${FORMULA_CLASS} < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/${GITHUB_REPO}"
  version "${VERSION}"
  license "MIT"

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary
      # glibc >= 2.38: use gnu binary for full features
      # glibc < 2.38 or musl-based (Alpine): use musl binary for compatibility
      glibc_version = begin
        \`ldd --version 2>&1\`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
FORMULA_EOF

if [ -n "$LINUX_GNU_ASSET" ]; then
    cat >> "$FORMULA_FILE" <<FORMULA_EOF
        url "${LINUX_GNU_ASSET}"
        sha256 "${LINUX_GNU_SHA256}"
FORMULA_EOF
fi

cat >> "$FORMULA_FILE" <<FORMULA_EOF
      else
FORMULA_EOF

if [ -n "$LINUX_MUSL_ASSET" ]; then
    cat >> "$FORMULA_FILE" <<FORMULA_EOF
        url "${LINUX_MUSL_ASSET}"
        sha256 "${LINUX_MUSL_SHA256}"
FORMULA_EOF
fi

cat >> "$FORMULA_FILE" <<FORMULA_EOF
      end
    end
  end

  def install
    bin.install "${BINARY_NAME}"
  end

  test do
    system "#{bin}/${BINARY_NAME}", "--version"
  end
end
FORMULA_EOF

echo "✅ Formula generated: $FORMULA_FILE"
echo "Version: $VERSION"
