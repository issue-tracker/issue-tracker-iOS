//
//  QueryCondition.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/27.
//

import Foundation

enum QueryCondition: String, CaseIterable {
    case isCondition = "is"
    case authorCondition = "author"
    case labelCondition = "label"
    case milestoneCondition = "milestone"
    case assigneeCondition = "assignee"
    case titleCondition = "title"
    
    static func getType(condition: String) -> QueryCondition? {
        for predefinedCondition in QueryCondition.allCases {
            if condition == predefinedCondition.rawValue {
                return predefinedCondition
            }
        }
        
        return nil
    }
}

class QueryParser {
    
    var colonIndex: (String) -> String.Index? = {
        $0.firstIndex(of: ":")
    }
    
    var blankIndex: (String) -> String.Index? = {
        $0.firstIndex(of: " ")
    }
    
    func getOnlyCondition(from query: String) -> QueryCondition? {
        var query = query
        
        // :(콜론) 포함 뒤의 문자 전부 삭제, 빈칸 포함 앞의 문자 전부 삭제
        while let colonIndex = colonIndex(query) {
            query.removeSubrange(colonIndex...)
        }
        
        while let blankIndex = blankIndex(query) {
            query.removeSubrange(...blankIndex)
        }
        
        return QueryCondition.getType(condition: query)
    }
    
    func getOnlySentence(from query: String) -> String? {
        var query = query
        
        // :(콜론) 포함 앞의 문자 전부 삭제
        while let colonIndex = colonIndex(query) {
            query.removeSubrange(...colonIndex)
        }
        
        return query
    }
    
    func isEnableBookmark(_ bookmark: Bookmark) -> Bool {
        switch bookmark.queryCondition {
        case .isCondition:
            return ["open", "close"].contains(bookmark.querySentence)
        default:
            return true
        }
    }
    
    func getQueryEncoded(_ bookmarks: Set<Bookmark>) -> String {
        var query = bookmarks.reduce("") { partialResult, bookmark in
            partialResult + "+" + bookmark.queryEncoded
        }
        
        query.removeFirst()
        
        return query.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "\u{22}+").inverted) ?? ""
    }
    
    func getQuery(_ bookmarks: Set<Bookmark>) -> String {
        let result = bookmarks.reduce("") { partialResult, bookmark in
            partialResult + (partialResult == "" ? "" : "+") + bookmark.queryEncoded
        }
        
        return result.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "\u{22}+").inverted) ?? ""
    }
}

/**
 https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
 현재 가능한 쿼리는 is:[open or close] author:"hoo" label:"Feature" milestone:"제목만 있는 마일스톤" assignee:"hoo" title:"title"
 */
