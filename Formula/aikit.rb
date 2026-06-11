# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.141"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.141/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "c24158693088142ac8947ce30b4676646c9b219e016729318d42a475c179379b"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.141/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "1efc936c494bd508e1a821232eb5552b6cf9f0c4dedfb814456919cc9bb5a064"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.141/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b966dbeac023e07a99bf36fafd07d2a06473ed3a4693d8ee0f77d5deee22705e"
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
