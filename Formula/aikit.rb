# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.75"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.75/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "5375b135a0db2137f37920537687a2318a3064537b5fed69e771f90eb32f4215"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.75/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "c27a5bd24faf14984ccf330f1bdce37cda1c7cf5ab3f26e7b0d600de773b7f8d"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.75/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "13b650ddfbc9b3a84f0ad1193e3bb3834c4fcaac0b1f7d168fcd6ec52789aab7"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.75/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d9ca864381d326908992cf9dedff1d53aa62593442116f30033315ffc37f27e7"
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
