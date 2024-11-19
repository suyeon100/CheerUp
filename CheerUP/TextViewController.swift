//
//  TextViewController.swift
//  CheerUP
//
//  Created by 박수연 on 11/6/24.
//

import UIKit

protocol DiaryInputDelegate: AnyObject {
    func didAddNote(_ note: String)
}

class TextViewController: UIViewController {

    @IBOutlet weak var textWtite: UITextView!
    weak var delegate: DiaryInputDelegate?
    @IBOutlet weak var addbtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textWtite.text = ""
        desien()
      
        
     
    }
    
    func desien(){
        addbtn.layer.cornerRadius = 15
        textWtite.layer.cornerRadius = 30
        textWtite.layer.borderWidth = 2.0
        textWtite.layer.borderColor = UIColor.gray.cgColor
        textWtite.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    
    }
    
    
    @IBAction func dismissAddBtn(_ sender: Any) {
        if let text = textWtite.text, !text.isEmpty {
                   delegate?.didAddNote(text)
                   dismiss(animated: true, completion: nil)
               }
        
    }
    
}
