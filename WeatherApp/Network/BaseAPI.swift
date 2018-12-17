//
//  BaseAPI.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

final class BaseAPI: NSObject {
    
    class func request(_ url: URLConvertible,
                       method: HTTPMethod = .get,
                       parameters: Parameters? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       headers: HTTPHeaders? = nil) -> Observable<DataResponse<Any>> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(url,
                              method: method,
                              parameters: parameters,
                              encoding: encoding,
                              headers: headers)
                .validate()
                .responseJSON { response in
                    observer.onNext(response)
            }
            
            return Disposables.create()
        }
    }
}
