# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.150"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.150/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "d9920d67cb45ceaff0215c3ae160bed749a8b861a4bd7fa0f8f9954601854e04"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.150/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "863f84e65919bba416458a694005451c94c96d15584c9f7d99a7d1277a803a71"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.150/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "cec27aef4e84d00cc8317189791f70685c37e7b42a059e4e6badfc076b790aa1"
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
