# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.157"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.157/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "51223f26217a59da8a06bce95df9dfd432d267d144afcad4c89d4de5d2166cd0"
    else
      odie "Unsupported macOS CPU architecture (Apple Silicon only)"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary.
      # glibc >= 2.38: use GNU binary for dynamic-linking environments.
      # glibc < 2.38 or musl-based systems: use MUSL binary for compatibility.
      glibc_version = begin
        `ldd --version 2>&1`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "https://github.com/goaikit/aikit/releases/download/v0.1.157/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "ea55efd9607a1b551dda5fb61d5441edea9072f8edf866c644c3153c7ee6fd14"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.157/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d4402208b789da91e3dea21bb2a1495ac8e86ad2e91a85b5604c4ec9d3d7864e"
      end
    else
      odie "Unsupported Linux CPU architecture"
    end
  end

  def install
    bin.install "aikit"
  end

  test do
    system "#{bin}/aikit", "--version"
  end
end
