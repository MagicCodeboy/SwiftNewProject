//
//  SHPhotoTableViewController.swift
//  SwiftNewProject
//
//  Created by lalala on 2017/5/11.
//  Copyright © 2017年 lsh. All rights reserved.
//

import UIKit
import SDCycleScrollView
import MJRefresh


class SHPhotoTableViewController: UITableViewController {

    var classid: Int? {
        didSet {
            loadNews(classid!, pageIndex: 1, method: 0)
        }
    }
    //页码
    var pageIndex = 1
    //模型数组
    var photoList = [JFArticleListModel]()
    //新闻Cell重用标识符
    let newsReuseIdentifier = "newsReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SHPhotoListCell.self, forCellReuseIdentifier: newsReuseIdentifier)
        tableView.rowHeight = 200
        tableView.separatorStyle = .none
        let headerRefresh = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(updateNewData))
        headerRefresh?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = headerRefresh
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
    }
    
    //下拉加载最新数据
    @objc fileprivate func updateNewData() {
        loadNews(classid!, pageIndex: 1, method: 0)
    }
    //上拉加载更多数据
    @objc fileprivate func loadMoreData() {
        pageIndex += 1
        loadNews(classid!, pageIndex: pageIndex, method: 1)
    }
    
    //根据分类、页码加载数据
    /*
     \ parameter classid: 当前栏目id
     \ parameter pageIndex: 当前的页码
     \ parameter method: 加载的方式 0 下拉加载更多 1 上拉加载更多
     */
    fileprivate func loadNews(_ classid: Int, pageIndex: Int, method: Int) {
        JFArticleListModel.loadNewsList("photo", classid: classid, pageIndex: pageIndex, type: 1) { (articleListModels, error) in
             self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            guard let list = articleListModels else { return }
            if error != nil {
                return
            }
            if list.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            
            //id越大，文章越新
            let minId = self.photoList.last?.id ?? "0"
            //新数据里最大的id
            let newMaxId = Int(list[0].id!)!
            
            if method == 0 {
                self.photoList = list
                self.tableView.reloadData()
            } else {
                //上拉加载更多 - 拼接数据
                if Int(minId)! > newMaxId {
                    self.photoList = self.photoList + list
                    self.tableView.reloadData()
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsReuseIdentifier) as! SHPhotoListCell
        cell.postModel = photoList[indexPath.row]
        cell.cellHeight = 200
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentListModel = photoList[indexPath.row]
        let detailVc = SHPhotoDetailViewController()
        detailVc.photoParam = (currentListModel.classid!, currentListModel.id!)
        navigationController?.pushViewController(detailVc, animated: true)
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         _ = (cell as! SHPhotoListCell).cellOffset()
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let array = tableView.visibleCells
        for cell in array {
             //里面的图片跟随移动
            _ = (cell as! SHPhotoListCell).cellOffset()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
