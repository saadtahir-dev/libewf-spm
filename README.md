# libewf-spm

A Swift Package (SPM) that wraps [libewf](https://github.com/libyal/libewf) by Joachim Metz as a universal static library for reading Expert Witness Format (EWF / EnCase) forensic disk images on macOS, with bundled mount and info tools.

---

## What This Is

`libewf-spm` provides a Swift API and prebuilt binaries for working with EWF (`.e01`, `.ex01`, `.s01`) forensic images on macOS. It wraps libewf behind static targets and exposes version queries, bundled tool resolution, and C headers for direct library access.

The package ships prebuilt universal fat static libraries for libewf and all libyal dependencies, plus bundled command-line tools — no separate libewf installation, Homebrew, or OpenSSL required.

---

## Requirements

- macOS 12.0+
- Xcode 15+
- [macFUSE](https://osxfuse.github.io/) 5.x — required at runtime for `ewfmount` only

> **No Homebrew dependencies.** OpenSSL, zlib, and bzip2 are either statically linked or provided by macOS system libraries.

---

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/saadtahir-dev/libewf-spm.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "LibEWF", package: "libewf-spm")
        ]
    )
]
```

For local development alongside other forensic packages:

```swift
dependencies: [
    .package(path: "../libewf-spm")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "LibEWF", package: "libewf-spm")
        ]
    )
]
```

Or add via Xcode: **File → Add Package Dependencies** → paste the repo URL.

---

## Usage

```swift
import LibEWF

// Get library version
let version = EWFReader.getVersion()
print("libewf version: \(version)")

// Resolve bundled tools (for mounting via Process)
if let ewfmount = EWFToolLocator.bundledToolPath("ewfmount"),
   let ewfinfo  = EWFToolLocator.bundledToolPath("ewfinfo") {
    print("ewfmount: \(ewfmount)")
    print("ewfinfo:  \(ewfinfo)")
    // Launch ewfmount with Process, or use ImageMounter
}
```

For programmatic byte-level reads, use the `CLibEWF` module and libewf C APIs (`libewf_handle_t`) via the shipped headers in `Sources/CLibEWF/include`.

---

## Package Targets

| Target | Description |
|---|---|
| `CLibEWF` | Static libewf + all libyal deps, no FUSE. Use for reading EWF images in-process. |
| `CLibEWFFuse` | Static libewf + all libyal deps, FUSE-enabled. Use when you need to launch `ewfmount`. |
| `CLibEWFResources` | Bundled ewf* command-line tools as SPM resources. |
| `LibEWF` | Swift wrapper. Depends on `CLibEWF` + `CLibEWFResources`. |

---

## API

### `EWFReader`

| Method | Description |
|---|---|
| `static func getVersion() -> String` | Returns the linked libewf version string (e.g. `"20251220"`). |

---

### `EWFToolLocator`

Resolves paths to bundled executables in the `CLibEWFResources` resource bundle (`bin/`). Results are cached after the first successful lookup.

| Method | Description |
|---|---|
| `static func bundledToolPath(_ tool: String) -> String?` | Returns the filesystem path to a bundled tool by name, or `nil` if not found or not executable. |

Common tool names: `"ewfmount"`, `"ewfinfo"`, `"ewfexport"`, `"ewfacquire"`, `"ewfverify"`.

---

### `CLibEWF` / `CLibEWFFuse`

C modules exposing `libewf.h` and related headers. Linked via `-Xlinker` on the prebuilt static archives. Use for direct `libewf_handle_*` access when you need read/write beyond the Swift convenience layer.

---

## Supported Formats

| Format | Extension | Support |
|---|---|---|
| EnCase / EWF (EWF-E01) | `.e01` | Supported |
| EnCase / EWF (EWFX) | `.ex01` | Supported |
| SMART / s01 | `.s01` | Supported |
| Split segments | `.e01`, `.e02`, … | Supported (open first segment; libewf globs the set) |

---

## Bundled Static Libraries

All libraries ship as universal fat binaries (arm64 + x86_64) in `Sources/CLibEWF/` and `Sources/CLibEWFFuse/`:

| Library | Purpose |
|---|---|
| `libewf.a` | EWF read/write implementation |
| `libbfio.a` | Basic file I/O abstraction |
| `libcaes.a` | AES encryption support |
| `libcdata.a` | Data structures |
| `libcdatetime.a` | Date/time handling |
| `libcerror.a` | Error handling |
| `libcfile.a` | File abstraction |
| `libclocale.a` | Locale support |
| `libcnotify.a` | Notification support |
| `libcpath.a` | Path handling |
| `libcsplit.a` | String splitting |
| `libcthreads.a` | Thread support |
| `libfcache.a` | File cache |
| `libfdata.a` | File data |
| `libfdatetime.a` | File date/time |
| `libfguid.a` | GUID support |
| `libfvalue.a` | File value |
| `libhmac.a` | HMAC hashing |
| `libodraw.a` | Optical disk raw access |
| `libsmdev.a` | Storage media device |
| `libsmraw.a` | Storage media raw access |
| `libuna.a` | Unicode/ASCII conversion |

The following system libraries are linked at build time — no bundling required:

| Library | Source |
|---|---|
| `libz` | macOS system (`/usr/lib/libz.1.dylib`) |
| `libbz2` | macOS system (`/usr/lib/libbz2.1.0.dylib`) |

OpenSSL is **statically linked** into the libraries — no Homebrew or system OpenSSL required.

---

## Bundled Tools

Prebuilt command-line tools ship in `Sources/CLibEWFResources/bin/` and are resolved at runtime via `EWFToolLocator`:

| Tool | Purpose | macFUSE required |
|---|---|---|
| `ewfmount` | Mount an EWF image as a raw block device via FUSE | Yes |
| `ewfinfo` | Print image metadata and integrity information | No |
| `ewfexport` | Export EWF image to another format | No |
| `ewfacquire` | Acquire a disk image into EWF format | No |
| `ewfverify` | Verify EWF image integrity | No |

| Property | Value |
|---|---|
| Architectures | Universal (arm64 + x86_64) |
| FUSE linkage | `libfuse3.4.dylib` (macFUSE 5.x) |
| OpenSSL linkage | Statically linked — no runtime dependency |
| Resolution | `CLibEWFResources` SPM resource bundle |

---

## macFUSE Compatibility

`ewfmount` requires macFUSE to be installed and loaded. The bundled binary links against macFUSE's `libfuse3.4.dylib`.

libewf's FUSE mount code was patched for macFUSE 5.x: a `fuse_darwin_attr` boundary layer in `ewftools/mount_fuse.c` maps between POSIX `struct stat` fields and macFUSE's Darwin-specific `fuse_darwin_attr` fields at the callback boundary.

For build steps, patch details, and troubleshooting, see the [swift-forensic-playbook](https://github.com/saadtahir-dev/swift-forensic-playbook).

---

## Building From Source

See the [swift-forensic-playbook](https://github.com/saadtahir-dev/swift-forensic-playbook) for the complete step-by-step guide covering:

- Building libewf and all 21 libyal dependencies as universal static libraries
- Building with static OpenSSL, zlib, and bzip2 support
- Applying the macFUSE 5.x `fuse_darwin_attr` patch to `ewftools/mount_fuse.c`
- Bundling `ewfmount` and other ewf tools into the SPM resource target
- Creating the SPM package structure

---

## License

MIT — see [LICENSE](./LICENSE)

---

## Related

- [swift-forensic-playbook](https://github.com/saadtahir-dev/swift-forensic-playbook) — Build guides for forensic image libraries as Swift Packages
- [libyal/libewf](https://github.com/libyal/libewf) — Upstream libewf library
- [ImageMounter](https://github.com/saadtahir-dev/ImageMounter) — macOS forensic image mounting service (uses `EWFToolLocator` for EWF mounting)
