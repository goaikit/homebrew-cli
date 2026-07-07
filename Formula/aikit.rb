# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.156"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.156/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "48af90af3e3c86a42807a647b117a27e774bf0f553999600f9492bf8552746e8"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.156/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "ad24797211bc9ad540b654ed33dc56f480047ca1cadbede815e948a957988705"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.156/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "573f58f43bc6c77feb3ca8dce4f36fe815d45604f2e14bdc1e984e1bf115dd8d"
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
