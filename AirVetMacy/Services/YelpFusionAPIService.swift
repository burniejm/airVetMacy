//
//  YelpFusionAPIService.swift
//  AirVetMacy
//
//  Created by John Macy on 10/1/21.
//

/*
 There are lots of yelp fusion wrappers out there. Since I only need one or two endpoints and to demonstrate that I can implement my own API interaction I am foregoing these libraries.
 */

import Foundation

protocol YelpFusionAPI {
    func searchBusinesses(completion: @escaping ((BusinessSearchResponse?) -> Void))
}

protocol Endpoint {
    var clientId: String { get }
    var apiKey: String { get }
    var baseURLString: String { get }
    var path: String { get }
}

extension Endpoint {
    var url: String {
        return baseURLString + path
    }
}

enum APIError: Error {
    case MalformedURL
}

enum YelpFusionApiEndpoints: Endpoint {
    case searchBusinesses

    var clientId: String {
        "2sgfljZzv28k2YhzAiKRYg"
    }

    var apiKey: String {
        "FwqSI10WYrJVBVOKqrFQl2OwAp1Qm9SD4SFJ9mNQPnMCuejDAjia4esVCX_59B1PshIKNjulaFbie943mC2w-v0F5viuAy0UWpoDzoXJc7-3a5KXnF9T9hyze-ZXYXYx"
    }

    var baseURLString: String {
        "https://api.yelp.com/v3/"
    }

    var path: String {
        switch self {

        case .searchBusinesses:
            return "businesses/search"
        }
    }
}

class YelpFusionAPIService: YelpFusionAPI {

    func searchBusinesses(completion: @escaping ((BusinessSearchResponse?) -> Void)) {
        let endpoint = YelpFusionApiEndpoints.searchBusinesses

        request(endpoint: endpoint) { data, response, err in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let data = data, err == nil
            else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(BusinessSearchResponse.self, from: data)
                completion(response)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }

    private func request(endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: endpoint.url) else {
            completion(nil, nil, APIError.MalformedURL)
            return
        }

        let session = URLSession.shared
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(endpoint.apiKey)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: urlRequest) { data, response, error in
            completion(data, response, error)
        }

        task.resume()
    }
}
