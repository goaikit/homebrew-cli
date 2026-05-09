# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.101"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.101/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "34c012a30ba408ab3e2f93f6dac3791c837952c2b6dbc4e2ed456890f673c3c5"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.101/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "38a3fbb78376084d5b81f80f7ffbe721bb7a07cea38d37921b5878c91a9e3716"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.101/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3ec8bdf986a069eb8c184b7b358603027cfe74bb53afcf729cef6924e80290a1"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.101/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "f2d7bb472b45c1d14a76a6d6cee5601bcbdede442fd6416236986fb296e9ca95"
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
