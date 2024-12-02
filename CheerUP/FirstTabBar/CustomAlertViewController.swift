//
//  CustomAlertViewController.swift
//  CheerUP
//
//  Created by 박수연 on 11/18/24.
//

import UIKit
protocol CustomAlertDelegate: AnyObject {
    func action()   // confirm button event
    func exit()     // cancel button event
    func alertText(_ text: String)
}


enum AlertType {
    case onlyConfirm    // 나에게 전달
    case canCancel      // 확인 + 취소 버튼
}


class CustomAlertViewController: UIViewController {
    
    var delegate: CustomAlertDelegate?
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var todayMessage: UILabel!
    @IBOutlet weak var todayText: UITextField!
    @IBOutlet weak var myBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayText.text = "" 
        alertView.layer.cornerRadius = 8
        myBtn.layer.cornerRadius = 5
        cancelBtn.layer.cornerRadius = 5
  
    }
    
    
    @IBAction func myButton(_ sender: Any) {
        print("myBtn 클릭")
        
        guard let text = todayText.text, !text.isEmpty else { return }
               delegate?.alertText(text) // Delegate로 텍스트 전달
        print("텍스트 \(text)")
               dismiss(animated: true, completion: nil)
//        self.dismiss(animated: true) {
//            print("???? = \(self.todayText.text)")
//                self.delegate?.action()
//
//        }
    }
    
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true) {
                    self.delegate?.exit()
                }
        
    }
    
    
    
    
    
    
    
    

}
