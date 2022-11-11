//
//  File.swift
//  
//
//  Created by 赤迫亮太 on 2022/11/11.
//

import PromiseKit

extension APIClient {
    static func exec<Request: APIRequest>(request: Request) -> Promise<Request.Response> {
        return Promise { seal in
            self.exec(request: request) { result in
                switch result {
                case .success(let response):
                    seal.fulfill(response)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
