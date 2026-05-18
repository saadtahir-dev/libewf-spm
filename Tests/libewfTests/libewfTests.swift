//
//  libewfTests.swift
//  libewf
//
//  Created by Saad Tahir on 15/05/2026.
//   -- GitHub   : https://github.com/saadtahir-dev
//   -- LinkedIn : https://www.linkedin.com/in/saadtahir-dev
//

import XCTest
@testable import libewf

final class libewfTests: XCTestCase {
    func testVersion() {
        let version = EWFReader.getVersion()
        XCTAssertFalse(version.isEmpty)
        print("libewf version: \(version)")
    }
}
