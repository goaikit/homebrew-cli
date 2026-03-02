# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.66"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.66/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "6a42a7db66ed88ed5e158d48005e4367bbaa31c9a101e72e592376306e3ec97a"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.66/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "47c0e49c23f2cfcd08296dd0fb0faef2be30a5ff610ef79051059b46e6bf2933"
    else
      odie "Unsupported macOS CPU architecture"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.66/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b8175e8c7b1e76e5548188a3581c063c7226971a822daff50c9d761295fc97f6"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.66/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "4bf505af53de214562fe5f9807351e53a7d7c355ec5b153d3886428059509cb1"
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
