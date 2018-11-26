//
//  String.swift
//  Hompimpa
//
//  Created by hendy evan on 26/11/18.
//

import Foundation
import SwiftyRSA

extension String {
    var isBlank: Bool {
        get {
            let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    //    var isValidPassword: Bool {
    //        do {
    //            let regex = try NSRegularExpression(pattern: "(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,20}$", options: .caseInsensitive)
    //            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
    //        } catch {
    //            return false
    //        }
    //    }
    
    var isValidPhoneNo: Bool {
        let character  = NSCharacterSet(charactersIn: Constant.numberCharacter).inverted
        var filtered: String
        let inputString: [String] = self.components(separatedBy: character)
        filtered = inputString.joined(separator: "")
        return self == filtered
    }
    
//    var isValidPassword: Bool {
//        return count >= 6
//    }
//
    var isContainSymbol: Bool {
        let cs = CharacterSet(charactersIn: Constant.noSymbolCharacter).inverted
        let filtered: String = (self.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
        return (self == filtered)
    }
    
    var appVersion:String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "no version info"
        }
        return "Version: \(version)"
    }
    
    func encrypt() -> String {
        var encrypted = ""
        do {
            let publicKey = try PublicKey(pemEncoded: Constant.publicKey)
            let clear = try ClearMessage(string: self, using: .utf8)
            encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1).base64String
        }catch {
            let error = NSError(domain: Constant.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Encryption failed!"])
            print(error.localizedDescription)
        }
        
        return encrypted.clearEncryptedPassword()
    }
    
    private func clearEncryptedPassword() -> String{
        var newString = self.replacingOccurrences(of: "=", with: "")
        newString = newString.replacingOccurrences(of: "/", with: "_")
        newString = newString.replacingOccurrences(of: "+", with: "-")
        
        return newString
    }
    
    func indexDistance(of character: Character) -> Int {
        guard let index = index(of: character) else { return -1 }
        return distance(from: startIndex, to: index)
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    
    func birthDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
        return dateFormatter.string(from: date)
    }
    
    func dateToString(date:Date) -> String{
        struct Formatter {
            static var format: DateFormatter = { () -> DateFormatter in
                let format: DateFormatter = DateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                return format
            }()
        }
        
        return Formatter.format.string(from: date)
    }
    
    
    func stringToDate() -> Date {
        struct Formatter {
            static var format: DateFormatter = { () -> DateFormatter in
                let format: DateFormatter = DateFormatter()
                format.locale = Locale(identifier: "id_ID")
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                return format
            }()
        }
        
        return Formatter.format.date(from: self)! as Date
    }
    
    func hourToString() -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from:date)
        
        return dateString
    }
    
    func yearToString() -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "EEEE, dd MMMM yyyy"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func dateTimeToStringDate() -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func toInt() -> Int {
        if let n = Int(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
            return n
        } else {
            return 0
        }
    }
    
    func slotTimeFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func getDayOfWeek() -> Int? {
        
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let date = dateFormatter.date(from: self)!
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        
        return weekDay
    }
    
    func toDateTimeJsonFormat() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let date = dateFormatter.date(from: self)!
        
        return date
    }
    
    func toDateJsonFormat() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Jakarta")
        dateFormatter.timeZone = TimeZone(abbreviation: "WIT")
        let date = dateFormatter.date(from: self)!
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        guard let newDate = dateFormatter.date(from: dateString) else {
            return Date()
        }
        
        return newDate
    }
    
    func dateTimeToDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(for: date)
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
