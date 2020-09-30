import Foundation

func timer(name: String, duration: Int) {
    for index in 1...duration {
        sleep(1)
        print("\(name): \(index)")
    }
    print("-----")
}

var isReadyWithA = false
var isReadyWithB = false

func readyWithTimer() {
    if isReadyWithA, isReadyWithB {
        timer(name: "C", duration: 20)
    }
}

func dispatchQueueExample() {
    DispatchQueue.global().async {
        timer(name: "А", duration: 15)
        isReadyWithA = true
        readyWithTimer()
    }
    
    DispatchQueue.global().async {
        timer(name: "B", duration: 10)
        isReadyWithB = true
        readyWithTimer()
    }
}

func dispatchGroupExample() {
    let group = DispatchGroup()
    
    group.enter()
    
    DispatchQueue.global().async {
        timer(name: "A", duration: 15)
        group.leave()
    }
    
    group.enter()
    
    DispatchQueue.global().async {
        timer(name: "B", duration: 10)
        group.leave()
    }
    
    group.notify(queue: .global()) {
        timer(name: "C", duration: 20)
    }
}

//dispatchQueueExample()
dispatchGroupExample()
