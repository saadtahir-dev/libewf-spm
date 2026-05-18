// swift-tools-version:5.9
import PackageDescription
import Foundation

let packageDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path

let package = Package(
    name: "libewf-spm",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "CLibEWF",     targets: ["CLibEWF"]),
        .library(name: "CLibEWFFuse", targets: ["CLibEWFFuse"]),
        .library(name: "libewf",      targets: ["libewf"]),
        .library(name: "LibEWF",      targets: ["libewf"]),
    ],
    targets: [
        .target(
            name: "CLibEWF",
            path: "Sources/CLibEWF",
            sources: ["placeholder.c"],
            publicHeadersPath: "include",
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libewf.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libbfio.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcaes.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcdata.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcdatetime.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcerror.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcfile.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libclocale.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcnotify.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcpath.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcsplit.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libcthreads.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libfcache.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libfdata.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libfdatetime.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libfguid.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libfvalue.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libhmac.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libodraw.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libsmdev.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libsmraw.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWF/libuna.a",
                ]),
                .linkedLibrary("z"),
                .linkedLibrary("bz2"),
                .linkedLibrary("pthread"),
            ]
        ),
        .target(
            name: "CLibEWFFuse",
            path: "Sources/CLibEWFFuse",
            sources: ["placeholder.c"],
            publicHeadersPath: "include",
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libewf.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libbfio.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcaes.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcdata.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcdatetime.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcerror.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcfile.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libclocale.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcnotify.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcpath.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcsplit.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libcthreads.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libfcache.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libfdata.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libfdatetime.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libfguid.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libfvalue.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libhmac.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libodraw.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libsmdev.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libsmraw.a",
                    "-Xlinker", "\(packageDirectory)/Sources/CLibEWFFuse/libuna.a",
                    "-L/usr/local/lib",
                    "-lfuse",
                ]),
                .linkedLibrary("z"),
                .linkedLibrary("bz2"),
                .linkedLibrary("pthread"),
            ]
        ),
        .target(
            name: "CLibEWFResources",
            path: "Sources/CLibEWFResources",
            resources: [
                .copy("bin")
            ]
        ),
        .target(
            name: "libewf",
            dependencies: ["CLibEWF", "CLibEWFResources"],
            path: "Sources/LibEWF"
        ),
        .testTarget(
            name: "LibEWFTests",
            dependencies: ["libewf"],
            path: "Tests/libewfTests"
        ),
    ]
)
