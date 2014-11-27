//
//  RankingDetailViewControllerSwift.swift
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 26.11.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

import UIKit

class RankingDetailViewControllerSwift: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak  var theTableView:UITableView!
    var theDataSource = NSDictionary()

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Init & lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        theTableView.delegate   = self
        theTableView.dataSource = self;
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
            if let regattas = theDataSource["regatta"] as? NSArray {
                var counter:Int = 0
                for elem in regattas {
                    if let regatta = elem as? NSDictionary {
                        if (regatta["regattaId"] != nil) {
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

            cell.firstnamenameLabel.text    = (theDataSource["firstname"] as String) + " " + (theDataSource["name"] as String)
            cell.clubLabel.text             = theDataSource["club"] as? String
            cell.sailCountryLabel.text      = theDataSource["sailCountry"] as? String
            cell.sailNumberLabel.text       = theDataSource["sailNumber"] as? String
            cell.yobLabel.text              = theDataSource["yob"] as? String
            cell.totalRunsLabel.text        = String(theDataSource["totalRuns"] as Int)
            cell.totalPointsLabel.text      = NSString(format:"%.2f", theDataSource["totalPoints"] as Float)
            cell.posLabel.text              = String(theDataSource["pos"] as Int)
            return cell

        default:
            let regatta = theDataSource["regatta"]?[indexPath.row] as NSDictionary
            var cell:RegattaDetailCell = RegattaDetailCell()
            cell = tableView.dequeueReusableCellWithIdentifier("RegattaDetailCell", forIndexPath: indexPath) as RegattaDetailCell
            cell.selectionStyle = .None

            cell.rnamelabel.text            = regatta["rname"] as? String
            cell.sl_pointsLabel.text        = regatta["sl_points"] as? String
            cell.sl_points_cupLabel.text    = regatta["sl_points_cup"] as? String
            cell.positionboatsLabel.text    = (regatta["position"] as String) + "/" + (regatta["boats"] as String)
            cell.runs_totalLabel.text       = regatta["runs_total"] as? String
            cell.runs_scoredLabel.text      = regatta["runs_scored"] as? String
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
