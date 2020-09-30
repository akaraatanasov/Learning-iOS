//
//  ProjectRendererProtocol.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 3.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

protocol ProjectRendererDelegate {
    var project: Project { get set }
    var colors: [UIColor] { get set }
    var shadowColor: UIColor { get set }
    var imageText: String { get set }
    
    func drawTitleImage() -> UIImage
    func renderAdditionalComponents(in context: UIGraphicsImageRendererContext)
}

extension ProjectRendererDelegate {
    
    // MARK: - Public
    
    func drawTitleImage() -> UIImage {
        if let cached = imageFromCache() {
            return cached
        }
        
        let image = render()
        cache(image)
        
        return image
    }
    
    func renderAdditionalComponents(in context: UIGraphicsImageRendererContext) { }
    
    // MARK: - Private
    
    private func fileExists(atPath path: String, using: DirectoryManagerDelegate = FileManager.default) -> Bool {
        return using.fileExists(atPath: path)
    }
    
    private func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask, using: DirectoryManagerDelegate = FileManager.default) -> [URL] {
        return using.urls(for: directory, in: domainMask)
    }
    
    private func render() -> UIImage {
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
            shadow.shadowColor = shadowColor
            shadow.shadowBlurRadius = 5
            
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 32, weight: .bold), .shadow: shadow]
            let string = NSAttributedString(string: imageText, attributes: attributes)
            string.draw(at: CGPoint(x: 20, y: 150))
            
            renderAdditionalComponents(in: ctx)
        }
    }
    
    private func imageFromCache() -> UIImage? {
        let url = getCachesDirectory().appendingPathComponent(project.title)
        
        if fileExists(atPath: url.path) {
            if let data = try? Data(contentsOf: url) {
                return UIImage(data: data, scale: UIScreen.main.scale)
            }
        }
        
        return nil
    }
    
    private func cache(_ image: UIImage) {
        let url = getCachesDirectory().appendingPathComponent(project.title)
        ((try? image.pngData()?.write(to: url)) as ()??)
    }
    
    private func getCachesDirectory() -> URL {
        let paths = urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
}
