//
//  HealthPlanetClient.swift
//  
//
//  Created by 赤迫亮太 on 2022/11/08.
//

import Foundation
import PromiseKit

public struct HealthPlanetClient {
    private let clientId: String
    private let clientSecret: String
    private let refreshToken: String
    
    public init(clientId: String, clientSecret: String, refreshToken: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.refreshToken = refreshToken
    }
    
    public func fetch(from: String = "", to: String = "", handler: @escaping (Swift.Result<InnerScan, Error>) -> Void) {
        
        getToken()
            .then { accessToken in
                getInnerScanData(accessToken: accessToken, from: from, to: to)
            }
            .done { innerScan in
                handler(.success(innerScan))
            }
            .catch { error in
                handler(.failure(Error(from: error)))
            }
    }
    
    private func getToken() -> Promise<String> {
        let request = WealthPlanetOAuthTokenRequest(clientId: clientId, clientSecret: clientSecret, refreshToken: refreshToken)
        return APIClient.exec(request: request)
            .map { $0.result.accessToken }
    }

    private func getInnerScanData(accessToken: String, from: String, to: String) -> Promise<InnerScan> {
        let request = WealthPlanetStatusInnerScanRequest(accessToken: accessToken, from: from, to: to)
        return APIClient.exec(request: request)
            .map { InnerScan(from: $0.result) }
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
