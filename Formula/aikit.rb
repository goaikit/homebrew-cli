# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.30"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.30/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "7047e35a0eff0d3ca3c71311bcbd3deb522449d55bd6d45e06c9cba4eedc2d0f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.30/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "f6632bf9c403648c94fddccdb15c6430ccb702282d1dfa02566051bc77521f9c"
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
