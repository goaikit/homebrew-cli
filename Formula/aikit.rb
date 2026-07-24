# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.171"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.171/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "f0861e2eefa0f638b69acc8429c6ff9a5127f348ab217fa0e304e50da08955eb"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.171/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "39bd2947e0f2c250f25d6449338cc09f5d34ad1a06555184e95978a886b6079d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.171/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b19af3f8845c4b922a3b329bd1b45f280551d88ba34a2aeb88aee1bad6cf52a4"
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
