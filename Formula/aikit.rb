# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.167"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.167/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "16b03086465bc85f4752ca0a951ed766935d95a1dd698f0930f3cf2f81182f77"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.167/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3ef3f673dfca1df8df7693d551c916945ae7a6e8c9ddfae6276c0079a8ee4228"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.167/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0e591115a4cd4789d5eb1c43f0d7a7f3fa256e83bdf4dc3467128e725f80e23e"
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
