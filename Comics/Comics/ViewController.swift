//
//  ViewController.swift
//  Comics
//
//  Created by Кирилл Афонин on 25/10/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    // Отвечают за координаты следующей картинки
    var nextX = NextNumber.zero
    var nextY = NextNumber.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupScrollView()
        setupImageView()
        setupSwipes()
    }
    
    // свайп вправо/влево переключает на предыдущую/следующую картинку
    private func setupSwipes() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextPicture(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextPicture(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    private func setupScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 250)
        scrollView.center = view.center
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
    }
    
    private func setupImageView() {
        imageView.image = UIImage(named: "comics2")
        imageView.sizeToFit()
        
        scrollView.contentSize = imageView.image!.size
        scrollView.maximumZoomScale = 1
        scrollView.minimumZoomScale = 0
        scrollView.zoomScale = 0.59
        scrollView.addSubview(imageView)
    }
    
    @objc func nextPicture(_ swipe: UISwipeGestureRecognizer) {
        
        // при каждом свайпе происходит смещение на 1 размер экрана
        // для этого переключаем множитель
        switch swipe.direction {
        case .left:
            nextX.next()
            if nextX.rawValue == 0.0 {
                nextY.next()
            }
            nextPage(with: .transitionFlipFromRight)
        case .right:
            nextX.previous()
            if nextX.rawValue == 2.0 {
                nextY.previous()
            }
            nextPage(with: .transitionFlipFromLeft)
        default:
            print("wrong")
        }
        

    }
    
    private func nextPage(with options: UIView.AnimationOptions) {
        let width = scrollView.frame.width
        let height = scrollView.frame.height + 7
        
        // умножаем размер экрана на множитель для смещения
        let nextPage = CGRect(x: nextX.rawValue * width,
                              y: nextY.rawValue * height,
                              width: width,
                              height: height)
        
        UIView.transition(with: self.scrollView,
                          duration: 0.5,
                          options: options,
                          animations: { self.scrollView.scrollRectToVisible(nextPage, animated: false)
                            
        })
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

// содержит множители и переключатели для перехода на следующую картинку
enum NextNumber: CGFloat {
    typealias RawValue = CGFloat
    
    case zero = 0.0, one = 1.0, two = 2.0
    
    mutating func next() {
        switch self {
        case .zero: self = .one
        case .one: self = .two
        case .two: self = .zero
        }
    }
    
    mutating func previous() {
        switch self {
        case .zero: self = .two
        case .one: self = .zero
        case .two: self = .one
        }
    }
}
