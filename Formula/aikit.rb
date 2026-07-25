# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.180"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.180/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "bfc4051602095a870711929752f1b6ea889661dd9be96c25cb552573e7b69147"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.180/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "5236a7a7ebe71dac67a0ee8f6800ff421c6062a533dc4dd4680321ca9231d27c"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.180/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "c1572a247b875283a5a2b16ba55df76874308a8b85418748276aae5d464bb081"
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
