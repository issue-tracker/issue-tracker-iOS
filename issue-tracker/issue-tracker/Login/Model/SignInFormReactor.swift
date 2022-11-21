//
//  SignInFormReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/17.
//

import ReactorKit

class SignInFormReactor: Reactor {
    var initialState: State = State.init(id: .init(), password: .init(), email: .init(), nickname: .init())
    
    private let signInModel: SignInFormModel? = {
        guard let url = URL.apiURL else { return nil }
        return SignInFormModel(url)
    }()
    
    private let inputCheckModel: SignInInputCheckModel? = {
        guard let url = URL.membersApiURL else { return nil }
        return SignInInputCheckModel(url, bufferSeconds: 2)
    }()
    
    private let inputValidationModel = SignInValidationModel()
    
    enum TextFieldStatus {
        case warning
        case error
        case fine
        case none
    }
    
    enum Action {
        case checkIdTextField(String)
        case checkPasswordTextField(String)
        case checkPasswordConfirmTextField(String)
        case checkEmailTextField(String)
        case checkNicknameTextField(String)
        case requestSignIn
    }
    
    struct State {
        var id: IDState
        var password: PasswordState
        var email: EmailState
        var nickname: NicknameState
        
        @Pulse var signInMessage: String = ""
        
        var allStatus: [TextFieldStatus] {
            [id.status, password.status, password.confirmStatus, email.status, nickname.status]
        }
    }
    
    struct IDState {
        var text: String = ""
        @Pulse var status: TextFieldStatus = .none
        @Pulse var statusText: String = ""
    }
    
    struct PasswordState {
        var text: String = ""
        @Pulse var status: TextFieldStatus = .none
        @Pulse var statusText: String = ""
        @Pulse var confirmStatus: TextFieldStatus = .none
        @Pulse var confirmStatusText: String = ""
    }
    
    struct EmailState {
        var text: String = ""
        @Pulse var status: TextFieldStatus = .none
        @Pulse var statusText: String = ""
    }
    
    struct NicknameState {
        var text: String = ""
        @Pulse var status: TextFieldStatus = .none
        @Pulse var statusText: String = ""
    }
    
    enum Mutation {
        case checkIdTextField(IDState)
        case checkPasswordTextField(PasswordState)
        case checkPasswordConfirmTextField(PasswordState)
        case checkEmailTextField(EmailState)
        case checkNicknameTextField(NicknameState)
        case signInSuccess(String) // message
        case signInFailure(String) // message
    }
    
    // MARK: - Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .checkIdTextField(let id):
            guard let model = inputCheckModel else { return .empty() }
            return model
                .requestCheck(text: id, for: \State.id)
                .compactMap({ [weak self] result in
                    guard let self else { return nil }
                    
                    return Mutation.checkIdTextField(
                        self.inputValidationModel.checkID(
                            requestResult: result.response.isSuccess,
                            id: id,
                            isDuplicate: result.isDuplicate
                        )
                    )
                })
            
        case .checkPasswordTextField(let password):
            return Observable<Mutation>
                .create({ [weak self] observer in
                    let disposables = Disposables.create()
                    guard let self else { observer.onError(SignInError.unknownError)
                        return disposables
                    }
                    
                    observer.onNext(Mutation.checkPasswordTextField(
                        self.inputValidationModel.checkPassword(password: password)
                    ))
                    return disposables
                })
            
        case .checkPasswordConfirmTextField(let password):
            return Observable<Mutation>
                .create({ [weak self] observer in
                    let disposables = Disposables.create()
                    guard let self else { observer.onError(SignInError.unknownError)
                        return disposables
                    }
                    
                    observer.onNext(Mutation.checkPasswordConfirmTextField(
                        self.inputValidationModel.checkConfirmPassword(
                            password: self.currentState.password.text,
                            confirmPassword: password
                        )
                    ))
                    
                    return disposables
                })
            
        case .checkEmailTextField(let email):
            guard let model = inputCheckModel else { return .empty() }
            return model
                .requestCheck(text: email, for: \State.email)
                .compactMap({ [weak self] result in
                    guard let self else { return nil }
                    
                    return Mutation.checkEmailTextField(
                        self.inputValidationModel.checkEmail(
                            requestResult: result.response.isSuccess,
                            email: email,
                            isDuplicate: result.isDuplicate
                        )
                    )
                })
            
        case .checkNicknameTextField(let nickname):
            guard let model = inputCheckModel else { return .empty() }
            return model
                .requestCheck(text: nickname, for: \State.nickname)
                .compactMap({ [weak self] result in
                    guard let self else { return nil }
                    
                    return Mutation.checkNicknameTextField(
                        self.inputValidationModel.checkNickname(
                            requestResult: result.response.isSuccess,
                            nickname: nickname,
                            isDuplicate: result.isDuplicate
                        )
                    )
                })
            
        case .requestSignIn:
            if let suspiciousIndex = inputValidationModel.checkRequestEnabled(currentState) {
                return Observable<Mutation>.just(
                    Mutation.signInFailure(SignInError.getErrorMessage(from: suspiciousIndex))
                )
            }
            
            guard let model = signInModel else {
                return Observable.error(SignInError.unknownError)
            }
            
            return model.requestSignIn([
                "signInId": currentState.id.text,
                "password": currentState.password.text,
                "email": currentState.email.text,
                "nickname": currentState.nickname.text,
                "profileImage": ""
            ]).map({
                return $0.0.isSuccess ? Mutation.signInSuccess($0.1) : Mutation.signInFailure($0.1)
            })
        }
    }
    
    func transform(state: Observable<State>) -> Observable<State> { return state }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .checkIdTextField(let state):
            newState.id.text = state.text
            newState.id.status = state.status
            newState.id.statusText = state.statusText
        case .checkPasswordTextField(let state):
            newState.password.text = state.text
            newState.password.status = state.status
            newState.password.statusText = state.statusText
        case .checkPasswordConfirmTextField(let state):
            newState.password.confirmStatus = state.confirmStatus
            newState.password.confirmStatusText = state.confirmStatusText
        case .checkEmailTextField(let state):
            newState.email.text = state.text
            newState.email.status = state.status
            newState.email.statusText = state.statusText
        case .checkNicknameTextField(let state):
            newState.nickname.text = state.text
            newState.nickname.status = state.status
            newState.nickname.statusText = state.statusText
        case .signInSuccess(let message):
            newState.signInMessage = message
        case .signInFailure(let message):
            newState.signInMessage = message
        }
        
        return newState
    }
}

struct SignInResponse: Decodable {
    var id: Int
    var email: String
    var nickname: String
    var profileImage: String
}
