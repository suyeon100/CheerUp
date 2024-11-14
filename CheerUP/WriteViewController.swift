//
//  ViewController.swift
//  CheerUP
//
//  Created by 박수연 on 11/6/24.
//


// Cheer-Up APP
// 매일 응원의 메세지 보내기
// 사람들에게 응원을 주기도하고, 나의 일상 기록

// 일기 작성 뷰 만들기 ✔️
// 글쓰고 UserDefault로 데이터 저장 ✔️
// 테이블 뷰에 데이터 보여주기✔️
// 동적으로 셀 높이 조절하기 ✔️
// 테이블 뷰 클릭시 해당 일기 보여주기
// 테이블 뷰 삭제기능 ✔️


 
import UIKit

class WriteViewController: UIViewController, DiaryInputDelegate{
    
    
    var notes: [String] = []
    @IBOutlet weak var tableView: UITableView!
    var instance: EditViewController?
 

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ReadTableViewCell", bundle: nil), forCellReuseIdentifier: "ReadTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        loadNotesFromUserDefaults()
    }

    
    @IBAction func writeBtn(_ sender: Any) {
//        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TextView") else { return }
//        self.present(nextVC, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
             if let noteInputVC = storyboard.instantiateViewController(identifier: "TextView") as? TextViewController {
                 noteInputVC.delegate = self
                 present(noteInputVC, animated: true, completion: nil)
             }
    }
  
    
    func didAddNote(_ note: String) {
        //  notes.append(note)
        notes.insert(note, at: 0) // 일기 최신순으로 이동
        tableView.reloadData()
        saveNotesToUserDefaults()
    }
    
    // UserDefaults에 메모 저장
    func saveNotesToUserDefaults() {
        UserDefaults.standard.set(notes, forKey: "notes")
    }
    
    // UserDefaults에서 메모 불러오기
    func loadNotesFromUserDefaults() {
        notes = UserDefaults.standard.stringArray(forKey: "notes") ?? []
    }

}

extension WriteViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadTableViewCell", for: indexPath) as! ReadTableViewCell
        
       cell.diary?.text = notes[indexPath.row]
 
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 클릭된 아이템 가져오기
        let selectedNote = notes[indexPath.row]
        
        // DetailViewController 호출
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(identifier: "Edit") as? EditViewController {
         
            detailVC.selectedText = selectedNote
            present(detailVC, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // 데이터 소스에서 항목 삭제
              notes.remove(at: indexPath.row)
              // 테이블뷰에서 셀 삭제
              tableView.deleteRows(at: [indexPath], with: .fade)
             
              // 테이블뷰를 지우고 난 후 데이터 수정
              saveNotesToUserDefaults()
              
          }
      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 
        UITableView.automaticDimension
    }
}
