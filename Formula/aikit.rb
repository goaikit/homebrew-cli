# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.189"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.189/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a41ea5c5487640c8631c65853bdd822820894e31914e80f3aecb3a02d61cb097"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.189/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "487d87296362da9c0f2f141442a2cad1f4af127d547bccf0904594186b9c9b44"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.189/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "a35ac7198116acd4e182e138c66be87b3a5ecd57d5d1cf602036b3bb3aba81c1"
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
