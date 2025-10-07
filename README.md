# capTUre

Capture, watch, and catalogue TU Wien LectureTube livestreams straight from your terminal.

## Features

- Record livestreams to local files with configurable container formats and passthrough ffmpeg options.
- Watch channels live via mpv without having to look up LectureTube URLs manually.
- Browse a curated list of frequently used TU Wien lecture halls and resolve short aliases to full stream URLs.
- Ships with a spinner-based progress UI and coloured terminal output for better feedback while recording or watching.

## Prerequisites

- `ffmpeg` in `$PATH` for the `record` command.
- `mpv` in `$PATH` for the `watch` command.

## Getting Started

### Build with Zig

```bash
zig build -Doptimize=ReleaseSafe
```

The resulting binary is placed under `zig-out/bin/capTUre`. You can run commands through Zig as well:

```bash
zig build run -- channels --show-urls
```

### Build with Nix

```bash
nix build .#capTUre   # produces result/bin/capTUre
nix develop           # drops you into a shell with zig master, zls, etc.
```

Both commands rely on the `deps.nix` link farm generated from `build.zig.zon` and will fetch the pinned `zig-cli` dependency automatically.

## Usage

### List known channels

```bash
capTUre channels
capTUre channels --show-urls      # include LectureTube links
capTUre channels --show-aliases   # toggle alias display (on by default)
```

The `channels` command prints the curated set from `src/university/Channel.zig`.
Aliases such as `hs7`, `audimax`, or the full stream slug resolve to canonical URLs.

### Record a livestream

```bash
capTUre record --channel hs8
capTUre record --channel https://live-cdn-2.video.tuwien.ac.at/... --output-file lecture.ts
capTUre record --channel gm1 --format mkv --ffmpeg-opts "-t=00:30:00"
```

- The channel value may be a friendly alias, the human-readable name, or a full LectureTube URL.
- If `--output-file` is omitted, capTUre stores the stream as `capTUre-<unix-timestamp>.ts`.
- Additional `--ffmpeg-opts` arguments are forwarded verbatim (flag is repeatable).

### Watch a livestream

```bash
capTUre watch --channel gm2
```

This spawns `mpv` with the correct referrer header so you can monitor the stream without manual URL lookups.

## Development

- Run tests: `zig build test` (or `nix build .#capTUre` for a full package build).
- Format code using `zig fmt` (Zig handles formatting on save/build).
- Dependencies are declared in `build.zig.zon`; update them via `zig fetch --save …` followed by regenerating `deps.nix` (e.g. with `zon2nix`).

## License

Licensed under the GNU Affero General Public License v3.0. See `LICENSE` for details.

