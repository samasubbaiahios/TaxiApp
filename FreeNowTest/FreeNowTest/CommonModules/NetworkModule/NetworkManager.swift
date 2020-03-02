//
//  NetworkManager.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 31/07/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation
import UIKit

typealias ResponseHandler = ((NetworkAPIResponse) -> Void)
typealias finishedHandler = (Bool, [TaxiData]) -> Void

class NetworkManager: NSObject {
    private static var sharedManager: NetworkManager!
    
    public static func shared() -> NetworkManager {
        if let sharedObject = sharedManager {
            return sharedObject
        } else {
            sharedManager = NetworkManager()
            return sharedManager
        }
    }
    
    override private init() {
    }
    
    func startLoading(request: RequestProtocol, with completionCallback: @escaping (ResponseHandler)) {
//        let urlRequest = URLRequest.withAuthHeader(from: request)
        let urlRequest = URLRequest(request: request)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 180
        let activeSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = activeSession.dataTask(with: urlRequest) { data, urlResponse, error in
            let response = NetworkAPIResponse(request: request, urlResponse: urlResponse, data: data, error: error)
            completionCallback(response)
        }
        task.resume()
        activeSession.finishTasksAndInvalidate()
    }
}

extension NetworkManager: URLSessionDelegate {
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print(#function)
        if let sessionId = session.configuration.identifier {
            print("session identifier: \(sessionId), thread: \(Thread.current)")
        }
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            print ("didBecomeInvalidWithError: \(error)")
        }
    }
}

extension NetworkManager: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let httpResponse = downloadTask.response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                return
        }
        
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    }
}
