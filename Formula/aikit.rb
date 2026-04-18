# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.82"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.82/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "5e78dd3517e3ea776f2376c6ffc91434245b6f813c2cef33644d77143b3903ba"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.82/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "7054b3999724aa2fc526712425a353aa6aa3e612909c946791d42115aec6b22b"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.82/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "4094ef6ae2f8634508fa1f7875f6311e1be9219b9d14a7c45162bd63888e751e"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.82/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6c6f0baae1f3af164cec8c2cce3aef4364adc99162183320b1da7713e219b686"
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
