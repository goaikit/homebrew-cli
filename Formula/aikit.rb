# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.132"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.132/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8c8806a4e8cac2862e36b1dacdb03c12476b7356ca9ba0561d995edd43eb4269"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.132/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "f1a64b9b43a6ee38b1e17e1e6dda6bca1687c551a9bb17feb3b684818df65885"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.132/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "a729e5cc9415d3f51f65f6e5b3a7e4342715f91a0c7ef4e16ae0a72958d4781a"
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
