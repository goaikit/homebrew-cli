# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.196"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8cc68b7f3cf3889762e540774ccff6780fcad949864d5d6221dc1f79a1532491"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "0d180f824c9943a581069661f4e671551c245e439587a7d4ed2d79453862d023"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e964ef14474000c57e095788750fa8bcbd7f8173341d4e6c7b84b52a3e39aa79"
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
