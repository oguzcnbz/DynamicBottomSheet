//
//  DynamicBottomSheetCVController.swift
//  DynamicBottomSheet
//
//  Created by Oğuz Canbaz on 31.05.2024.
//

import UIKit
import SnapKit

class DynamicBottomSheetCVController: UIViewController {
    
    // MARK: -- Properties
    
    var data: [String] = []
    
    var subViewHeight: CGFloat = 400{
        didSet{
            if subViewHeight > self.view.frame.size.height / 2{
                subView.snp.updateConstraints({sv in
                    sv.height.equalTo(self.view.frame.size.height / 2)
                })
                collectionView.isScrollEnabled = true
            }else{
                subView.snp.updateConstraints({sv in
                    sv.height.equalTo(subViewHeight)
                })
                collectionView.isScrollEnabled = false
            }
        }
    }
    
    // MARK: -- Components
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        
        let cell = UINib(nibName: "DynamicBottomSheetCollectionViewCell", bundle: nil)
        cv.register(cell, forCellWithReuseIdentifier: "DynamicBottomSheetCollectionViewCell")
        
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var mainView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var subView: UIView = {
        let v = UIView()
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        v.layer.mask = mask
        v.backgroundColor = .white
        return v
    }()
    
    private lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 4
        return v
    }()
    
    // MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addGesture()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.reloadData()
        subViewHeight = collectionView.contentSize.height + 46
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomSheetPresent()
    }
    
    // MARK: -- Functions
    
    private func addGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mainView.addGestureRecognizer(tapGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDownGesture.direction = .down
        subView.addGestureRecognizer(swipeDownGesture)
    }
    
    func bottomSheetPresent(){
        subView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(subViewHeight)
        }
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.mainView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.subView.snp.updateConstraints { (make) in
                make.height.equalTo(4)
                make.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })
    }
    
    func bottomSheetDismiss(){
        UIView.animate(withDuration: 0.3, animations: {
            
            self.mainView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.subView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.view.snp.bottom).offset(self.subViewHeight)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        
        bottomSheetDismiss()
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        
        bottomSheetDismiss()
    }
    
    func setupView() {
        self.view.addSubview(mainView)
        self.view.addSubview(subView)
        subView.addSubview(lineView)
        subView.addSubview(collectionView)
        setupLayout()
    }
    
    func setupLayout() {
        
        mainView.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })
        
        subView.snp.makeConstraints({make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(subViewHeight)
        })
        
        lineView.snp.makeConstraints({make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(100)
        })
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: -- Extensions

extension DynamicBottomSheetCVController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DynamicBottomSheetCollectionViewCell", for: indexPath) as? DynamicBottomSheetCollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = data[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let cellWidth = collectionViewWidth
        let cellHeight = cellWidth/9
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
