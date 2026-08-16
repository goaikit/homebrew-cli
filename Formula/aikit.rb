# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.190"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.190/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "e8917b15e781f22a3bcd0e03f694d9f844638f23bbab42f96bf530e8d704b0ec"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.190/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "46561fd074848203fe4bc5566fa681afbdf105fee4c46855e9e41127b920892f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.190/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "51ec307850f0b5016efef5950f60981a6739e38430c67103ddfc7dcd5295415b"
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
