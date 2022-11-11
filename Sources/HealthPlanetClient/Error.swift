//
//  Error.swift
//
//
//  Created by 赤迫亮太 on 2022/10/31.
//

import Foundation

public enum Error: Swift.Error, CustomStringConvertible {
    case withComment(String)
    case foundationError(Swift.Error)
    
    public var description: String {
        switch self {
        case .withComment(let comment):
            return comment
        case .foundationError(let error):
            return error.localizedDescription
        }
    }
    
    init(from error: Swift.Error) {
        if let withComment = error as? Error {
            self = withComment
        } else {
            self = .foundationError(error)
        }
    }
}
