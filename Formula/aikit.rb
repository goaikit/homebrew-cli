# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.69"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.69/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "1285fcb05c3cb2865eee531e152b8ea3b07d5b7cce89c3f91bf75a76cf2e245c"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.69/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "84707b3ac8d82df6938db26abdb41f23d914c33eccd8332075d44cfc78e732a4"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.69/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "258860d4cb4ad06daf0f4b38ede72033009324c5cad4125d788cf3a14357c2cf"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.69/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "2655d6147f86a3f084d8f2ee36a2f8952ca382c8ca2da310e0868b341f2e89cf"
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
