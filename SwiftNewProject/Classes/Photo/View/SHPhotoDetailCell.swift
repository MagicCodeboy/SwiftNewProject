//
//  SHPhotoDetailCell.swift
//  SwiftNewProject
//
//  Created by lalala on 2017/5/10.
//  Copyright © 2017年 lsh. All rights reserved.
//

import UIKit
import YYWebImage
import SnapKit

protocol SHPhotoDetailCellDelegate {
    func didOneTappedPhotoDetailView(_ scrollView: UIScrollView)
    func didDoubleTappedPhotoDetailView(_ scrollView: UIScrollView, touchPoint: CGPoint)
    func didLongPressPhotoDetailView(_ scrollView: UIScrollView, currentImage: UIImage?)
}

class SHPhotoDetailCell: UICollectionViewCell {
    
    var delegate: SHPhotoDetailCellDelegate?
    
    //图片的URL的字符串
    var urlString: String? {
        didSet {
            guard let imageUrl = urlString else {
                 print("imageURl 为空")
                return
            }
            //将imageView图片设置为nil 防止cell 重用
            picImageView.image = nil
            resetProperties()
            indicator.startAnimating()
            
            //判断本地磁盘是否已经缓存
            if JFArticleStorage.getArticleImageCache().containsImage(forKey: imageUrl, with: YYImageCacheType.disk) {
                let image = UIImage(contentsOfFile: JFArticleStorage.getFilePathForKey(imageUrl))
                self.picImageView.yy_imageURL = URL(string: imageUrl)
                self.layoutImageView(image!)
                self.indicator.stopAnimating()
            } else {
                YYWebImageManager(cache: JFArticleStorage.getArticleImageCache(), queue: OperationQueue()).requestImage(with: URL(string: imageUrl)!, options: YYWebImageOptions.useNSURLCache, progress: { (_ , _) in
                }, transform: { (image, url) -> UIImage? in
                    return image
                }, completion: { (image, url, type, stage, error) in
                     DispatchQueue.main.sync(execute: { 
                         self.indicator.stopAnimating()
                        guard let _ = image, error == nil else {
                            return
                        }
                        //刚缓存的图片会有一点处理的时间保存到本地
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC)))/Double(NSEC_PER_SEC), execute: { 
                             let image = UIImage(contentsOfFile: JFArticleStorage.getFilePathForKey(imageUrl))
                            self.layoutImageView(image!)
                            self.picImageView.yy_imageURL = URL(string: imageUrl)
                        })
                     })
                })
            }
        }
    }
    //清除属性 防止Cell复用
    fileprivate func resetProperties() {
        picImageView.transform = CGAffineTransform.identity //还原到进行动画之前的状态
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }
    //根据图片的长短 重新布局图片的位置
    fileprivate func layoutImageView(_ image: UIImage) {
        //获取等比例缩放后的图片的大小
        let size = image.displaySize()
        
        //判断长短图
        if size.height < (SCREEN_HEIGHT) {
            //短图 居中显示
            let offsetY = (SCREEN_HEIGHT - size.height) * 0.5
            //不能通过frame来确定Y值 否则在放大的时候底部可能会有看不到
            picImageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            //设置scrollView.contentInset.top是可以滚动的
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
        } else {
            //长图 顶部显示
            picImageView.frame = CGRect.init(origin: CGPoint(x: 0, y: 0), size: size)
            //设置滚动
            scrollView.contentSize = size
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //准备UI界面
    fileprivate func prepareUI() {
        //添加单击双击的事件
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(didOneTappedPhotoDetailView(_:)))
        addGestureRecognizer(oneTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTappedPhotoDetailView(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressPhotoDetailView(_:)))
        addGestureRecognizer(longPress)
        
        //如果监听到双击的事件 单击的事件则不触发
        oneTap.require(toFail: doubleTap)
        
        //添加控件
        scrollView.addSubview(picImageView)
        contentView.addSubview(scrollView)
        contentView.addSubview(indicator)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        indicator.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    //MARK: 各种手势
    //图秀详情界面单击事件， 隐藏除去图片外的所有的UI
    func didOneTappedPhotoDetailView(_ tap: UITapGestureRecognizer) {
         delegate?.didOneTappedPhotoDetailView(scrollView)
    }
    //图秀详情界面双击事件，缩放
    func didDoubleTappedPhotoDetailView(_ tap: UITapGestureRecognizer) {
        let touchPoint = tap.location(in: self)
        delegate?.didDoubleTappedPhotoDetailView(scrollView, touchPoint: touchPoint)
    }
    //图秀详情界面长按事件
    func didLongPressPhotoDetailView(_ longPress: UILongPressGestureRecognizer)  {
        if longPress.state == .began {
            //长按手势会触发两次
            delegate?.didLongPressPhotoDetailView(scrollView, currentImage: picImageView.image)
        }
    }
    //懒加载
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        return scrollView
    }()
    fileprivate lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate lazy var picImageView = UIImageView()
}
extension SHPhotoDetailCell: UIScrollViewDelegate {
    //这个代理方法返回进行缩放时所使用的UIView对象
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return picImageView
    }
    //当用户对内容进行缩放时
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //往中间移动
        //y 偏移
        var offsetY = (scrollView.frame.height - picImageView.frame.height) * 0.5
        
        //x偏移
        var offsetX = (scrollView.frame.width - picImageView.frame.width) * 0.5
        
        //当offset时， 让offset = 0， 否则会拖不动
        if offsetY < 0 {
             offsetY = 0
        }
        if offsetX < 0 {
            offsetX = 0
        }
        UIView.animate(withDuration: 0.25) { 
             //设置scrollView的ContentInset来居中图片
            scrollView.contentInset = UIEdgeInsets.init(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        }
    }
}
