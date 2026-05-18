//
//  EWFToolLocator.swift
//  libewf
//
//  Created by Saad Tahir on 15/05/2026.
//   -- GitHub   : https://github.com/saadtahir-dev
//   -- LinkedIn : https://www.linkedin.com/in/saadtahir-dev
//

import Foundation
import CLibEWFResources

public enum EWFToolLocator {

    private static let lock = NSLock()
    private static var cache: [String: String] = [:]

    public static func bundledToolPath(_ tool: String) -> String? {
        // Fast path (cache)
        lock.lock()
        if let cached = cache[tool] {
            lock.unlock()
            return cached
        }
        lock.unlock()

        // Resolve from Clibewf bundle directly
        if let url = CLibEWFBundle.bundle.url(
            forResource: tool,
            withExtension: nil,
            subdirectory: "bin"
        ) {

            let path = url.path

            // Ensure executable (macOS quirk)
            try? FileManager.default.setAttributes(
                [.posixPermissions: 0o755],
                ofItemAtPath: path
            )

            if FileManager.default.isExecutableFile(atPath: path) {

                lock.lock()
                cache[tool] = path
                lock.unlock()

                print("[EWFToolLocator] Cached \(tool) -> \(path)")
                return path
            }
        }

        print("[EWFToolLocator] Tool not found in Clibewf bundle: \(tool)")
        return nil
    }
}
