# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.127"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.127/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "13523ea6ed811ae3ed0352374bc17d3ed7773800fe8cd0a5ccb999e718df594b"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.127/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b9658a1970456fa4ae65ac50c9848b4e4c24a0caeb19d8ce8bedd39de5556daf"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.127/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "4bb713c1b61a403d1cb72b4b1e13f5007299110217b7e03c421d2da74cb4f648"
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
