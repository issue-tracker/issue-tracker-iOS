//
//  Int+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/03.
//

import Foundation

extension Int {
    func decodeAsError() -> String? {
        if self == 1000 {
            return "요청에 Authorization 헤더가 존재하지 않습니다."
        } else if self == 1001 {
            return "유효하지 않은 access_token입니다."
        } else if self == 1002 {
            return "유효하지 않은 refresh_token입니다."
        } else if self == 1003 {
            return "권한이 없는 사용자입니다."
        } else if self == 1004 {
            return "요청에 refresh_token 쿠키가 존재하지 않습니다."
        } else if self == 2000 {
            return "필수 제공 동의 항목을 동의하지 않았습니다."
        } else if self == 2001 {
            return "self가 유효하지 않습니다."
        } else if self == 2002 {
            return "유효하지 않은 AuthProviderType입니다."
        } else if self == 2100 {
            return "중복되는 아이디가 존재합니다."
        } else if self == 2101 {
            return "중복되는 닉네임이 존재합니다."
        } else if self == 2102 {
            return "로그인에 실패했습니다. 아이디와 비밀번호를 다시 확인해주세요."
        } else if self == 2103 {
            return "(으)로 이미 가입된 이메일입니다."
        } else if self == 3000 {
            return "존재하지 않는 이슈입니다."
        } else if self == 3001 {
            return "존재하지 않는 회원입니다."
        } else if self == 3002 {
            return "존재하지 않는 라벨입니다."
        } else if self == 3003 {
            return "존재하지 않는 코멘트입니다."
        } else if self == 3004 {
            return "존재하지 않는 마일스톤입니다."
        } else if self == 3005 {
            return "존재하지 않는 리액션입니다."
        } else if self == 4001 {
            return "이미지 파일만 업로드 가능합니다."
        } else if self == 4002 {
            return "파일 변환 중 에러가 발생하였습니다."
        } else if self == 4003 {
            return "잘못된 형식의 파일 이름입니다."
        } else if self == 5001 {
            return "유효하지 않은 색상 코드입니다."
        } else if self == 5002 {
            return "중복되는 라벨 이름이 존재합니다."
        } else if self == 5003 {
            return "중복되는 리액션이 존재합니다."
        } else if self == 5004 {
            return "중복되는 마일스톤 이름이 존재합니다."
        } else if self == 6001 {
            return "삭제할 수 없는 코멘트입니다."
        } else if self == 6002 {
            return "삭제하려는 마일스톤이 해당 이슈에 존재하지 않습니다."
        }
        
        return nil
    }
}
