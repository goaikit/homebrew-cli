# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.125"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.125/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "bf20a3426d76851779a3621b51e15c00ef13cee5600dfd40809ae7ffb3f34f39"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.125/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "befe70aedee0879214b20f66bf3cfef62d6172ef7837f42d0df3d7133efd5cdd"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.125/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d1b4817741450845b68299e316cbb872577942231b5c5866a6b53049735acf8e"
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
