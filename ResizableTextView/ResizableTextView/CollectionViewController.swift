//
//  CollectionViewController.swift
//  ResizableTextView
//
//  Created by Alexander on 24.04.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit


class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var textArray: [String] = [
        "This is the first cell text\nThis is the first cell text\nThis is the first cell text\n",
        "This is the second cell text\nThis is the second cell text\nThis is the second cell text\n",
        "This is the third cell text\nThis is the third cell text\nThis is the third cell text\n",
        "This is the fourth cell text\nThis is the fourth cell text\nThis is the fourth cell text\n",
        "This is the fifth cell text\nThis is the fifth cell text\nThis is the fifth cell text\n",
        "This is the sixth cell text\nThis is the sixth cell text\nThis is the sixth cell text\n"
    ]
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func drawHeader() {
        
    }
    
    func drawFooter() {
        
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCollectionViewCell", for: indexPath) as! TextViewCollectionViewCell
        
        cell.textView.text = textArray[indexPath.item]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionViewHeader", for: indexPath) as! HeaderView
            
            let headerImageView = UIImageView(image: #imageLiteral(resourceName: "headerFooterPlaceholder"))
            headerImageView.frame = CGRect(x: 0, y: 0, width: 375, height: 45)
            headerView.headerView.addSubview(headerImageView)
            
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionViewFooter", for: indexPath) as! FooterView
            
            let footerImageView = UIImageView(image: #imageLiteral(resourceName: "headerFooterPlaceholder"))
            footerImageView.frame = CGRect(x: 0, y: 0, width: 375, height: 45)
            footerView.footerView.addSubview(footerImageView)
            
            return footerView
        default:
            assert(false, "Unexpected kind")
        }
    }

    // MARK: UICollectionViewDelegate
}

class TextViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.isScrollEnabled = false
    }
}
