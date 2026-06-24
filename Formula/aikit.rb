# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.151"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.151/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "99b0d967fb10c24ccd33a4323fbfd2536bd6beab5abab74a2fa8aa6253b62824"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.151/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "f927b1f3f81655f0eac1a5f6b629a2937ffa24f6231d4596e6db059dd42d326d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.151/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "3cdd69c994f269d3bc339fd412266e583ae9e59a59eba68b3df51d0f5cf8de58"
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
