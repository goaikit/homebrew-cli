# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.37"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.37/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "40311ab9770fb2b6db7f37c5761063122ad0a52e30121744a50b8bb22be96e22"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.37/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "712ff9d63a66f1960731ed13616790c6d7bb078f0158f2caa6762985c254ee6d"
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
