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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textWtite.text = ""
        
       
        // Do any additional setup after loading the view.

     
    }
    @IBAction func dismissAddBtn(_ sender: Any) {
        if let text = textWtite.text, !text.isEmpty {
                   delegate?.didAddNote(text)
                   dismiss(animated: true, completion: nil)
               }
        
    }
    
}
