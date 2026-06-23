# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.146"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.146/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "1e26d12c45231a829567ed260a9cead4dd4142978e2c9ee6007dd54e854a8623"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.146/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "2ca75947ccef81ad65a89c35cc9493d026db11890d5ef2ab1b66dc23134e5b3a"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.146/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "9295d4a6f4f771f58b25e18787c74846a006b62a09b5cda46ea0e1bde413e1fd"
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
