# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.148"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.148/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "5cb2b6b8b13cbfc867223e70ce8181e2971cd2089c5b897c1708dddcf104a58a"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.148/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "e29c4d6f5b55f27103c64c874ec1fd750fd2d86a6f89b94e5d53906ede295306"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.148/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "cb5be9251cf8538b50f04970e83b8dad69ccbca6bb0940a5aff1eabc673d9cb9"
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
