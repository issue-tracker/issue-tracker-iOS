//
//  RequestTextField.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import UIKit

class RequestTextField: CommonTextField {
    
    var timeInterval: Double = 2.0
    var requestURL: URL? {
        didSet {
            if let requestURL = requestURL {
                requestModel = RequestHTTPTimerModel(timerInterval: timeInterval, requestURL)
            }
            
        }
    }
    
    private var requestModel: RequestHTTPTimerModel?
    private var validationModel = TextFieldValidationModel()
    
    /// 해당 값 이상의 문자에 대해서만 validation을 진행합니다.
    var validateStringCount: UInt = 2
    var resultLabel: ViewBindable?
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        super.textFieldShouldReturn(textField)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.count ?? 0) >= validateStringCount {
            request()
        } else {
            var result = ResponseStatus()
            result.message = "\(validateStringCount)자 이상 입력해주시기 바랍니다."
            result.status = .warning
            result.isRequesting = false
            
            binding?.bindableHandler?(["result": result], resultLabel ?? self)
        }
        
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    private func request() {
        guard let path = self.text else { return }
        
        requestModel?.setTimerInterval(timeInterval)
        requestModel?.requestBuilder.setPath(path)
        requestModel?.requestBuilder.setPath("exists")
        
        binding?.bindableHandler?(["result": ResponseStatus()], resultLabel ?? self)
        
        requestModel?.requestAsTimer { [weak self] result, response in
            
            guard let self = self, let bindable = self.resultLabel else {
                return
            }
            
            let result = self.validationModel.validate(for: result)
            
            self.binding?.bindableHandler?(["result": result], bindable)
        }
    }
}

private class TextFieldValidationModel {
    func validate(for response: Result<Data, Error>) -> ResponseStatus {
        var result = ResponseStatus()
        result.result = response
        result.isRequesting = false
        
        guard
            let data = try? response.get(),
            let responseResult = try? JSONDecoder().decode(Bool.self, from: data)
        else {
            
            result.status = .error
            result.message = "서버와의 연결이 불안정합니다."
            return result
        }
        
        result.status = responseResult ? .warning : .acceptable
        result.message = responseResult ? "입력값을 다시 확인해주시기 바랍니다." : "이상이 발견되지 않았습니다."
        
        return result
    }
}
