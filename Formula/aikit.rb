# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.58"
  license "MIT"

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary
      # glibc >= 2.38: use gnu binary for full features
      # glibc < 2.38 or musl-based (Alpine): use musl binary for compatibility
      glibc_version = begin
        `ldd --version 2>&1`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "https://github.com/goaikit/aikit/releases/download/v0.1.58/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b980ed77226c79df07abd04e183d5081990046f6449ab2d689f8d105c955834f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.58/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "dbd75b05988f362870fd8deb96810ab292fe442a0793b46294351c4c5590177a"
      end
    end
  end

  def install
    bin.install "aikit"
  end

  test do
    system "#{bin}/aikit", "--version"
  end
end
