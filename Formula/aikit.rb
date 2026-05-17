# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.112"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.112/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8c30387206a93cabd577f8c5c0ab366dca3f1b49e86e569d67d890b803e8a7f7"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.112/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "673943515b2f60b17f6ec6063e05ba9e61d21d97f1e74d5a5aadbcf44893a9fa"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.112/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b721c1a6e62c30980509d4278a5143b30995fb539c97d8cfcc45ede2eff38907"
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
