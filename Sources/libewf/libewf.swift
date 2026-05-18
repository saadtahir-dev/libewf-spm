//
//  libewf.swift
//  libewf
//
//  Created by Saad Tahir on 15/05/2026.
//   -- GitHub   : https://github.com/saadtahir-dev
//   -- LinkedIn : https://www.linkedin.com/in/saadtahir-dev
//

import CLibEWF

public struct EWFReader {
    public static func getVersion() -> String {
        let version = libewf_get_version()
        return String(cString: version!)
    }
}
