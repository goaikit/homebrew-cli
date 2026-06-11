# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.140"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.140/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "030191298a357d5caf4c25548a8fc72fc0d97db85f0128d42c66d001ad2f4455"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.140/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "efccc3eee8bc146c7f39ebd7b4ccc1f5cd44716c4db8de0e026e57e6dd978966"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.140/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "cc3153984ee1b1f21121b58b9ac6d072cd8b71cfafe00443603678a91124a582"
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
