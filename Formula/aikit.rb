# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.67"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.67/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "adf58ec3b865e128f1999fca8bf13cb851ea7d6f6997ddf7df587347b11aee9b"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.67/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "239bde0edfeb0512a44292d9ba78e9fcf9171c793d2e20b7fa2b3ec9e3a32fbe"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.67/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "9377c6b98422968544fd93eb9d0f1648fe07c80afcaf0ef6583e48ddebb002e2"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.67/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "9ee5535b40669e4ca421ec3ce93b30445f94c260b88df3ecfea5a5643dfd1f8a"
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
