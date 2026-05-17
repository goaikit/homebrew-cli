# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.114"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.114/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "eeb8e35aed450b41310b5be5ba359c3366949577750b6c5a989eda7aaa1e195d"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.114/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "6c9936bf9450c852c8c9c2866255aaea089eddffb643fb3c8015b5a7a57909e3"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.114/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7b5fe2eb09d4094d429e97d75ed2ba766d93d1cc0b581f6f88caedf41fdd7ff8"
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
