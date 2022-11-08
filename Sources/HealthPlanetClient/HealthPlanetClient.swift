//
//  HealthPlanetClient.swift
//  
//
//  Created by 赤迫亮太 on 2022/11/08.
//

import Foundation

public struct HealthPlanetClient {
    private let clientId: String
    private let clientSecret: String
    private let refreshToken: String
    
    public init(clientId: String, clientSecret: String, refreshToken: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.refreshToken = refreshToken
    }
    
    public func fetch(from: String = "", to: String = "", handler: @escaping (Result<InnerScan, Error>) -> Void) {
        
        getToken { result in
            switch result {
            case .success(let accessToken):
                getInnerScanData(accessToken: accessToken, from: from, to: to, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func getToken(handler: @escaping (Result<String, Error>) -> Void) {
        let request = WealthPlanetOAuthTokenRequest(clientId: clientId, clientSecret: clientSecret, refreshToken: refreshToken)
        APIClient.exec(request: request) { result in
            switch result {
            case .success(let response):
                handler(.success(response.result.accessToken))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    private func getInnerScanData(accessToken: String, from: String, to: String, handler: @escaping (Result<InnerScan, Error>) -> Void) {
        let request = WealthPlanetStatusInnerScanRequest(accessToken: accessToken, from: from, to: to)
        APIClient.exec(request: request) { result in
            switch result {
            case .success(let response):
                guard !response.result.data.isEmpty else {
                    handler(.failure(Error.withComment("Empty Data Response")))
                    return
                }
                handler(.success(InnerScan(from: response.result)))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

}

public struct InnerScan: Codable {
    public let birthDate: String
    public let data: [Data]
    public let height: Decimal
    public let sex: String
    
    public struct Data: Codable {
        public let date: Date
        public let type: DataType
        public let value: Decimal
    }
    
    public enum DataType: String, Codable {
        case weight = "kg"
        case fatPercentage = "%"
        
        fileprivate init(tag: WealthPlanetStatusInnerScanResponse.Tag) {
            switch tag {
            case .weight:
                self = .weight
            case .fatPercentage:
                self = .fatPercentage
            }
        }
    }
    
    init(from: WealthPlanetStatusInnerScanResponse.Result) {
        self.birthDate = from.birthDate
        self.data = from.data.map { fromData in
            Data(date: fromData.date, type: DataType(tag: fromData.tag), value: fromData.keydata)
        }
        self.height = from.height
        self.sex = from.sex
    }
}
