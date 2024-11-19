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
    var alertTexts: [String] = []
    @IBOutlet weak var tableView: UITableView!
    var instance: EditViewController?
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.register(UINib(nibName: "ReadTableViewCell", bundle: nil), forCellReuseIdentifier: "ReadTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        loadNotesFromUserDefaults()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // init -> loadView -> viewDidLoad -> viewWillAppear -> viewDidAppear -> viewWillDisappear -> viewDidDisappear -> viewDidUnload
        
        // 앱이 켜지자마자 custom alert view를 보여주려면 viewDidLoad가 아닌, 뷰 컨트롤러가 화면에 표시된 후에 알림을 띄워야 합니다.
        // viewDidLoad는 뷰 계층이 아직 화면에 표시되기 전에 호출되기 때문에 알림을 표시하려는 코드가 무시될 수 있습니다. 이를 해결하려면 **viewDidAppear**를 사용하면 됩니다.

//        if shouldShowAlertToday() {
//                customAlert()
//                saveAlertDate()
//            }
        
        customAlert()
        
    }
    
    func shouldShowAlertToday() -> Bool {
        let defaults = UserDefaults.standard
        
        // 저장된 마지막 알림 날짜 가져오기
        if let lastAlertDate = defaults.object(forKey: "lastAlertDate") as? Date {
            let calendar = Calendar.current
            print("last ==== \(lastAlertDate)")
            
            // 오늘 날짜와 마지막 알림 날짜 비교
            return !calendar.isDateInToday(lastAlertDate)
        }
        
        // 저장된 날짜가 없으면 첫 실행이므로 알림 표시
        return true
    }

    func saveAlertDate() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "lastAlertDate") // 현재 날짜 저장
    }


    func customAlert(){
        let customAlertStoryboard = UIStoryboard(name: "CustomAlertViewController", bundle: nil)
              if let customAlertViewController = customAlertStoryboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController{

                  customAlertViewController.modalPresentationStyle = .overFullScreen
                  customAlertViewController.modalTransitionStyle = .crossDissolve
//                  customAlertViewController.todayText.text = ""
                  customAlertViewController.delegate = self
                  present(customAlertViewController, animated: true, completion: nil)
              }
    
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
        return 100
//        UITableView.automaticDimension
    }
}
extension WriteViewController: CustomAlertDelegate {
    func alertText(_ text: String) {
        
        alertTexts.insert(text, at: 0)
       // tableView.reloadData()
    }
    
    func action() {
        // 확인 버튼 이벤트 처리
            }
    
    func exit() {
        // 취소 버튼 이벤트 처리
    }
}
