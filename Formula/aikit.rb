# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.52"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.52/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "7ef9a5c9d9c4322b5947c7bde43544bbb0c44b1eec68173f6c60df58cd8315b7"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.52/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b741851cc6f4774628d647f9383256d1f684557110c30db4808f1c744684843f"
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
