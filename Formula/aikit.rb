# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.136"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.136/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "f08a69bbd8a991e1039406be9079f7c2c5235d6d1773c6a5725176eadb0d93ba"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.136/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "0046248c1106578402b0303f9cd5d2accb85e690cb3ef239f3394724f2acdb5b"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.136/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "eb3a02736fad8672823e7028c92d5aa839bc5bd6a305c22520685ad65fccffe0"
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
