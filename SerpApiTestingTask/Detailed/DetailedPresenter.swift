
import UIKit

protocol DetailedPresenterProtocol: AnyObject {
    init(view: DetailedViewProtocol,
         router: DetailedRouterProtocol,
         image: ImagesResult)
    func showDetails()
    func linkButtonPressed()
    func calculateImageHeight(for width: CGFloat) -> CGFloat
    var index: Int { get }
}

class DetailedPresenter: DetailedPresenterProtocol {
    
    weak var view: DetailedViewProtocol?
    private var router: DetailedRouterProtocol!
    private var image: ImagesResult
    let imageLoader = ImageLoader()
    var index: Int
    
    required init(view: DetailedViewProtocol,
                  router: DetailedRouterProtocol,
                  image: ImagesResult) {
        self.view = view
        self.router = router
        self.image = image
        self.index = image.position
    }
    
    @MainActor
    func showDetails() {
        view?.display(title: image.title)
        view?.changeImageViewHeight()
        Task {
            guard let url = URL(string: image.original) else { return }
            let image = try await imageLoader.downloadImage(from: url)
            view?.setup(image: image)
        }
    }
    
    func linkButtonPressed() {
        router.navigateToWebView(for: image)
    }
    
    func calculateImageHeight(for width: CGFloat) -> CGFloat {
        let proportions = CGFloat(image.originalHeight) / CGFloat(image.originalWidth)
        let height = width * proportions
        return height
    }
    
}
