# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.40"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.40/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "2f1c1aa938b3f57009408f4a6aacdc5d246739d37248a92d1273ee48087bb82b"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.40/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0feee4b41268d77a06814da6a93d80f2a97c2a38bc54c9832df43b88ca3fc6ab"
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
