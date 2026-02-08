# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.47"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.47/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "8213952f11f5bca980d7083f25b34dae984aa60c749439a94d6b016b956fa954"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.47/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "f772a86c09b47dd2f9929c26acdca5a74246572ee5708e6b5a7f4fec69ba1d9b"
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
