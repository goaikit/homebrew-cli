# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.124"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.124/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8519c8b5e79a2c0c43aa76b6277be55db5701bb8148d06e64596c89241542a2d"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.124/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "a70bdfbef45092e586641033cb6c256843f187f00ae07113019628873c5f78ac"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.124/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "3cec4a9cdb136479cd8e6d15517287b39b56f1809a702f35ba7e050a34ef1942"
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
