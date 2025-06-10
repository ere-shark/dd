import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - IBOutlets
    @IBOutlet var categorySegmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!

    // MARK: - Mood 카테고리 설정
    let categories = ["전체", "화창", "산들바람", "비", "폭풍"]
    let categoryMap: [String: [String]] = [
        "화창":    ["기쁨", "행복", "만족", "뿌듯함", "놀람"],
        "산들바람": ["편안함", "감사", "사랑", "설렘", "감동"],
        "비":      ["슬픔", "우울함", "외로움", "무기력", "지침"],
        "폭풍":    ["화남", "짜증", "불안", "혼란", "실망"]
    ]

    // MARK: - 저장된 일기 데이터
    var diaryList: [[String: String]] = []
    var filteredList: [[String: String]] = []
    var selectedIndexPath: IndexPath?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1) 배경색 및 테이블뷰 스타일
        view.backgroundColor = UIColor.systemGray6
        tableView.backgroundColor = UIColor.systemGray6
        tableView.separatorColor = UIColor.systemGray4
        tableView.tableFooterView = UIView()

        // 2) SegmentedControl 스타일
        categorySegmentedControl.removeAllSegments()
        for (idx, title) in categories.enumerated() {
            categorySegmentedControl.insertSegment(withTitle: title, at: idx, animated: false)
        }
        categorySegmentedControl.selectedSegmentIndex = 0
        categorySegmentedControl.addTarget(self,
                                           action: #selector(categoryChanged(_:)),
                                           for: .valueChanged)
        categorySegmentedControl.backgroundColor = UIColor.systemBackground
        categorySegmentedControl.selectedSegmentTintColor = UIColor.systemOrange
        let normalAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray]
        let selectedAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        categorySegmentedControl.setTitleTextAttributes(normalAttr, for: .normal)
        categorySegmentedControl.setTitleTextAttributes(selectedAttr, for: .selected)

        // 3) TableView 데이타소스/델리게이트
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // UserDefaults에서 저장된 일기 불러오기
        diaryList = UserDefaults.standard.array(forKey: "diaryList") as? [[String: String]] ?? []
        filterDiaries()
    }

    // MARK: - 카테고리 변경 처리
    @objc func categoryChanged(_ sender: UISegmentedControl) {
        filterDiaries()
    }

    func filterDiaries() {
        let selected = categories[categorySegmentedControl.selectedSegmentIndex]
        if selected == "전체" {
            filteredList = diaryList
        } else {
            let moods = categoryMap[selected] ?? []
            filteredList = diaryList.filter { entry in
                guard let mood = entry["mood"] else { return false }
                return moods.contains(mood)
            }
        }
        tableView.reloadData()
    }

    // MARK: - 세그웨이 준비
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let detailVC = segue.destination as? DiaryDetailController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            detailVC.diaryEntry = filteredList[indexPath.row]
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath)
        let diary = filteredList[indexPath.row]
        let title = diary["title"] ?? ""
        let date  = diary["date"]  ?? ""
        let mood  = diary["mood"]  ?? ""

        // 텍스트 설정
        cell.textLabel?.text       = title
        cell.detailTextLabel?.text = "\(date) | \(mood)"
        cell.textLabel?.font       = UIFont.preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        cell.detailTextLabel?.textColor = .secondaryLabel

        // 셀 스타일
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    // MARK: - UITableViewDelegate (셀 표시 전 스타일링)
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        // 컨텐츠 뷰에 inset 적용
        let content = cell.contentView
        content.backgroundColor = .white
        content.layer.cornerRadius = 8
        content.layer.masksToBounds = true
        content.layer.borderWidth = 1
        content.layer.borderColor = UIColor.systemGray4.cgColor
        content.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }

    // MARK: - Swipe Actions (삭제 / 수정)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        // 삭제 액션
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            self.diaryList.remove(at: indexPath.row)
            UserDefaults.standard.set(self.diaryList, forKey: "diaryList")
            self.filterDiaries()
            completion(true)
        }

        // 수정 액션
        let editAction = UIContextualAction(style: .normal, title: "수정") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let writeVC = sb.instantiateViewController(withIdentifier: "DyWrController") as? DyWrController {
                writeVC.modalPresentationStyle = .fullScreen
                writeVC.existingDiaryEntry = self.diaryList[indexPath.row]
                writeVC.editingIndex = indexPath.row
                self.present(writeVC, animated: true)
            }
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    // MARK: - Commit Delete (Swipe 이외 삭제)
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            diaryList.remove(at: indexPath.row)
            UserDefaults.standard.set(diaryList, forKey: "diaryList")
            filterDiaries()
        }
    }

    // MARK: - 편집 함수 (단독 호출용)
    func editDiary(at indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let editVC = sb.instantiateViewController(withIdentifier: "DyWrController") as? DyWrController {
            editVC.existingDiaryEntry = diaryList[indexPath.row]
            editVC.editingIndex = indexPath.row
            present(editVC, animated: true)
        }
    }
}
