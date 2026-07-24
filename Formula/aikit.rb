# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.163"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.163/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "40f9a083089b19708350c9ce646aabc558626bf6eb12ab7549515f8101c3dc61"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.163/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "bdd5bde8677db9c18ec284ac427290e3010f0d7450c3eb0ffe5a58be9b83b4b9"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.163/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "9d661550df8c8974d026caba00b66a606e69d9f9356b359bc4ab3c055810b174"
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
