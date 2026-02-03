# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.34"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.34/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b65715e12e8cc8e81fcf436dfe95d196d8b9b921de7555d940ba95c12d140ee1"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.34/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "dd45c243a25d78e4eaea30a84c707b3aaecb1403ef458e0529eba71112cffd72"
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
