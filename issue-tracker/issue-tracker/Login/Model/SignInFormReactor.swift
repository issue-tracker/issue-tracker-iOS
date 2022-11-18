//
//  SignInFormReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/17.
//

import ReactorKit

class SignInFormReactor: Reactor {
    var initialState: State = State.init(id: .init(), password: .init(), email: .init(), nickname: .init())
    
    private let model: SignInFormModel? = {
        guard let url = URL.apiURL else { return nil }
        return SignInFormModel(url)
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
        guard let model else { return .empty() }
        
        switch action {
            
        case .checkIdTextField(let id):
            return model
                .requestCheck(text: id, for: \State.id)
                .map({
                    
                    let state = IDState(text: id, status: $0.result ? .fine : .error, statusText: $0.message)
                    return Mutation.checkIdTextField(state)
                })
            
        case .checkPasswordTextField(let password):
            return model
                .requestCheck(text: password, for: \State.password)
                .map({
                    
                    let state = PasswordState(
                        text: password,
                        status: $0.result ? .fine : .error,
                        statusText: $0.message)
                    return Mutation.checkPasswordTextField(state)
                })
            
        case .checkPasswordConfirmTextField(let password):
            return Observable<Mutation>
                .create({ observer in
                    
                    let result = (password == self.currentState.password.text)
                    let state = PasswordState(
                        text: password,
                        confirmStatus: result ? .none : .error,
                        confirmStatusText: self.currentState.password.statusText)
                    
                    observer.onNext(Mutation.checkPasswordConfirmTextField(state))
                    return Disposables.create()
                })
            
        case .checkEmailTextField(let email):
            return model
                .requestCheck(text: email, for: \State.email)
                .map({
                    
                    let state = EmailState(
                        text: email,
                        status: $0.result ? .fine : .error,
                        statusText: $0.message)
                    return Mutation.checkEmailTextField(state)
                })
            
        case .checkNicknameTextField(let nickname):
            return model
                .requestCheck(text: nickname, for: \State.nickname)
                .map({
                    
                    let state = NicknameState(
                        text: nickname,
                        status: $0.result ? .fine : .error,
                        statusText: $0.message)
                    return Mutation.checkNicknameTextField(state)
                })
            
        case .requestSignIn:
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
                return $0.result ? Mutation.signInSuccess($0.message) : Mutation.signInFailure($0.message)
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
            newState.password.statusText = state.statusText
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
