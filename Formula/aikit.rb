# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.185"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.185/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "df8de75a2ae11e6afa6ca716db48ab5e423b8467bdacc4c951be9ba677798693"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.185/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "bece7518a7b63f715d3b2cf3bca8f3db3e9edcc0c51ad144e4b41a4fc111c8a1"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.185/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "472c279e954b56d8acff168b9d364a5c2f0355b040b4c65634f1ace6f643d5fa"
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
