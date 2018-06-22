//
//  FullscreenGalleryViewController.swift
//  FlickrApp
//
//  Created by melisadlg on 6/21/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import UIKit

class FullscreenGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
   
    weak var transitionDelegate: TransitioningDelegate?
    public var currentPage: Int = 0 {
        didSet {
            if currentPage < totalImages {
                scrollToImage(withIndex: currentPage, animated: false)
                self.title = self.dataSource![currentPage].title
            } else {
                scrollToImage(withIndex: totalImages - 1, animated: false)
                self.title = self.dataSource![totalImages - 1].title
            }
        }
    }
    var needsLayout = false
    
    var totalImages = 0
    var pageBeforeRotation = 0
    
    public var isRevolvingCarouselEnabled: Bool = true
    fileprivate var isViewFirstAppearing = true
    
    public var dataSource: [ImageCell]? {
        didSet {
            if dataSource != nil {
                self.totalImages = (dataSource?.count)!
                isRevolvingCarouselEnabled = totalImages > 1
                
            }
        }
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if needsLayout {
            let desiredIndexPath = IndexPath(item: pageBeforeRotation, section: 0)
            
            if pageBeforeRotation >= 0 {
                scrollToImage(withIndex: pageBeforeRotation, animated: false)
            }
            
            collectionView.reloadItems(at: [desiredIndexPath])
            
            for cell in collectionView.visibleCells {
                if let cell = cell as? FullscreenCollectionViewCell {
                    cell.configureForNewImage(animated: false)
                }
            }
            
            needsLayout = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        
        self.transitioningDelegate = transitionDelegate
        self.modalPresentationStyle = .custom
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        let doneButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapGoBack))
        self.navigationItem.leftBarButtonItem = doneButton
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        navigationController?.hidesBarsOnTap = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupCollectionView()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if currentPage < 0 {
            currentPage = 0
        }
        isViewFirstAppearing = false
    }
    
    private func setupCollectionView() {
        self.collectionView.register(UINib(nibName: "FullscreenCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "FullscreenCollectionViewCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.collectionView.isPagingEnabled = true
        
        pageBeforeRotation = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        currentPage = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
    }
    
    private func scrollToImage(withIndex: Int, animated: Bool = false) {
        collectionView.scrollToItem(at: IndexPath(item: withIndex, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    @objc func didTapGoBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard dataSource?.count != 0 else {
            return 1
        }
        return self.dataSource!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullscreenCollectionViewCell", for: indexPath) as! FullscreenCollectionViewCell
        
        guard dataSource?.count != 0 else {
            return cell
        }
        
        let item = dataSource![indexPath.row % (dataSource?.count)!].photoInfo.last?.source
        cell.imageView.downloadImage(url: URL(string: item!)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    
}
