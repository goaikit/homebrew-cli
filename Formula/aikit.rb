# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.158"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.158/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "178885aa529caaf4b322d974db591ceebe1d7bd8568965fe8f3389cf9a0d626d"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.158/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "5030e4f18a1175dbc266da64e6b0434b6207c3db8fa47eb0812fa7a79805d0fc"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.158/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7673bd9aba5666fdde71d3d119dc23787fe5c54418449fdf8ba435a7052213fa"
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
