import Cocoa

var total: Decimal = 0
var current: Decimal = 1

for i in 0..<200 {
    total += current
    
    if i % 2 == 0 {
        current *= 2
    } else {
        current += 2
    }
}

print(total)
