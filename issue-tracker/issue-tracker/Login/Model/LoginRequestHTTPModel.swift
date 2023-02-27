//
//  LoginRequestHTTPModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/26.
//

import Foundation
import RxSwift

class LoginRequestHTTPModel: RequestHTTPModel {
    static let defaultErrorMessage = "처리 중 알 수 없는 오류가 발생하였습니다."
    var disposeBag = DisposeBag()
    
    /// 로그인 요청 합니다.
    ///
    /// success = LoginResponse 타입의 ResponseBody 를 전달받았다.
    /// failure = 에러 코드 혹은
    func requestLogin(id: String?, password: String?) -> Single<LoginResponse> {
        guard let id = id, let password = password else {
            return Single.error(ErrorResponseBody.message("Id or Password not found."))
        }
        
        return Single.create { [weak self] observer in
            self?.builder.setBody(["id": id, "password": password])
            self?.builder.setHTTPMethod("POST")
            self?.builder.pathArray = ["members", "signin"]
            
            guard let self = self, let request = self.builder.getRequest() else {
                observer(.failure(ErrorResponseBody.message(Self.defaultErrorMessage)))
                return Disposables.create()
            }
            
            return URLSession.shared.rx.response(request: request)
                .subscribe(onNext: { requested in
                    let model = HTTPResponseModel()
                    
                    guard requested.response.statusCode != 401 else {
                        observer(.failure(ErrorResponseBody.errorCode(1001)))
                        return
                    }
                    
                    guard 200 ..< 300 ~= requested.response.statusCode, let loginResponse = model.getDecoded(from: requested.data, as: LoginResponse.self) else {
                        if let errorCode = model.getErrorCodeResponse(from: requested.data) {
                            observer(.failure(ErrorResponseBody.errorCode(errorCode)))
                        } else {
                            observer(.failure(
                                ErrorResponseBody.message(model.getMessageResponse(from: requested.data) ?? Self.defaultErrorMessage)
                            ))
                        }
                        
                        return
                    }
                    
                    observer(.success(loginResponse))
                })
        }
    }
    
    func loginTest() -> Single<Int> {
        Single.create { [weak self] observer in
            self?.builder.pathArray = ["auth", "test"]
            
            guard let self = self, let request = self.builder.getRequest() else {
                observer(.failure(ErrorResponseBody.message(Self.defaultErrorMessage)))
                return Disposables.create()
            }
            
            return URLSession.shared.rx.response(request: request)
                .subscribe(onNext: { requested in
                    let model = HTTPResponseModel()
                    
                    guard requested.response.statusCode != 401 else {
                        observer(.failure(ErrorResponseBody.errorCode(1004)))
                        return
                    }
                    
                    guard 200 ..< 300 ~= requested.response.statusCode, let memberId = model.getDecoded(from: requested.data, as: Int.self) else {
                        if let errorCode = model.getErrorCodeResponse(from: requested.data) {
                            observer(.failure(ErrorResponseBody.errorCode(errorCode)))
                        } else {
                            observer(.failure(
                                ErrorResponseBody.message(model.getMessageResponse(from: requested.data) ?? Self.defaultErrorMessage)
                            ))
                        }
                        
                        return
                    }
                    
                    observer(.success(memberId))
                })
        }
    }
    
    func refreshAccessToken() -> Single<RefreshLoginResponse> {
        Single.create { [weak self] observer in
            self?.builder.pathArray = ["auth", "reissue"]
            
            guard let self = self, var request = self.builder.getRequest() else {
                observer(.failure(ErrorResponseBody.message(Self.defaultErrorMessage)))
                return Disposables.create()
            }
            
            guard let refreshToken = HTTPCookieStorage.shared.refreshToken else {
                observer(.failure(ErrorResponseBody.errorCode(1004)))
                return Disposables.create()
            }
            
            request.setValue("refresh_token="+refreshToken, forHTTPHeaderField: "Cookie")
            
            return URLSession.shared.rx.response(request: request)
                .subscribe(onNext: { requested in
                    let model = HTTPResponseModel()
                    
                    guard requested.response.statusCode != 401 else {
                        observer(.failure(ErrorResponseBody.errorCode(1001)))
                        return
                    }
                    
                    guard 200 ..< 300 ~= requested.response.statusCode, let loginResponse = model.getDecoded(from: requested.data, as: RefreshLoginResponse.self) else {
                        if let errorCode = model.getErrorCodeResponse(from: requested.data) {
                            observer(.failure(ErrorResponseBody.errorCode(errorCode)))
                        } else {
                            observer(.failure(
                                ErrorResponseBody.message(model.getMessageResponse(from: requested.data) ?? Self.defaultErrorMessage)
                            ))
                        }
                        
                        return
                    }
                    
                    observer(.success(loginResponse))
                })
        }
    }
}

enum LoginValidationError: Error {
    case urlError
    case responseError
    case noneCase
}

struct LoginResponse: Decodable {
    var memberResponse: MemberResponse
    var accessToken: AccessToken
    var refreshToken: String?
    var errorMessage: String?
    var errorCode: Int?
}

extension LoginResponse {
    func setUserDefaults() {
        UserDefaults.standard.setValue(self.accessToken.token, forKey: "accessToken")
        UserDefaults.standard.setValue(self.memberResponse.profileImage, forKey: "profileImage")
        UserDefaults.standard.setValue(self.memberResponse.id, forKey: "memberId")
    }
    
    static func removeUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "profileImage")
        UserDefaults.standard.removeObject(forKey: "memberId")
    }
}

struct RefreshLoginResponse: Decodable {
    var signUpFormData: MemberSignedData?
    var signInMember: MemberResponse
    var accessToken: AccessToken
}

extension RefreshLoginResponse {
    func setUserDefaults() {
        UserDefaults.standard.setValue(self.accessToken.token, forKey: "accessToken")
        UserDefaults.standard.setValue(self.signInMember.profileImage, forKey: "profileImage")
        UserDefaults.standard.setValue(self.signInMember.id, forKey: "memberId")
    }
    
    static func removeUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "profileImage")
        UserDefaults.standard.removeObject(forKey: "memberId")
    }
}

struct MemberSignedData: Decodable {
    let resourceOwnerId: String
    let email: String
    let profileImage: String
}

struct MemberResponse: Decodable {
    var id: Int
    var email: String
    var nickname: String
    var profileImage: String
}

struct AccessToken: Decodable {
    var token: String
    var errorType: String?
}

enum ErrorResponseBody: Error, Codable {
    case errorCode(Int)
    case message(String?)
    
    /// [Notice] Only Use when alert. It is dissembling Error itself.
    func getErrorMessage() -> String? {
        switch self {
        case .errorCode(let code):
            return code.decodeAsError()
        case .message(let message):
            return message
        }
    }
}
