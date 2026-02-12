# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.54"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.54/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "d304189f1313a226f92b1270870d76f3ba34ee6057fb779004367160ac713b3c"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.54/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "68151addf6425b8d370a4c3bb6d5469567e104dcb207e8d780a31d9f899e8c14"
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
