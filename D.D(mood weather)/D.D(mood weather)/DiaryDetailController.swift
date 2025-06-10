import UIKit

class DiaryDetailController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var moodlable: UILabel!    // 감정 표시 레이블
    @IBOutlet var bodyTextView: UITextView!
    
    // MARK: - 전달받을 일기 데이터
    var diaryEntry: [String: String]?  // prepare에서 전달받을 데이터
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) 전체 배경 색
        view.backgroundColor = UIColor.systemBackground
        
        // 2) 제목 스타일
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        // 3) 날짜 스타일
        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        dateLabel.textColor = .secondaryLabel

        // 4) 감정 레이블 스타일
        moodlable.font = UIFont.preferredFont(forTextStyle: .callout)
        moodlable.textColor = .white
        moodlable.backgroundColor = UIColor.systemOrange
        moodlable.textAlignment = .center
        moodlable.layer.cornerRadius = 4
        moodlable.clipsToBounds = true
        moodlable.setContentHuggingPriority(.required, for: .horizontal)
        moodlable.setContentCompressionResistancePriority(.required, for: .horizontal)

        // 5) 내용 텍스트뷰 스타일
        bodyTextView.isEditable = false
        bodyTextView.isScrollEnabled = true
        bodyTextView.font = UIFont.preferredFont(forTextStyle: .body)
        bodyTextView.textColor = .label
        bodyTextView.backgroundColor = UIColor.systemGray6
        bodyTextView.layer.borderWidth = 1
        bodyTextView.layer.borderColor = UIColor.systemGray4.cgColor
        bodyTextView.layer.cornerRadius = 8
        bodyTextView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        // 6) 데이터 바인딩
        titleLabel.text = diaryEntry?["title"] ?? "제목 없음"
        dateLabel.text  = diaryEntry?["date"]  ?? "날짜 없음"
        moodlable.text  = diaryEntry?["mood"]  ?? "감정 없음"
        bodyTextView.text = diaryEntry?["body"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "내용 없음"
    }
}
