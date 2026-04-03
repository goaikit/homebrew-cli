# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.68"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.68/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "de21e36d34445780e57b774a52ab3ea8a4c09c4b80c1dda96d49692eb2e57042"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.68/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "20d3feef1849c70de48f5280c6c32382ec646c34e019182586207f974284cc94"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.68/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "9249533a9b675533788eb2bcff7135ce04aee992d2082e095bc36c525733d3ad"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.68/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "4fae166412c1647972162fa78f3076bb13d0ed2fd74d93deb2171e69af20c9ee"
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
