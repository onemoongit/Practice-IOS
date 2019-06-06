//
//  ViewController.swift
//  PR_PageViewController
//
//  Created by HyeonTae on 04/06/2019.
//  Copyright © 2019 onemoonstudio. All rights reserved.
//

import UIKit

class ViewController: UIPageViewController {
    
    private let viewcontrollersIdentifier: [String] = ["RedVC" ,"GreenVC" ,"BlueVC"]
    private lazy var pageviewcontrollers: [UIViewController] = {
        return self.viewcontrollersIdentifier.map { UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: $0) }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupPageControl()
        setPageViewController()
    }
    
    private func setupPageControl() {
        // 이게 어떻게 연결되는거지?
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.white
        appearance.currentPageIndicatorTintColor = UIColor.red
        appearance.backgroundColor = UIColor.blue
    }

    private func setPageViewController() {
        guard let firstVC = pageviewcontrollers.first  else { return }
        self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
}

extension ViewController: UIPageViewControllerDataSource {
    // 이전에 보여줄 ViewController를 설정한다.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pageviewcontrollers.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return pageviewcontrollers.last }
        return pageviewcontrollers[previousIndex]
    }
    
    // 이후에 보여줄 ViewController를 설정한다.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pageviewcontrollers.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard pageviewcontrollers.count > nextIndex else { return pageviewcontrollers.first }
        return pageviewcontrollers[nextIndex]
    }
    
    // 놀라운점 아래 두개만 추가해도 자동으로 보인다. !?
    // page indicator 에 표현될 인디케이터 수
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        print(pageviewcontrollers.count)
        return pageviewcontrollers.count
    }

    // page indicator 의 현재 위치
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let presentedViewController = presentedViewController,
            let vcIndex: Int = pageviewcontrollers.firstIndex(of: presentedViewController) else { return 0 }
        return vcIndex
    }
}

extension ViewController: UIPageViewControllerDelegate {
    
}

