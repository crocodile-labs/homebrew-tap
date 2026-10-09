class Moat < Formula
  desc "Policy guard for AI coding agents: decides allow, ask or deny for every tool call from Claude Code, Codex and Cursor, configures Claude Code's and Codex's own OS sandboxes from the same policy, and keeps a local audit log."
  homepage "https://github.com/crocodile-labs/openmoat"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.1/openmoat-aarch64-apple-darwin.tar.xz"
      sha256 "eb5452d1b74824241944337502bd569769e3a14f80e1a9710fdbccd54eab7883"
    end
    if Hardware::CPU.intel?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.1/openmoat-x86_64-apple-darwin.tar.xz"
      sha256 "7f67305e416c5df0b25f61dee7cbbcdebc2c5c0654bd6faa219b0f3f2ccb8ac3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.1/openmoat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1bac77f60595a5bb22270b2ef51547815cedcb292d21208587bfd250dab0a12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.1/openmoat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e8f5b987b2b4d3a4e3914e6edec12f251c13a774719dd313622d344a7f66ae7b"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "moat"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "moat"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "moat"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "moat"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
