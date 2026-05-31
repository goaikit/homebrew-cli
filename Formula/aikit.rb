# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.128"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.128/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "b96de9ab66b873bf2e9ea143520f02311f08d3679208782339e8e992c35601a4"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.128/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "a932c7725fae924c23b7d3880d859b9e392984faa5d7b11fb4f1da9c3084bb8f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.128/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "5f8868071abebe66da1210c200ae41186479c7b9cb356751d71ebfbcd58f7ded"
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
