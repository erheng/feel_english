//
//  VideoListViewController.swift
//  feel_english
//
//  Created by erheng on 2019/11/22.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit

class VideoListViewController: BaseViewController
{
    // TODO: 公共参数 notification
    let StatusBarTouchBeginNotification:String = "StatusBarTouchBeginNotification"
    
    var tableView: UITableView?
    @objc dynamic var currentIndex: Int = 0
    var isCurrentPlayerPause: Bool = false
    var data = [MovieClipModel]()
    var movieClipModels = [MovieClipModel]()
    let VIDEO_CELL: String = "VideoListCell"
    var pageIndex: Int = 0
    var pageSize: Int = 21
    var uid: String?
    private var selfObserverKeyPath: String = "currentIndex"
    
    init(movieClips: [MovieClipModel], currentIndex: Int, page: Int, size: Int, uid: String)
    {
        super.init(nibName: nil, bundle: nil)
        self.currentIndex = currentIndex
        self.pageIndex = page
        self.pageSize = size
        self.uid = uid
        
        self.movieClipModels = movieClips
        self.data.append(movieClipModels[currentIndex])
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarTouchBegin),
                                               name: NSNotification.Name(rawValue: StatusBarTouchBeginNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecomeActive),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpView()
        
        // 设置加载视频时背景图片
        super.setBackgroundImage(imageName: "img_video_loading")
    }
    

    // 视图将要显示
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
         
        //设置导航栏背景透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }    
    
    func setUpView()
    {
       self.initUITabView()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
        {

            self.view.addSubview(self.tableView!)
            self.data = self.movieClipModels
            self.tableView?.reloadData()
 
            let curIndexPath = IndexPath(row: self.currentIndex, section: 0)
            self.tableView?.scrollToRow(at: curIndexPath, at: UITableView.ScrollPosition.middle, animated: false)
            self.addObserver(self, forKeyPath: self.selfObserverKeyPath, options: [.initial, .new], context: nil)

        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        tableView?.layer.removeAllAnimations()
        let cells = tableView?.visibleCells as! [VideoListCell]
        for cell in cells
        {
            cell.playerView.cancelLoading()
        }
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: self.selfObserverKeyPath)
    }
    
    
    // MARK:- UITableView set
    func initUITabView() -> Void
    {
        tableView = UITableView(frame: CGRect(x: 0, y: -SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 3))
        tableView?.contentInset = UIEdgeInsets(top: SCREEN_HEIGHT, left: 0, bottom: SCREEN_HEIGHT * 3, right: 0);
        tableView?.backgroundColor = UIColor.clear
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none

        
        if #available(iOS 11.0, *)
        {
            tableView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView?.register(VideoListCell.classForCoder(), forCellReuseIdentifier: VIDEO_CELL)
    }
    
}



extension VideoListViewController: UITableViewDelegate, UITableViewDataSource
{
    // 设置一个章节中单元格的个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        data.count
    }
    
    // 初始化和复用单元格 每绘制一个调用一次
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // VIDEO_CELL 单元格类型，每个单元格可以有不同的类型，从单元格池中获取制定类型的单元格，可以复用
        let cell = tableView.dequeueReusableCell(withIdentifier: VIDEO_CELL) as! VideoListCell
        cell.initMovieClipData(data: data[indexPath.row])
        
        return cell
    }

    // 设置表格中章节数量
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    // 设置指定位置单元格的高度，每次显示时都会调用此方法
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // TODO: 公共参数统一处理
        let screenHeight = UIScreen.main.bounds.size.height
        return screenHeight
    }
}


extension VideoListViewController: UIScrollViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        DispatchQueue.main.async
        {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            // 上滑
            if translatedPoint.y < -50 && self.currentIndex < (self.data.count - 1)
            {
                self.currentIndex += 1
            }
            
            // 下滑
            if translatedPoint.y > 50 && self.currentIndex > 0
            {
                self.currentIndex -= 1
            }
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView?.scrollToRow(at: IndexPath(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}


extension VideoListViewController
{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if(keyPath == self.selfObserverKeyPath)
        {
            isCurrentPlayerPause = false
            weak var cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as? VideoListCell
            if cell?.isPlayerReady ?? false
            {
                cell?.replay()
            }
            else
            {
                AVPlayerManager.shared().pauseAll()
                cell?.onPlayerReady = {[weak self] in
                    if let indexPath = self?.tableView?.indexPath(for: cell!)
                    {
                        if !(self?.isCurrentPlayerPause ?? true) && indexPath.row == self?.currentIndex
                        {
                            cell?.play()
                        }
                    }
                }
            }
        }
        else
        {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc func statusBarTouchBegin()
    {
        currentIndex = 0
    }
    
    @objc func applicationBecomeActive()
    {
        let cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! VideoListCell
        if !isCurrentPlayerPause
        {
            cell.playerView.play()
        }
    }
    
    @objc func applicationEnterBackground()
    {
        self.videoPause()
    }
    
    func videoPause()
    {
        let cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! VideoListCell
        isCurrentPlayerPause = cell.playerView.rate() == 0 ? true :false
        cell.playerView.pause()
    }
}
