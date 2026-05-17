# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.118"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.118/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8a300f2ab23fd86d87ba31a7423c93904bce67e5bae6964b376f020d4279f7fc"
    else
      odie "Unsupported macOS CPU architecture (Apple Silicon only)"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.118/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "20e9de04291c1dbdcc256d190094cbcdb78dfe667da1006c2382e0f541facf2f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.118/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "86bc850d8ed98095b0b047d994a900e9dff30fc41c17505e957aecee96ed38fa"
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
