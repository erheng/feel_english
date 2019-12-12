//
//  SimpleWordView.swift
//  feel_english
//
//  Created by erheng on 2019/11/27.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import RxSwift
import RxCocoa
import RxRelay

class SimpleWordView: UIView
{
    let close: UIImageView = UIImageView(image: UIImage(named: "icon_titlebar_whiteback"))
    let container: UIView = UIView()
    let wordLabel: UILabel = UILabel()
    let phoneticLabel: UILabel = UILabel()
    let translateLabel: UILabel = UILabel()

    var sourceUrl: URL?
    var audioAVPlayer: AVPlayer?

    var flag: Int = 0
    let disposeBag: DisposeBag = DisposeBag()
    var findWord: PublishRelay<String> = PublishRelay()
    var isShow: PublishRelay<Bool> = PublishRelay()

    init()
    {
        super.init(frame: SCREEN_FRAME)
        let simpleWordVM = SimpleWordViewModel(word: findWord)
        simpleWordVM.simpleWord?.subscribe(onNext: { simpleWord in
            print("simple word")
            self.wordLabel.text = simpleWord.simpleWord
            self.phoneticLabel.text = simpleWord.UKPhonetic
            self.translateLabel.text = simpleWord.translation
        }).disposed(by: disposeBag)

        initSubView()
    }

    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSubView()
    {
        // 设置背景透明
        self.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        
        container.frame = CGRect(x: 0, y: SCREEN_HEIGHT , width: SCREEN_WIDTH, height: SCREEN_HEIGHT * ( 3 / 8))
        //container.frame = CGRect(x: 0, y: SCREEN_HEIGHT * (2 / 4) , width: SCREEN_WIDTH, height: SCREEN_HEIGHT * ( 1 / 4))
        container.backgroundColor = UIColor.white
        self.addSubview(container)

        // 设置圆角
        let rounded = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT * (2 / 4))), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        container.layer.mask = shape

        // 设置顶部的关闭按钮
        container.addSubview(close)
        close.snp.makeConstraints{ make in
            make.top.equalTo(self.container.snp.top).inset(10)
            make.centerX.equalTo(self.container)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }

        // 添加word
        //wordLabel.text = "Congratulation"
        wordLabel.textAlignment = .center
        wordLabel.textColor = UIColor.systemPink
        wordLabel.font = UIFont.boldSystemFont(ofSize: 30)
        container.addSubview(wordLabel)
        wordLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.close.snp.bottom).inset(-20)
            make.centerX.equalTo(self.container)
        }


        //  添加 phoneticLabel
        phoneticLabel.textAlignment = .center
        phoneticLabel.textColor = UIColor.systemPurple
        phoneticLabel.font = UIFont.systemFont(ofSize: 15)
        container.addSubview(phoneticLabel)
        phoneticLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.wordLabel.snp.bottom).inset(-10)
            make.centerX.equalTo(self.container)
        }

        // 添加 translate
        translateLabel.textAlignment = .center
        translateLabel.textColor = UIColor.systemGray
        translateLabel.font = UIFont.systemFont(ofSize: 15)
        container.addSubview(translateLabel)
        translateLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.phoneticLabel.snp.bottom).inset(-35)
            make.centerX.equalTo(self.container)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(sender:)))
        swipeGesture.direction = .down
        self.container.addGestureRecognizer(swipeGesture)
    }
}


// MARK: - Animation

extension SimpleWordView
{
    func show(of word: String)
    {
        self.isShow.accept(true)
        findWord.accept(word)
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.addSubview(self)
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            var frame = self.container.frame
            frame.origin.y = frame.origin.y - frame.size.height
            self.container.frame = frame
        }) { finished in
        }
    }

    func dismiss()
    {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            var frame = self.container.frame
            frame.origin.y = frame.origin.y + frame.size.height
            self.container.frame = frame
        }) { finished in
            self.removeFromSuperview()
        }
        self.isShow.accept(false)
    }
}

// MARK: - handle Gesture
extension SimpleWordView: UIGestureRecognizerDelegate
{

    func changeData()
    {
        let uu: String = "http://video.mengxsh.com/sv/1c3208b2-16eb124787c/1c3208b2-16eb124787c.mp3"
        let uu2: String = "http://video.mengxsh.com/sv/591a53eb-16eb0cee310/591a53eb-16eb0cee310.mp3"

        switch flag
        {
            case 0:
                self.sourceUrl = URL(string: uu)
                self.audioAVPlayer = AVPlayer(url: self.sourceUrl!)
                flag = 1
                break
            case 1:
                self.sourceUrl = URL(string: uu2)
                self.audioAVPlayer = AVPlayer(url: self.sourceUrl!)
                flag = 0
                break
            default:
                break
        }

    }

     @objc func handleGesture(sender: UITapGestureRecognizer)
     {
         var point = sender.location(in: container)
         if !container.layer.contains(point)
         {
             self.dismiss()
             return
         }
         point = sender.location(in: close)
         if close.layer.contains(point)
         {
             self.dismiss()
             return
         }

         print("点击发音")
         changeData()
         self.audioAVPlayer?.seek(to: CMTime.zero)
         self.audioAVPlayer?.play()
         print("audio play")
     }

    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer)
    {
        self.dismiss()
    }
}
