# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.135"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.135/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "3952b4b5850cefb6a665d2e07b0e9873858ad9a9f1cdf2a256beb30e42809c87"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.135/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "9b5c27ee006478a47339d10752c2d2adfe7b66d46599f07dcff1a3ad3e2fd91a"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.135/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "4a4eb275c1fd5a6562ea1d01991da95c035011e1dc1fc99ed837007eb389108c"
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
