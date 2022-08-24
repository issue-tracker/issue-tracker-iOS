//
//  RequestTextField.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import UIKit

class RequestTextField: CommonTextField {
    
    var timeInterval: Int = 2
    var requestURL: URL? {
        didSet {
            if let requestURL = requestURL {
                requestModel = RequestHTTPTimerModel(timerInterval: timeInterval, requestURL)
            }
            
        }
    }
    
    private var requestModel: RequestHTTPTimerModel?
    
    /// path components로 설정된 URL에서 맨 마지막에 넣을 문자열
    var optionalTrailingPath: String?
    
    /// 해당 값 이상의 문자에 대해서만 validation을 진행합니다.
    var validateStringCount: UInt = 2
    var resultLabel: ViewBindable?
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        super.textFieldShouldReturn(textField)
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var result = ResponseStatus()
        result.status = .none
        result.isRequesting = true
        
        binding?.bindableHandler?(["result": result], resultLabel ?? self)
        
        return super.textFieldShouldBeginEditing(textField)
    }
    
    override func textFieldDidChangeSelection(_ textField: UITextField) {
        super.textFieldDidChangeSelection(textField)
        if (textField.text?.count ?? 0) > validateStringCount {
            request()
        } else {
            var result = ResponseStatus()
            result.message = "\(validateStringCount)자 이상 입력해주시기 바랍니다."
            result.status = .warning
            result.isRequesting = false
            
            binding?.bindableHandler?(["result": result], resultLabel ?? self)
        }
    }
    
    private func request() {
        guard let path = self.text else { return }
        
        requestModel?.setTimerInterval(timeInterval)
        
        if let optionalTrailingPathComponent = optionalTrailingPath {
            requestModel?.builder.pathArray.append(optionalTrailingPathComponent)
        }
        
        binding?.bindableHandler?(["result": ResponseStatus()], resultLabel ?? self)
        
        requestModel?.requestAsTimer(pathArray: [path]) { result, response in
            
            let model = HTTPResponseModel(response: response)
            guard let bindable = self.resultLabel else { return }
            
            var status = ResponseStatus(status: .error, message: "서버와의 연결이 불안정합니다.")
            status.result = result
            status.isRequesting = false
            
            if let validationSuccess = model.getDecoded(from: result, as: Bool.self) {
                status.status = validationSuccess ? .warning : .acceptable
                status.message = validationSuccess ? "입력값을 다시 확인해주시기 바랍니다." : "이상이 발견되지 않았습니다."
            }
            
            self.binding?.bindableHandler?(["result": result], bindable)
        }
    }
}
