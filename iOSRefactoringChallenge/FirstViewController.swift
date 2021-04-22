import UIKit

struct Track {
    var trackId: Int
    var trackTitle: String
}

class TrackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var allTracks: [String]!
    var tracks: [Track] = []
    
    public override func viewDidLoad() {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.tableView = tableView
        if self.tracks.count == 0 {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            let url = URL(string: "https://api.soundcloud.com/playlists/79670980?client_id=i71BoBoxTxlbVYvnt7O2reL86DynpqT3&client_secret=Mh6G90LOOuz1Vd04gBsNQMmHFwocWUzk")
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                print("[LOG] fetching data: \(data)")
                print("[LOG] data from api \(error)")
                print("[LOG] response: \(response)")

                if error != nil {
                    DispatchQueue.main.sync {
                        let failedAlert: UIAlertController? = UIAlertController(title: "Failed to load playlist", message: "Sorry...", preferredStyle: .alert)
                        failedAlert!.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(failedAlert!, animated: true, completion: nil)
                    }
                } else if error == nil && data != nil {
                    if self.convertDataToTracks(data: data!) == true {
                        var tracks = [Track]()
                        var id = -1
                        for t in self.allTracks {
                            id+=1
                            let track = Track(trackId: id, trackTitle: t)
                            self.tracks.append(track)
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).resume()
        } else {
            self.tableView.delegate = nil
            self.tableView.dataSource = nil
            self.tableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return allTracks.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = tracks.filter { $0.trackId == indexPath.row }.first!.trackTitle
        return cell
    }

    public override func viewDidAppear(_ animated: Bool) {}
    
    public func convertDataToTracks(data: Data!) -> Bool {
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data) as? NSDictionary

            self.allTracks = Array<String>()
            //print(allTracks)
            for t in jsonDict!["tracks"] as! Array<Dictionary<String, Any>> {
                //print(t)
                for (u,v) in t {
                    if u == "title" {
                        print(v)
                        allTracks.append(v as! String)
                    }
                    
                }
            }
        } catch {
            DispatchQueue.main.sync {
                let failedAlert: UIAlertController? = UIAlertController(title: "Failed to load playlist", message: "Sorry...", preferredStyle: .alert)
                failedAlert!.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(failedAlert!, animated: true, completion: nil)
            }
        }
        
        return true
    }
}
