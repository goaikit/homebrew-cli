# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.196"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "70c42ad60b5fc9f37930701c6917138f1aeaf0175bb6347157da9bed173f4575"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "d9abefc32d58a2990fe9d5cc16fd6814c87513ec385e4474e1c5419b17927a28"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e9454dae72a4753cab0adb0bdd494ecfe23e52d699f744d07d2d79cfa6bd5a39"
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
