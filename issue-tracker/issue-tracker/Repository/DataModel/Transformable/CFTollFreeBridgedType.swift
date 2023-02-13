//
//  CFTollFreeBridgedType.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/13.
//
//  Referenced by https://forums.swift.org/t/conditionally-downcasting-cf-types/27368
//

import Foundation

protocol CFType: AnyObject {
    static var typeID: CFTypeID { get }
}

protocol CFTollFreeBridgedType: CFType {
    associatedtype BridgedNSType
}

func cfCast<T: CFType>(_ v: Any, to type: T.Type = T.self) -> T? {
    let ref = v as CFTypeRef
    if CFGetTypeID(ref) == type.typeID {
        return (ref as! T)
    } else {
        return nil
    }
}

func cfCast<T: CFTollFreeBridgedType>(_ v: Any, to type: T.Type = T.self) -> T? {
    if let nsValue = v as? T.BridgedNSType {
        return (nsValue as! T)
    } else {
        return nil
    }
}

extension CFString: CFTollFreeBridgedType {
    typealias BridgedNSType = NSString
    static var typeID = CFStringGetTypeID()
}

extension CFBoolean: CFTollFreeBridgedType {
    typealias BridgedNSType = CFBoolean
    static var typeID = CFBooleanGetTypeID()
}

extension CFAllocator: CFType {
    static var typeID = CFAllocatorGetTypeID()
}
