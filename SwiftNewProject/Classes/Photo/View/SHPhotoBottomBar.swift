//
//  SHPhotoBottomBar.swift
//  SwiftNewProject
//
//  Created by lalala on 2017/5/10.
//  Copyright © 2017年 lsh. All rights reserved.
//

import UIKit

protocol SHPhotoBottomBarDelegate {
    func didTappedBackButton(_ button: UIButton)
    func didTappedEditButton(_ button: UIButton)
    func didTappedCommentButton(_ button: UIButton)
    func didTappedCollectionButton(_ button: UIButton)
    func didTappedShareButton(_ button: UIButton)
}
class SHPhotoBottomBar: UIView {

    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
   
    var delegate: SHPhotoBottomBarDelegate?
    
    @IBAction func didTappedBackButton(_ sender: UIButton) {
        delegate?.didTappedBackButton(sender)
    }
    @IBAction func didTappedEditButton(_ sender: UIButton) {
        delegate?.didTappedEditButton(sender)
    }
    @IBAction func didTappedCommentButton(_ sender: UIButton) {
        delegate?.didTappedCommentButton(sender)
    }
    @IBAction func didTappedCollectionButton(_ sender: UIButton) {
        delegate?.didTappedCollectionButton(sender)
    }
    @IBAction func didTappedShareButton(_ sender: UIButton) {
        delegate?.didTappedShareButton(sender)
    }
    
}
