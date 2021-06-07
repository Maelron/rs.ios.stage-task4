import Foundation

public extension Int {
    
    var roman: String? {
        
        let numbers = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        let romans = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        var resultStr = ""
        var initialInt = self
        
        while initialInt > 0 {
            for (index, number) in numbers.enumerated() {
                if initialInt - number >= 0 {
                    initialInt -= number
                    resultStr += romans[index]
                    break
                }
            }
        }
        
        if resultStr == "" {
            return nil
        }
        
        return resultStr
    }
}
