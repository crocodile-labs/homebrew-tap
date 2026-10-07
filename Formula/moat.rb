class Moat < Formula
  desc "Policy guard for AI coding agents: decides allow, ask or deny for every tool call from Claude Code, Codex and Cursor, configures Claude Code's and Codex's own OS sandboxes from the same policy, and keeps a local audit log."
  homepage "https://github.com/crocodile-labs/openmoat"
  version "0.1.0-alpha.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.0-alpha.3/openmoat-aarch64-apple-darwin.tar.xz"
      sha256 "90ec8ac06207b2eb86641ff6ba2299308ae5181551b01953b5bc9ab3e062e9c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.0-alpha.3/openmoat-x86_64-apple-darwin.tar.xz"
      sha256 "05c54688a3b7660258cf8ed936d6f133b5532cff4a30f190ed67a3245ef8be44"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.0-alpha.3/openmoat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "edb5beba83c24115ef35638ac3be44ddc5c281b3a46b3e60062c145874026146"
    end
    if Hardware::CPU.intel?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.0-alpha.3/openmoat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0bc450f072ad9bc04414b76841ddf93fbbfb126011f19c388bae354ca241bb10"
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
