//
//  ViewController.swift
//  DynamicBottomSheet
//
//  Created by Oğuz Canbaz on 31.05.2024.
//

import UIKit

class ViewController: UIViewController {

    // MARK: -- Properties
    
    var bottomSheetTableViewController: DynamicBottomSheetTVController?
    var bottomSheetCollectionViewController: DynamicBottomSheetCVController?
    
    // MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    // MARK: -- Functions
    
    @IBAction func openTVBottomSheet(_ sender: Any) {
        bottomSheetTableViewController = DynamicBottomSheetTVController()
        if let bottomSheetVC = bottomSheetTableViewController {
            bottomSheetTableViewController?.data = ["İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim"]
            bottomSheetTableViewController?.modalPresentationStyle = .overFullScreen
            present(bottomSheetVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func openCVBottomSheet(_ sender: Any) {
        
        bottomSheetCollectionViewController = DynamicBottomSheetCVController()
        if let bottomSheetVC = bottomSheetCollectionViewController {
            bottomSheetCollectionViewController?.data = ["İşlemlerim","İşlemlerim","İşlemlerim","İşlemlerim"]
            bottomSheetCollectionViewController?.modalPresentationStyle = .overFullScreen
            present(bottomSheetVC, animated: false, completion: nil)
        }
    }
}

