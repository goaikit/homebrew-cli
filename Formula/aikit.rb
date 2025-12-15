# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.4"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.4/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "ae1e9202bd2b45c37065658fd4de9a2068dcbd501d20688befe596a1cb2bc465"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.4/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d14e7fa257fae19778defdb0a13bb5965866126b10cff6742834496ad21780ad"
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
