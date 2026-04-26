# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.91"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.91/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "40c336047fe791c671f9d74b3f274bd641fc3ebaadfdc148062eeb418cb021d5"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.91/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "f1d58d2121eb493dddd4c6af73f17e607a069238bb877d508c5977fe2d91e084"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.91/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "fcbbacdf1dbf90f8958d56612d3e53d5e3dc51425dcfd9337210ecce639ecfbf"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.91/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d24cbc2d7d00c1ba6d8f8c22eaa44be60c5bbc531a73aae39e747dadb7cd6660"
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
