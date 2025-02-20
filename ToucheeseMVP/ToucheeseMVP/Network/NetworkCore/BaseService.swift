//
//  BaseService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/18/25.
//

import Foundation
import Alamofire

class BaseService {
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func performRequest<T: Decodable>(_ fetchRequest: TargetType, decodingType: T.Type) async throws -> T {
        let url = fetchRequest.baseURL + fetchRequest.path
        
        let response = await session.request(
                    url,
                    method: fetchRequest.method,
                    parameters: fetchRequest.parameters,
                    encoding: fetchRequest.encoding,
                    headers: fetchRequest.headers
                )
                .validate()
                .serializingData()
                .response
        
        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.unknown
        }
        
        switch statusCode {
        case 200...299:
            switch response.result {
            case .success(let data):
                // JSON이 아니라 문자열로 디코딩해야하는 경우
                if decodingType == String.self,
                   let stringResponse = String(data: data, encoding: .utf8) {
                    return stringResponse as! T
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    
                    // ResponseWithHeadersProtocol 프로토콜을 준수하는 경우 headers 추가해서 리턴
                    if var responseWithHeaders = decodedData as? ResponseWithHeadersProtocol {
                        responseWithHeaders.headers = response.response?.allHeaderFields as? [String: String]
                        return responseWithHeaders as! T
                    }
                    
                    return decodedData
                } catch {
                    print("\(decodingType) 디코딩 실패: \(error.localizedDescription)")
                    throw NetworkError.decodingFailed(error)
                }
            case .failure(let error):
                print("\(decodingType) 네트워크 요청 실패: \(error.localizedDescription)")
                throw NetworkError.requestFailed(error)
            }
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.unexpectedStatusCode(statusCode)
        }
    }
}
