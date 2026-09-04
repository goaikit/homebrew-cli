# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.196"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "70f54e275ce2a1c782e849b9e3318903ce39d61fdd98bee90caa5adaa952b75f"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "bd8b131a784941d210f08ba83743c99b4897642ab58a4bbd9f7cf6bb1c0df27f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "c898f00296224d66630bb2de1754bd49c3a019efb8673f8dbf27bc8b5d1ede99"
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
