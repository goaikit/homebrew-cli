# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.44"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.44/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "ebb2d5dd575b750e7b55eed7e1784b16be923fe1364aba01207e2271325bd7bf"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.44/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d92f307261311ffbcceeefecd34257aa118403ea505b8db41cf129894a3cb644"
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
