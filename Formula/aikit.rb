# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.195"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.195/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "64e62881b6194b292332f5274982e541e651477203a3cdbd2fc4f1f82b4bdedd"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.195/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "8d8800d61d0c62bde4ffebddd69500384ea524524369c7e5f71c0e58ceb16e54"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.195/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e4f03ed5e3a207af5dc7c04e5ec565b262de95b57ce585ad0615f46240efcd82"
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
