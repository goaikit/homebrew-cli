# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.72"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.72/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8eae902e44a14a3cd7ab83f23fb609e2ec386be4be0029609a675316dbac8de8"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.72/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "5547e9c10eb15ad9fbd849491b2f14f527fbe9758394e9a55b2ed9a0047d0e29"
    else
      odie "Unsupported macOS CPU architecture"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary.
      # glibc >= 2.38: use GNU binary for dynamic-linking environments.
      # glibc < 2.38 or musl-based systems: use MUSL binary for compatibility.
      glibc_version = begin
        `ldd --version 2>&1`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "https://github.com/goaikit/aikit/releases/download/v0.1.72/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "e889c4a1891fb4ed2da08c6a892d34e3f84eda5df19d38bc061561f8206b110d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.72/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "4a840f9664c4d7f99bfef38e74c8923a77a33d0768e54253bcb128e30345f0bc"
      end
    else
      odie "Unsupported Linux CPU architecture"
    end
  end

  def install
    bin.install "aikit"
  end

  test do
    system "#{bin}/aikit", "--version"
  end
end
