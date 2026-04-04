# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.70"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.70/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a9830d3446c285d550640f22a3bd37ebfc6892ee82c8e0be571ff0ae7a8eecf0"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.70/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "fa013e211471d3d9d9e8f2b3ff5d39e334d5ebf433c41b43002f51d517308ddb"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.70/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "400d772d85e22efa7596b629de84b4eebeb89a18d2c157970b54211abcefce71"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.70/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7c5b5c41f17286526a78b2ab87e73e22fc28124ded875113dc468b3747b94873"
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
