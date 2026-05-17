# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.116"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.116/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "747cbe66475ebedb6519e46395540ac1219f090133750ac56a22e5603b10f792"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.116/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "319c130f583ec59dcb973cec30ea102eec3d54e9c4573c0f87fb919b6e22ae55"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.116/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "41844b618687ea451c1a85c5c0e5bb764a3cab0357505fa316528ec3795d8564"
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
