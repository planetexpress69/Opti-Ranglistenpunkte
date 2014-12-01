//
//  RankingDetailViewControllerSwift.swift
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 26.11.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

import UIKit

class RankingDetailViewControllerSwift: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var theTableView:UITableView!
    var theDataSource = NSDictionary()

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Init & lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.theTableView.delegate   = self
        self.theTableView.dataSource = self;
        self.title              = "Detail"
    }

    // -----------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource protocol methods
    // -----------------------------------------------------------------------------------------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    // -----------------------------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if let regattas = self.theDataSource["regatta"] as? NSArray {
                var counter:Int = 0
                for elem in regattas {
                    if let regatta = elem as? NSDictionary {
                        if let regattaId = regatta["regattaId"] as? String {
                            counter++
                        }
                    }
                }
                return counter
            } else {
                return 1
            }
        }
    }

    // -----------------------------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.section {

        case 0:
            var cell:SailorCell = SailorCell()
            cell = tableView.dequeueReusableCellWithIdentifier("SailorCell", forIndexPath: indexPath) as SailorCell
            cell.selectionStyle = .None
            // ---------------------------------------------------------------------------------------------------------
            cell.firstnamenameLabel.text    = (self.theDataSource["firstname"] as String) + " " + (theDataSource["name"] as String)
            cell.clubLabel.text             = self.theDataSource["club"] as? String
            cell.sailCountryLabel.text      = self.theDataSource["sailCountry"] as? String
            cell.sailNumberLabel.text       = self.theDataSource["sailNumber"] as? String
            // ---------------------------------------------------------------------------------------------------------
            var yob: String
            if let y = self.theDataSource["yob"] as? String {
                yob = y
            } else if let y = self.theDataSource["yob"] as? Int {
                yob = String(y)
            } else {
                yob = "-"
            }
            cell.yobLabel.text = yob
            // ---------------------------------------------------------------------------------------------------------
            var totalPoints: String
            if let tp = self.theDataSource["totalPoints"] as? String {
                totalPoints = tp
            } else if let tp = self.theDataSource["totalPoints"] as? Float {
                totalPoints = NSString(format:"%.2f", tp)
            } else {
                totalPoints = "-"
            }
            cell.totalPointsLabel.text = totalPoints
            // ---------------------------------------------------------------------------------------------------------
            var totalRuns : String
            if let tr = self.theDataSource["totalRuns"] as? String {
                totalRuns = tr
            } else if let tr = self.theDataSource["totalRuns"] as? Int {
                totalRuns = String(tr)
            } else {
                totalRuns = "-"
            }
            cell.totalRunsLabel.text = totalRuns
            // ---------------------------------------------------------------------------------------------------------
            var pos: String
            if let p = self.theDataSource["pos"] as? String {
                pos = p
            } else if let p = self.theDataSource["pos"] as? Int {
                pos = String(p)
            } else {
                pos = "-"
            }
            cell.posLabel.text = pos
            // ---------------------------------------------------------------------------------------------------------
            return cell

        default:
            let regatta = self.theDataSource["regatta"]?[indexPath.row] as NSDictionary
            var cell:RegattaDetailCell = RegattaDetailCell()
            cell = tableView.dequeueReusableCellWithIdentifier("RegattaDetailCell", forIndexPath: indexPath) as RegattaDetailCell
            cell.selectionStyle = .None
            // ---------------------------------------------------------------------------------------------------------
            cell.rnamelabel.text            = regatta["rname"] as? String
            cell.sl_pointsLabel.text        = regatta["sl_points"] as? String
            cell.sl_points_cupLabel.text    = regatta["sl_points_cup"] as? String
            // ---------------------------------------------------------------------------------------------------------
            var position : String
            if let pos = regatta["position"] as? String {
                position = pos
            } else if let pos = regatta["position"] as? Int {
                position = String(pos)
            } else {
                position = "-"
            }
            // ---------------------------------------------------------------------------------------------------------
            var boats : String
            if let b = regatta["boats"] as? String {
                boats = b
            } else if let b = regatta["boats"] as? Int {
                boats = String(b)
            } else {
                boats = "-"
            }
            cell.positionboatsLabel.text    = position + "/" + boats
            // ---------------------------------------------------------------------------------------------------------
            var total: String
            if let t: String = regatta["runs_total"] as? String {
                total = t
            } else if let t: Int = regatta["runs_total"] as? Int {
                total = String(t)
            } else {
                total = "-"
            }
            cell.runs_totalLabel.text = total
            // ---------------------------------------------------------------------------------------------------------
            var scored: String
            if let s: String = regatta["runs_scored"] as? String {
                scored = s
            } else if let s: Int = regatta["runs_scored"] as? Int {
                scored = String(s)
            } else {
                scored = "-"
            }
            cell.runs_scoredLabel.text = scored
            // ---------------------------------------------------------------------------------------------------------
            return cell
        }
    }

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate protocol methods
    // -----------------------------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 120.0 : 80.0
    }

}
