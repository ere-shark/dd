//
//  DyWrController.swift
//  mddy
//
//  Created by 스마트컨텐츠 on 2025/05/13.
//

import UIKit

class DyWrController: UIViewController {
    
    @IBOutlet var titlelabel: UITextField!      // 제목 입력 필드
    @IBOutlet var datelabel: UILabel!           // 날짜 표시 레이블
    @IBOutlet var datepick: UIDatePicker!       // 날짜 선택 피커
    @IBOutlet var writedy: UITextView!          // 일기 입력용 텍스트뷰
    @IBOutlet var cancelbutton: UIButton!       // 취소 버튼
    @IBOutlet var moodbutton: UIButton!         // 감정 선택 버튼
    @IBOutlet var savebutton: UIButton!         // 저장 버튼
    
    // 편집 중인 일기 데이터
    var existingDiaryEntry: [String: String]?    // 수정할 기존 일기
    var editingIndex: Int?                       // 수정 중인 인덱스
    var selectedMood: String?                   // 선택된 감정
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) 화면 배경 색 설정
        view.backgroundColor = UIColor.systemGray6
        
        // 2) 제목 TextField 스타일
        titlelabel.borderStyle = .roundedRect
        titlelabel.layer.borderWidth = 1.0
        titlelabel.layer.borderColor = UIColor.systemGray4.cgColor
        titlelabel.layer.cornerRadius = 6
        titlelabel.backgroundColor = UIColor.systemBackground
        titlelabel.placeholder = "제목을 입력하세요"
        
        // 3) 날짜 레이블 스타일
        datelabel.font = UIFont.preferredFont(forTextStyle: .body)
        datelabel.textColor = .label
        
        // 4) DatePicker 컴팩트 스타일
        if #available(iOS 13.4, *) {
            datepick.preferredDatePickerStyle = .compact
        }
        datepick.tintColor = .systemBlue
        
        // 5) 일기 TextView 스타일
        writedy.textContainerInset = .zero
        writedy.contentInset = .zero
        writedy.isScrollEnabled = true
        writedy.returnKeyType = .default
        writedy.keyboardDismissMode = .none
        writedy.layer.borderWidth = 1.0
        writedy.layer.borderColor = UIColor.systemGray4.cgColor
        writedy.layer.cornerRadius = 6
        writedy.backgroundColor = UIColor.systemBackground
        
        // 6) 버튼 공통 스타일
        cancelbutton.setTitle("취소", for: .normal)
        moodbutton.setTitle("감정 넣기", for: .normal)
        savebutton.setTitle("저장", for: .normal)
        
        // a) 취소 버튼 색상
        cancelbutton.backgroundColor = UIColor.systemRed
        cancelbutton.setTitleColor(.white, for: .normal)
        cancelbutton.layer.cornerRadius = 8
        
        // b) 감정 선택 버튼 색상 및 패딩
        moodbutton.backgroundColor = UIColor.systemOrange
        moodbutton.setTitleColor(.white, for: .normal)
        moodbutton.layer.cornerRadius = 8
        moodbutton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
        
        // c) 저장 버튼 색상
        savebutton.backgroundColor = UIColor.systemBlue
        savebutton.setTitleColor(.white, for: .normal)
        savebutton.layer.cornerRadius = 8
        
        // 7) 기존 일기 데이터가 있으면 표시
        if let entry = existingDiaryEntry {
            titlelabel.text = entry["title"]
            writedy.text = entry["body"]
            datelabel.text = entry["date"]
            selectedMood = entry["mood"] ?? ""
            if let mood = selectedMood, !mood.isEmpty {
                moodbutton.setTitle("감정: \(mood)", for: .normal)
            }
        }
        
        // 8) 날짜 피커 기본값 설정
        let today = Date()
        updateDateLabel(with: today)
        datepick.date = today
        datepick.addTarget(self, action: #selector(datechage(_:)), for: .valueChanged)
    }
    
    // 날짜 선택 시 레이블 업데이트
    @IBAction func datechage(_ sender: UIDatePicker) {
        updateDateLabel(with: sender.date)
    }
    
    private func updateDateLabel(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        datelabel.text = formatter.string(from: date)
    }
    
    // 저장 버튼 액션
    @IBAction func savebutton(_ sender: UIButton) {
        guard let titleText = titlelabel.text, !titleText.isEmpty,
              let diaryText = writedy.text, !diaryText.isEmpty,
              let dateText = datelabel.text else {
            showAlert(title: "제목이나 내용이 빠졌어요!", message: "제목과 내용을 모두 입력해주세요.")
            return
        }
        let diaryEntry: [String: String] = [
            "title": titleText,
            "date": dateText,
            "body": diaryText,
            "mood": selectedMood ?? ""
        ]
        var diaryList = UserDefaults.standard.array(forKey: "diaryList") as? [[String: String]] ?? []
        if let index = editingIndex {
            diaryList[index] = diaryEntry
        } else {
            diaryList.append(diaryEntry)
        }
        UserDefaults.standard.set(diaryList, forKey: "diaryList")
        showAlert(title: "저장 완료", message: "일기가 저장되었습니다.") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 취소 버튼 액션
    @IBAction func cancelbutton(_ sender: UIButton) {
        titlelabel.text = ""
        writedy.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    // 감정 선택 액션
    @IBAction func moodbuttonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "감정을 선택하세요", message: nil, preferredStyle: .actionSheet)
        let moods = ["기쁨","행복","만족","뿌듯함","놀람","편안함","감사","사랑","설렘","감동","슬픔","우울함","외로움","무기력","지침","화남","짜증","불안","혼란","실망"]
        moods.forEach { mood in
            alert.addAction(UIAlertAction(title: mood, style: .default) { _ in
                self.selectedMood = mood
                self.moodbutton.setTitle("감정 \(mood)", for: .normal)
            })
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        if let popover = alert.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        present(alert, animated: true)
    }
    
    // 공통 Alert 표시
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}
