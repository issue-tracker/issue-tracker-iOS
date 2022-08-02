//
//  RequestTextField.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import UIKit

class RequestTextField: CommonTextField {
    
    private var timerRunning = false
    var requestURLString: String?
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        super.textFieldShouldReturn(textField)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if timerRunning == false {
            
            Timer.scheduledTimer(
                timeInterval: 2.0, target: self, selector: #selector(request(_:)), userInfo: nil, repeats: false
            )
            timerRunning.toggle()
        }
        
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    @objc func request(_ sender: Any) {
        
        timerRunning = false
        
        guard let path = self.text, let urlString = requestURLString else {
            return
        }
        
        let model = RequestHTTPModel(urlString)
        model.requestBuilder.setPath(path)
        model.requestBuilder.setPath("exists")
        
        binding?.bindableHandler?(["isRequesting": true], self)
        
        model.request { result, response in
            self.binding?.bindableHandler?(["isRequesting": false], self)
            switch result {
            case .success(let data):
                print("success \(data)")
            case .failure(let error):
                print("failed \(error)")
            }
        }
    }
}
