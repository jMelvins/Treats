//
//  NewtworkingService.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 27.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

class NetworkService
{
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    typealias ImageDataHandler = ((Data) -> Void)
    
    func downloadImage(_ completion: @escaping ImageDataHandler)
    {
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch (httpResponse.statusCode) {
                    case 200:
                        if let data = data {
                            completion(data)
                        }
                    default:
                        print(httpResponse.statusCode)
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        })
        
        dataTask.resume()
    }
}
