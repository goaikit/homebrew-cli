# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.173"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.173/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "b331c1f4a7f41526b11339a8ecd8ad243724ced5520fd20f7f39e3611b1c5a5d"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.173/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "59fbf17c1782f3e4372c01a7735e9de97d42a2cc21f58e6293fe91e6474ef114"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.173/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d9f4aba8ea9147f1257ae21882fb31c53798c003f68f59585204b44f70bed231"
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
