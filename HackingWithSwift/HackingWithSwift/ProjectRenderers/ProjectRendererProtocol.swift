//
//  ProjectRendererProtocol.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 3.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

enum Renderer {
    case app, game, technique
}

protocol ProjectRenderer {
    var project: Project { get set }
    var colors: [UIColor] { get set }
    
    func fileExists(atPath path: String, using: DirectoryManager) -> Bool
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask, using: DirectoryManager) -> [URL]
    func drawTitleImage(for type: Renderer) -> UIImage
    func render(for type: Renderer) -> UIImage
    func imageFromCache() -> UIImage?
    func cache(_ image: UIImage)
    func getCachesDirectory() -> URL
}

extension ProjectRenderer {
    func fileExists(atPath path: String, using: DirectoryManager = FileManager.default) -> Bool {
        return using.fileExists(atPath: path)
    }
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask, using: DirectoryManager = FileManager.default) -> [URL] {
        return using.urls(for: directory, in: domainMask)
    }
    
    func drawTitleImage(for type: Renderer) -> UIImage {
        if let cached = imageFromCache() {
            return cached
        }
        
        let image = render(for: type)
        cache(image)
        
        return image
    }
    
    func render(for type: Renderer) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = true
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 200), format: format)
        
        return renderer.image { ctx in
            let colorSpace = ctx.cgContext.colorSpace ?? CGColorSpaceCreateDeviceRGB()
            let cgColors = colors.map { $0.cgColor } as CFArray
            
            guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: [0, 1]) else {
                fatalError("Failed creating gradient.")
            }
            
            ctx.cgContext.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: 0, y: 200), options: [])
            
            let shadow = NSShadow()
            switch type {
            case .app: shadow.shadowColor = UIColor.blue
            case .game: shadow.shadowColor = UIColor.green
            case .technique: shadow.shadowColor = UIColor.purple
            }
            shadow.shadowBlurRadius = 5
            
            var text = "Project"
            switch type {
            case .app: text = "App Project"
            case .game: text = "Game Project"
            case .technique: text = "Technique Project"
            }
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 32, weight: .bold), .shadow: shadow]
            let string = NSAttributedString(string: text, attributes: attributes)
            string.draw(at: CGPoint(x: 20, y: 150))
            
            if type == .game, let image = UIImage(named: "dice") {
                ctx.cgContext.translateBy(x: 300, y: 20)
                ctx.cgContext.rotate(by: .pi / 4)
                image.draw(in: CGRect(x: 0, y: 0, width: 100, height: 100), blendMode: .overlay, alpha: 1)
            }
        }
    }
    
    func imageFromCache() -> UIImage? {
        let url = getCachesDirectory().appendingPathComponent(project.title)
        
        if fileExists(atPath: url.path) {
            if let data = try? Data(contentsOf: url) {
                return UIImage(data: data, scale: UIScreen.main.scale)
            }
        }
        
        return nil
    }
    
    func cache(_ image: UIImage) {
        let url = getCachesDirectory().appendingPathComponent(project.title)
        ((try? image.pngData()?.write(to: url)) as ()??)
    }
    
    func getCachesDirectory() -> URL {
        let paths = urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
}
