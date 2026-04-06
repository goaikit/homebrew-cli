# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.74"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.74/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "e85ca6fcff77fb80df8a368eb30cc4cf6a69b2e4ee8a99e558e4e8dffca2bc96"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.74/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "6375af629fa110336217d2081371e40f2a0aef6536dc51f7080631504a8ce38e"
    else
      odie "Unsupported macOS CPU architecture"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.74/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "1f5697a05206c912d54e61eb312c8a04092c987d6fa1cad467218980e54b3b09"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.74/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "74f2eff7341795f45a043b0545843054a2145c61d121dbad8a518a4268cc1e74"
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
