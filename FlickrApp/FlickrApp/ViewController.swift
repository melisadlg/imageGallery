//
//  ViewController.swift
//  FlickrApp
//
//  Created by melisadlg on 6/20/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    weak var transitionDelegate: TransitioningDelegate?
    
    var loadedPages = 1
    var index: Int = 0
    
    var imageCells: [ImageCell]? {
        didSet {
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
                self.view.setNeedsLayout()
            }
        }
    }
    var viewModel = ThumbnailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Image Gallery"
        transitionDelegate = TransitioningDelegate()

        self.galleryCollectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.getRecent(page: self.loadedPages, completion: {(imageCells, error) in
            guard error == nil else {
                return
            }
            
            self.imageCells = imageCells
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageCells?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        guard imageCells != nil else {
            return cell
        }

        let itemToShow = imageCells![indexPath.row % (imageCells?.count)!]
        cell.image.downloadImage(url: URL(string: itemToShow.imageURL)!)
        cell.title = itemToShow.title
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.item

        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to: collectionView.superview)
        transitionDelegate?.openingFrame = frameToOpenFrom
        
        let when = DispatchTime.now() + 0.15
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.presentFullscreenImage(startAtFrame: frameToOpenFrom, animated: true)
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > scrollView.contentSize.height {
//            self.loadedPages += 1
//            self.viewModel.getRecent(page: self.loadedPages, completion: {(imageCells, error) in
//                guard error == nil else {
//                    return
//                }
//
//                self.imageCells = imageCells
//            })
//        }
//        if let lastCell = galleryCollectionView.visibleCells.last as? CustomCollectionViewCell {
//            if lastCell.title == self.imageCells?.last?.title {
//                self.loadedPages += 1
//                self.viewModel.getRecent(page: self.loadedPages, completion: {(imageCells, error) in
//                    guard error == nil else {
//                        return
//                    }
//
//                    self.imageCells = imageCells
//                })
//            }
//        }
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Use this 'canLoadFromBottom' variable only if you want to load from bottom iff content > table size
        let contentSize = scrollView.contentSize.height
        let tableSize = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let canLoadFromBottom = contentSize > tableSize
        
        // Offset
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let difference = maximumOffset - currentOffset
        
        // Difference threshold as you like. -120.0 means pulling the cell up 120 points
        if canLoadFromBottom, difference <= -120.0 {
            
            // Save the current bottom inset
            let previousScrollViewBottomInset = scrollView.contentInset.bottom
            // Add 50 points to bottom inset, avoiding it from laying over the refresh control.
            scrollView.contentInset.bottom = previousScrollViewBottomInset + 50
            
            // loadMoreData function call
            self.loadedPages += 1
            self.viewModel.getRecent(page: self.loadedPages, completion: {(imageCells, error) in
                guard error == nil else {
                    return
                }

                self.imageCells = imageCells
            })
            // Reset the bottom inset to its original value
            scrollView.contentInset.bottom = previousScrollViewBottomInset
        }
    }
    
    func presentFullscreenImage(startAtFrame frame: CGRect, animated: Bool) {
        
        let transitionDelegate: TransitioningDelegate = TransitioningDelegate()
        
        let fullscreenGalleryVC = FullscreenGalleryViewController()
        fullscreenGalleryVC.dataSource = self.imageCells
        
        let navigationController = UINavigationController(rootViewController: fullscreenGalleryVC)
        
        if frame != .zero {
            transitionDelegate.openingFrame = frame
            navigationController.transitioningDelegate = transitionDelegate
            navigationController.modalPresentationStyle = .custom
        }
        
        self.present(navigationController, animated: true, completion: { () -> Void in
            fullscreenGalleryVC.currentPage = self.index
        })
    }
}
