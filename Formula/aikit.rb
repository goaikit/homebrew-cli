# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.160"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.160/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8e825921fbd5890e407c6920ddb2761efce79f4ba3e4301a3b36b10f1e8cba6a"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.160/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "8171bdbff68545d25ed8d493eb1a45f3d8323a70d252e9244e3ce289f45350cf"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.160/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e2ff6000f1f7a30a760bc72b4e1afacff6077d48b9399e8cc46b9580425e4429"
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
