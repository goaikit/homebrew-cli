# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.92"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.92/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "fdad88e1749a1fa89e288537b33a6bcaa1d93ce0e567b6fe85cdcff623b0ca53"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.92/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "fe1865d90e8e65dacc7d07b4237a3a235046d61005e306f15626ffc180de6a79"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.92/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b33c12327b1dfa6a6138f2d27bdbbb215114f4ece3bf3c2743c2bd0ac514be20"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.92/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "f8a342e09e446daf2bbbca662244b245990e1af58d80ef399c794e46dafbb235"
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
