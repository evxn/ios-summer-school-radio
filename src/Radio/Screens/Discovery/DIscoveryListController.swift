import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	let bag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		BaseService.shared.getRadioStations()
			.asDriver(onErrorJustReturn: [])
			.drive(
				tableView.rx.items(
					cellIdentifier: "DiscoveryItemCell",
					cellType: DiscoveryItemCell.self
				)
			) { index, station, cell in
				cell.titleLable?.text = station.title
				
				cell.thumbnailImageLoadingOverlay.isHidden = false
				BaseService.shared.loadImage(by: station.imageUrl)
					.observeOn(MainScheduler.instance)
					.asSingle()
					.subscribe({event in
						cell.thumbnailImageLoadingOverlay.isHidden = true
						
						switch event {
						case SingleEvent.success(let data):
							cell.thumbnailImage?.image = UIImage.init(data: data)
						case SingleEvent.error:
							// set placeholder image
							cell.thumbnailImage?.image = UIImage(named: "icons8-microphone")
							cell.thumbnailImage?.backgroundColor = UIColor.init(red: 1, green: 0.8, blue: 0, alpha: 1)
						}
					})
					.disposed(by: self.bag)
			}
			.disposed(by: bag)
				
		// MARK: Navigation
		
		tableView.rx.modelSelected(RadioStationDto.self)
			.observeOn(MainScheduler.instance)
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: {
				model in UtilsService.shared.openViewContoller(
					withIdentifier: "DetailController",
					in: self.navigationController,
					transform: { vc in
						guard let viewController = vc as? DetailController else {
							print("Cannot instantiate DetailController")
							return vc
						}
						
						viewController.model = model
						
						return viewController
					}
				)
			})
			.disposed(by: bag)
	}
	
}
