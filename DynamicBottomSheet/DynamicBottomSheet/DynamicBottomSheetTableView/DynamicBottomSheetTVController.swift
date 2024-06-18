//
//  DynamicBottomSheetTableView.swift
//  DynamicBottomSheet
//
//  Created by Oğuz Canbaz on 31.05.2024.
//

import UIKit
import SnapKit

class DynamicBottomSheetTVController: UIViewController {
    
    // MARK: -- Properties
    
    var data: [String] = []
    var subViewHeight: CGFloat = 400{
        didSet{
            if subViewHeight > self.view.frame.size.height / 2{
                subView.snp.makeConstraints({sv in
                    sv.height.equalTo(self.view.frame.size.height / 2)
                })
                tableView.isScrollEnabled = true
            }else{
                subView.snp.makeConstraints({sv in
                    sv.height.equalTo(subViewHeight)
                })
                tableView.isScrollEnabled = false
            }
        }
    }
    
    // MARK: -- Components
    
    private lazy var tableView: UITableView = {
        let tw = UITableView()
        tw.backgroundColor = .white
        tw.register(DynamicBottomSheetTableViewCell.self, forCellReuseIdentifier: "DynamicBottomSheetTableViewCell")
        tw.dataSource = self
        tw.delegate = self
        return tw
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
        calculateTableViewContentHeight()
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
    
    func calculateTableViewContentHeight() {
        tableView.reloadData()
        subViewHeight = tableView.contentSize.height + 45
    }
    
    func setupView() {
        self.view.addSubview(mainView)
        self.view.addSubview(subView)
        subView.addSubview(lineView)
        subView.addSubview(tableView)
        setupLayout()
    }
    
    func setupLayout() {
        
        mainView.snp.makeConstraints({sv in
            sv.top.equalToSuperview()
            sv.leading.equalToSuperview()
            sv.trailing.equalToSuperview()
            sv.bottom.equalToSuperview()
        })
        
        subView.snp.makeConstraints({sv in
            sv.leading.equalToSuperview()
            sv.trailing.equalToSuperview()
            sv.bottom.equalToSuperview()
            sv.height.equalTo(subViewHeight)
        })
        
        lineView.snp.makeConstraints({make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(100)
        })
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: -- Extensions

extension DynamicBottomSheetTVController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicBottomSheetTableViewCell", for: indexPath) as? DynamicBottomSheetTableViewCell else { return UITableViewCell() }
        cell.label.text = data[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
}
