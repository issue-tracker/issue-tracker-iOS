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
                .map({
                    var resultStatus: TextFieldStatus = $0.0.isSuccess ? .fine : .error
                    if id.count < 8 {
                        resultStatus = .warning
                    }
                    
                    let state = IDState(text: id, status: resultStatus, statusText: $0.1)
                    return Mutation.checkIdTextField(state)
                })
            
        case .checkPasswordTextField(let password):
            return Observable<Mutation>
                .create({ observer in
                    var status: TextFieldStatus = .error
                    var message = ""
                    
                    if password.count < 8 {
                        status = .warning
                        message = "8자 이상 입력해주시기 바랍니다."
                    } else if password.contains(where: {Int(String($0)) != nil}) == false {
                        status = .error
                        message = "숫자가 포함되어 있지 않습니다."
                    }
                    
                    let state = PasswordState(
                        text: password,
                        status: status,
                        statusText: message)
                    
                    observer.onNext(Mutation.checkPasswordTextField(state))
                    return Disposables.create()
                })
            
        case .checkPasswordConfirmTextField(let password):
            return Observable<Mutation>
                .create({ observer in
                    
                    let status: TextFieldStatus = (password == self.currentState.password.text) ? .fine : .warning
                    let message = status == .fine ? "이상이 발견되지 않았습니다." : "비밀번호가 일치하지 않습니다."
                    
                    let state = PasswordState(
                        text: password,
                        confirmStatus: status,
                        confirmStatusText: message)
                    
                    observer.onNext(Mutation.checkPasswordConfirmTextField(state))
                    return Disposables.create()
                })
            
        case .checkEmailTextField(let email):
            guard let model = inputCheckModel else { return .empty() }
            return model
                .requestCheck(text: email, for: \State.email)
                .map({
                    
                    var resultStatus: TextFieldStatus = $0.0.isSuccess ? .fine : .error
                    if email.contains(where: {String($0) == "@" || String($0) == "."}) == false {
                        resultStatus = .warning
                    }
                    
                    let state = EmailState(
                        text: email,
                        status: resultStatus,
                        statusText: $0.1)
                    return Mutation.checkEmailTextField(state)
                })
            
        case .checkNicknameTextField(let nickname):
            guard let model = inputCheckModel else { return .empty() }
            return model
                .requestCheck(text: nickname, for: \State.nickname)
                .map({
                    
                    var resultStatus: TextFieldStatus = $0.0.isSuccess ? .fine : .error
                    if nickname.count >= 4 {
                        resultStatus = .warning
                    }
                    
                    let state = NicknameState(
                        text: nickname,
                        status: resultStatus,
                        statusText: $0.1)
                    return Mutation.checkNicknameTextField(state)
                })
            
        case .requestSignIn:
            guard let model = signInModel else { return .empty() }
            let allStatus: [TextFieldStatus] = [
                currentState.id.status,
                currentState.password.status,
                currentState.password.confirmStatus,
                currentState.email.status,
                currentState.nickname.status
            ]
            
            if let suspiciousIndex = allStatus.firstIndex(where: { $0 == .none || $0 == .error }) {
                return Observable.error(SignInError.getError(from: suspiciousIndex))
            }
            
            let body: [String: String] = [
                "signInId": currentState.id.text,
                "password": currentState.password.text,
                "email": currentState.email.text,
                "nickname": currentState.nickname.text,
                "profileImage": ""
            ]
            
            return model.requestSignIn(body).map({
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
