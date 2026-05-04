# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.99"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.99/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "0b793739be589809915499848e487af88309bbcef34cf4aeb775d28c4dcf80b2"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.99/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "8507438cb1c02b8f7bffe44afcc3926ca488d436e11114fbf604f8cb7e44072a"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.99/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "8bd90be91c902089b3315ab33e09cab9169eae51919846b6ebff411d553906ff"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.99/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "400a8780634f566a273047bb5fa62808a5fc5f7f63fa42daa6d4fcc17518aa24"
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
