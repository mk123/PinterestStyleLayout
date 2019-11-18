//
//  ViewController.swift
//  StaggeredGrid
//
//  Created by Manjeet kumar on 17/11/19.
//  Copyright © 2019 ManjeetKumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let layout = collectionView?.collectionViewLayout as? StaggeredGridLayout {
            layout.delegate = self
        }
        collectionView.dataSource = self
      
    }
    

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath)
        return cell
    }
    
    
}


extension ViewController: StaggeredGridLayoutProtocol {
    func collectionview(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return CGFloat(Int.random(in: 3...5) * 50)
    }
    
    func collectionview(_ collectionView: UICollectionView, heightForAnnotationtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return 60
    }
}



