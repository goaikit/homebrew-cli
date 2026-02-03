# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.33"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.33/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "5acedba89fe237c20eb0695d04c652dbe55cff58f7b906334b0ada4c2236c995"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.33/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "8ff009ba4b96df9cc4c0484e2db12a1e293285cebce58ff5bf382c27a05231c4"
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
