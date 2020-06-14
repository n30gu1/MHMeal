import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    @IBOutlet var navigationBar: UINavigationBar!
    var date = Date()
    var width: CGFloat = 55
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapDismissButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension CalendarViewController: JTACMonthViewDelegate {
    
    // Cell register
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    // Cell forItemAt
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    // Cell Did Selected
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        self.date = date
        configureCell(view: cell, cellState: cellState)
    }

    // Cell Did Deselected
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    // Configure Cell UI
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        cell.selectedView.layer.cornerRadius = self.width / 2
        cell.selectedView.backgroundColor = UIColor.systemBlue
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    // Config Cell Date Text Color
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.label
            if cellState.isSelected {
                cell.dateLabel.textColor = UIColor.white
            }
        } else {
            cell.dateLabel.textColor = UIColor.gray
            if cellState.isSelected {
                cell.dateLabel.textColor = UIColor.white
            }
        }
    }
    
    // Configure to Show "Selected View"
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    // Configure Calendar Header
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let locale = NSLocale.current.languageCode
        let monthf = DateFormatter()
        let yearf = DateFormatter()
        if locale == "ko" {
            monthf.dateFormat = "M월"
            yearf.dateFormat = "yyyy년"
        } else {
            monthf.dateFormat = "MMMM"
            yearf.dateFormat = "yyyy"
        }
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath) as! Header
        header.yearTitle.text = yearf.string(from: range.start)
        header.monthTitle.text = monthf.string(from: range.start)
        return header
    }
    
    // Calendar Header Height
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 100)
    }
}

extension CalendarViewController: JTACMonthViewDataSource {
    
    // Configure Calendar View
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        calendar.scrollingMode = .stopAtEachCalendarFrame
        calendar.scrollDirection = .horizontal
        calendar.selectDates([self.date])
        calendar.showsHorizontalScrollIndicator = false
        calendar.scrollToDate(self.date, animateScroll: false)
        
        self.width = (UIScreen.main.bounds.width - 16) / 7
        
        let startDate = formatter.date(from: "2018 03 02")!
        let endDate = Date().addingTimeInterval(86400*365)
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}


