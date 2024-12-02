//
//  CheerUpViewController.swift
//  CheerUP
//
//  Created by 박수연 on 11/19/24.
//

import UIKit



class CheerUpViewController: UIViewController {
    
    var alertTexts: [String] = []
    var instance: CheerUpViewController?
    
    lazy var dateView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        
        
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 0
       
        
        
        return tableView
    }()
    
    var selectedDate: DateComponents? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        applyConstraints()
        setCalendar()
        reloadDateView(date: Date())
        
        tableView.backgroundColor = UIColor(red: 0.8196, green: 0.6039, blue: 0.7255, alpha: 1.0)
        tableView.register(CheerUpTVCell.self, forCellReuseIdentifier:
                            "cheerUpTVCell")
        tableView.dataSource = self
        tableView.delegate = self
        loadAlertFromUserDefaults()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // init -> loadView -> viewDidLoad -> viewWillAppear -> viewDidAppear -> viewWillDisappear -> viewDidDisappear -> viewDidUnload
        
        // 앱이 켜지자마자 custom alert view를 보여주려면 viewDidLoad가 아닌, 뷰 컨트롤러가 화면에 표시된 후에 알림을 띄워야 합니다.
        // viewDidLoad는 뷰 계층이 아직 화면에 표시되기 전에 호출되기 때문에 알림을 표시하려는 코드가 무시될 수 있습니다. 이를 해결하려면 **viewDidAppear**를 사용하면 됩니다.

        if shouldShowAlertToday() {
            customAlert()
            saveAlertDate()
        }
        
          // customAlert()
        
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

    
    fileprivate func setCalendar() {
        dateView.delegate = self

        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
    fileprivate func applyConstraints() {
        view.addSubview(dateView)
        view.addSubview(tableView)
        
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ]
        let tableViewConstraints = [
               tableView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 0),
               tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
           ]
           
        
        
        
        NSLayoutConstraint.activate(dateViewConstraints + tableViewConstraints)
        dateView.backgroundColor = UIColor(red: 0.9765, green: 0.6941, blue: 0.7922, alpha: 1.0)
        dateView.layer.cornerRadius = 30
        dateView.tintColor = .white
        
        
    }
    
    
//    func reloadDateView(date: Date?) {
//        if date == nil { return }
//        let calendar = Calendar.current
//        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
//    }
//    
    func reloadDateView(date: Date?) {
        guard let date = date else {
            return
        }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date)], animated: true)
    }
    func customAlert(){
        let customAlertStoryboard = UIStoryboard(name: "CustomAlertViewController", bundle: nil)
              if let customAlertViewController = customAlertStoryboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController{

                  customAlertViewController.modalPresentationStyle = .overFullScreen
                  customAlertViewController.modalTransitionStyle = .crossDissolve
                  customAlertViewController.delegate = self
                  present(customAlertViewController, animated: true, completion: nil)
              }
    
    }
    
    
}
extension CheerUpViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    // UICalendarView
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            return .customView {
                let label = UILabel()
                label.text = "🤍"
                label.textAlignment = .center
                return label
            }
        }
        return nil
    }
    
    // 달력에서 날짜 선택했을 경우
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        reloadDateView(date: Calendar.current.date(from: dateComponents!))
    }
    
    
}
extension CheerUpViewController: CustomAlertDelegate {
    
    func alertText(_ text: String) {
        
        print("텍스트 === \(text)")
        alertTexts.insert(text, at: 0)
        self.tableView.reloadData()
        saveAlertUserDefaults()
    }
    
    func saveAlertUserDefaults() {
        UserDefaults.standard.set(alertTexts, forKey: "alertTexts")
    }
    
    // UserDefaults에서 메모 불러오기
    func loadAlertFromUserDefaults() {
        alertTexts = UserDefaults.standard.stringArray(forKey: "alertTexts") ?? []
    }

    
    func action() {
        // 확인 버튼 이벤트 처리
            }
    
    func exit() {
        // 취소 버튼 이벤트 처리
    }
}
extension CheerUpViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(alertTexts.count)
     
        
        return alertTexts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cheerUpTVCell", for: indexPath) as! CheerUpTVCell
        cell.cheerUpLabel?.text = "✨" + alertTexts[indexPath.row] + "✨"
        cell.backgroundColor = UIColor(red: 0.8196, green: 0.6039, blue: 0.7255, alpha: 1.0) /* #d19ab9 */
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // 데이터 소스에서 항목 삭제
              alertTexts.remove(at: indexPath.row)
              // 테이블뷰에서 셀 삭제
              tableView.deleteRows(at: [indexPath], with: .fade)
             
              // 테이블뷰를 지우고 난 후 데이터 수정
              saveAlertUserDefaults()
              
          }
      }

}
