//
//  EditViewController.swift
//  CheerUP
//
//  Created by 박수연 on 11/8/24.
//

import UIKit

// 수정할 수 있는 EditViewController

class EditViewController: UIViewController {
    
   
    @IBOutlet weak var selectView: UILabel!
    //@IBOutlet weak var selectView: UITextView!
    
    var selectedText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        self.selectView.text = selectedText
      
            
            selectView.text = selectedText
      

    }

    
    @IBAction func editBtn(_ sender: Any) {
    
        let alert = UIAlertController(title: "수정", message: "수정하시겠습니까?", preferredStyle: .alert)
      
        let editAction = UIAlertAction(title: "네", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 if let noteInputVC = storyboard.instantiateViewController(identifier: "TextView") as? TextViewController {
//                     noteInputVC.delegate = self
                   
                     self.present(noteInputVC, animated: true, completion: nil)
                 }
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { [weak self] _ in
            // "아니오" 선택 시 현재 뷰 컨트롤러를 닫기
            self?.dismiss(animated: true, completion: nil)
        }
     
        
        
        alert.addAction(editAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
      // 네 / 아니오 눌렀을 때에 따라 상태변경
     // NoAction 클릭시 dismiss
        
  
      
        //dismiss(animated: true, completion: nil)
        
    }
    
    


}
