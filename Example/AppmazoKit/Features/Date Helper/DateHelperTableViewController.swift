//
//  DateHelperTableViewController.swift
//  AppmazoKitExample
//
//  Created by James Hickman on 5/22/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit

class DateHelperTableViewController: UITableViewController, Storyboardable {
    private var dateToCompare = Date(timeIntervalSinceNow: 60*60*24)
    private var countdownTimer: Timer?
    
    private enum Section: Int {
        case main
        case count
    }
    
    private enum Row: Int {
        case textField
        case countdown
        case years
        case months
        case weeks
        case days
        case hours
        case minutes
        case seconds
        case count
    }
    
    // MARK: - UITableViewController
    
    deinit {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Date Helpers"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.reuseIdentifier)
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.reuseIdentifier)
        
        let countdownTimer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
            DispatchQueue.main.async {
                if let weakSelf = self {
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: Row.countdown.rawValue, section: Section.main.rawValue)], with: .automatic)
                }
            }
        })
        RunLoop.main.add(countdownTimer, forMode: RunLoop.Mode.common)
        self.countdownTimer = countdownTimer
    }
    
    // MARK: - DateHelperTableViewController

    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        let suffix = Date() <= dateToCompare ? "Away" : "Ago"
        
        switch indexPath.row {
        case Row.textField.rawValue:
            if let datePickerCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.reuseIdentifier, for: indexPath) as? DatePickerTableViewCell {
                datePickerCell.delegate = self
                datePickerCell.promptText = "DATE TO COMPARE TO TODAY"
                datePickerCell.placeholderText = Date(timeIntervalSinceNow: 60*60*24).convertToString() // Tomorrow
                cell = datePickerCell
            } else {
                cell = UITableViewCell()
            }
        case Row.countdown.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier, for: indexPath)

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: dateToCompare)
            if let years = dateComponents.year, let months = dateComponents.month, let days = dateComponents.day, let hours = dateComponents.hour, let minutes = dateComponents.minute, let seconds = dateComponents.second {
                cell.textLabel?.text = String(format: "%iy:%02im:%02id:%02ih:%02im:%02is", years, months, days, hours, minutes, seconds)
                cell.detailTextLabel?.text = "COUNTDOWN"
            } else {
                cell.textLabel?.text = nil
            }
        case Row.years.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier, for: indexPath)
            if let years = dateToCompare.years(fromDate: Date()) {
                cell.textLabel?.text = "\(abs(years))"
                cell.detailTextLabel?.text = years == 1 ? "Year \(suffix)" : "Years \(suffix)"
            } else {
                cell.textLabel?.text = "0"
                cell.detailTextLabel?.text = "Years \(suffix)"
            }
        case Row.months.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier, for: indexPath)
            if let months = dateToCompare.months(fromDate: Date()) {
                cell.textLabel?.text = "\(abs(months))"
                cell.detailTextLabel?.text = months == 1 ? "Month \(suffix)" : "months \(suffix)"
            } else {
                cell.textLabel?.text = "0"
                cell.detailTextLabel?.text = "Months \(suffix)"
            }
        case Row.weeks.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier, for: indexPath)
            if let weeks = dateToCompare.weeks(fromDate: Date()) {
                cell.textLabel?.text = "\(abs(weeks))"
                cell.detailTextLabel?.text = weeks == 1 ? "Week \(suffix)" : "Weeks \(suffix)"
            } else {
                cell.textLabel?.text = "0"
                cell.detailTextLabel?.text = "Weeks \(suffix)"
            }
        case Row.days.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier, for: indexPath)
            if let days = dateToCompare.days(fromDate: Date()) {
                cell.textLabel?.text = "\(abs(days))"
                cell.detailTextLabel?.text = days == 1 ? "Day \(suffix)" : "Days \(suffix)"
            } else {
                cell.textLabel?.text = "0"
                cell.detailTextLabel?.text = "Days \(suffix)"
            }
        case Row.hours.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier, for: indexPath)
            if let hours = dateToCompare.hours(fromDate: Date()) {
                cell.textLabel?.text = "\(abs(hours))"
                cell.detailTextLabel?.text = hours == 1 ? "Hour \(suffix)" : "Hours \(suffix)"
            } else {
                cell.textLabel?.text = "0"
                cell.detailTextLabel?.text = "Hours \(suffix)"
            }
        case Row.minutes.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier, for: indexPath)
            if let minutes = dateToCompare.minutes(fromDate: Date()) {
                cell.textLabel?.text = "\(abs(minutes))"
                cell.detailTextLabel?.text = minutes == 1 ? "Minute \(suffix)" : "Minutes \(suffix)"
            } else {
                cell.textLabel?.text = "0"
                cell.detailTextLabel?.text = "Minutes \(suffix)"
            }
        case Row.seconds.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier, for: indexPath)
            if let seconds = dateToCompare.seconds(fromDate: Date()) {
                cell.textLabel?.text = "\(abs(seconds))"
                cell.detailTextLabel?.text = seconds == 1 ? "Second \(suffix)" : "Seconds \(suffix)"
            } else {
                cell.textLabel?.text = "0"
                cell.detailTextLabel?.text = "Seconds \(suffix)"
            }
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
}

extension DateHelperTableViewController: DatePickerTableViewCellDelegate {
    func datePickerTableViewCell(_ datePickerTableViewCell: DatePickerTableViewCell, didFinishPickingDate date: Date?) {
        guard let date = date else { return }
        
        dateToCompare = date
        tableView.reloadData()
    }
}
