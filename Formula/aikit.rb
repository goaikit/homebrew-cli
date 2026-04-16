# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.81"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.81/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "3a520482cceee56f71421667cd3e7f56ccc1c5a26b96cfc0d92f5dd165f9c971"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.81/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "2ad11da977bceaee5c324c2f198f3a60cf5bdd7a5d3b45b005bbed29544a48d4"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.81/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "013f74f281f720fd815763a25aa90afa55ec433607595770e585058787681b98"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.81/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "608d2ca26c5bee17a532ad02120592538647d3fa4f9e9623b729c36308934eed"
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
