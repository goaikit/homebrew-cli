# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.73"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.73/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "e1f5643343b291464ac9464ba77d8dddcc2f4991074536290c202f265d949aba"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.73/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "84160de460b7e4fd40da8f780b0fdda8eb26b7f220a4cd7108eb1d52de1116da"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.73/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "9cea87a466b4f389ffdea791a1f9504f40641b332ebbb592de2e7ac3a8b06993"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.73/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "521ea4135f7c44564c29f249eb0bdc2e631044f83ceec37160888d9c6839019f"
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
