# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.172"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.172/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "20f02a5c7236f83286a4d9176f9c84a9e8db2a9701f0d52e1d1bb160f15cd492"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.172/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "658f7f016ed304c4b5097a68ec397d795da818b6464c163f04f1407d3d0d67d0"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.172/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "df82a77a7cc63e3fd5fae1c794521644f1b5e862c07c7580f42d239c7e979b1a"
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
