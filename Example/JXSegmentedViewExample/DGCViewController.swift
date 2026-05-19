//
//  DGCViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class DGCViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        tableView.rowHeight = 44
        title = "DGCJXSegmentedView Example"
        dgc_configNavigationBar()
    }
    
    private func dgc_configNavigationBar() {
        let dgc_titleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18, weight: .medium)]
        if #available(iOS 15.0, *) {
            let dgc_appearance = UINavigationBarAppearance()
            dgc_appearance.configureWithOpaqueBackground()
            dgc_appearance.backgroundColor = .white
            dgc_appearance.titleTextAttributes = dgc_titleAttributes
            navigationController?.navigationBar.scrollEdgeAppearance = dgc_appearance
            navigationController?.navigationBar.standardAppearance = dgc_appearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = dgc_titleAttributes
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = .black
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dgc_cell = tableView.cellForRow(at: indexPath)
        var dgc_title: String?
        for subview in dgc_cell!.contentView.subviews {
            if let dgc_label = subview as? UILabel {
                dgc_title = dgc_label.text
                break
            }
        }

        switch indexPath.row {
        case 0:
            let dgc_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DGCIndicatorCustomizeViewController")
            dgc_vc.dgc_title = dgc_title
            navigationController?.pushViewController(dgc_vc, animated: true)
        case 1:
            let dgc_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DGCCellCustomizeViewController")
            dgc_vc.dgc_title = dgc_title
            navigationController?.pushViewController(dgc_vc, animated: true)
        case 2:
            let dgc_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DGCSpecialCustomizeViewController")
            dgc_vc.dgc_title = dgc_title
            navigationController?.pushViewController(dgc_vc, animated: true)
        default:
            break
        }
    }
}

