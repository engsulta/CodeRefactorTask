# iOSRefactoringChalenge Task
## Summary

In this document, I will discuss in details how I made the refactor and what is the approach and design descisions also you will find details about further changes to ensure the code is "production ready.



## Features 
1. The Network Layer
2. Architecture Design pattern and Why?
3. Make the Code clean and apply SOLID principles 
4. further changes

## 1. The Network Layer

I have build the network layer to be simple, testable, maintainable and easy to use it to build and execute a complete network request.


### - NetworkClientProtocol

This is the client Network protocol so we can conform on this protocol to create a concrete class for each client api 

Here is the protocol that you need to conform to:

```swift
/// protocol for client api
protocol NetworkClientProtocol {
    var session: URLSessionProtocol { get }
    var baseURL: String { get }
    @discardableResult
    func fetch<T: Decodable>(endPoint: EndPointProtocol,
                            model: T.Type,
                            completion: @escaping NetworkCompletion) -> Cancellable?
}
}
```
Then I created my NetworkClient by conforming the protocol:

```swift
// concrete implementation for the client protocol
class NetworkClient: NetworkClientProtocol {
    var baseURL: String
    var session: URLSessionProtocol

    init(baseURL: String,
         session: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }
}}
```

> Note 1: I am using the URLSessionProtocol for session so I can eaisly mock the default session and inject it from the testing target

> Note 2 : I have implemented the `fetch` method in the protocol extension to be default implementation so client class will not need to do that just use it.

### - EndPointProtocol
```swift
/// this is a protocol for each endpoint such as playlists ... etc
protocol EndPointProtocol {
    var path: String? { get }
    var httpMethod: HTTPMethod { get }
    var httpParameters: [String: String]? { get }
    var headers: [String: String]? { get }
    var timeout: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    func buildRequest(for baseUrl: URL) throws -> URLRequest
}
```

Then I created our playlists endpoint enum by conforming the protocol:

```swift
enum PlaylistEndPoint: EndPointProtocol {
    // all paths for this endpoint
    case playlist(playlistId: String)
    case futureUse

    var httpMethod: HTTPMethod {
        switch self {
        case .playlist:
         return .get
        }
        ...
```
> Note : I have implemented the `buildRequest(for:` method in the protocol extension to be default implementation so each endpoint will not need to do that just can use it directly.


> Note to make network testable I am using protocol `URLSessionProtocol` check all helpers protocolos in NetworkHelperProtocols.swift

Thats All The network layer is ready 

## 2.Architecture Design pattern (MVVM) and Why?
I have decide to refactor the already exisiting MVC to MVVM Architecture design pattren so VC will not be responsible for business and presentation logic
why MVVM? 
1- sepatation for the responsibilty to the three layers (view and viewModel and model)
2- easy to extend View, ViewModel and the Model layer separately
3- Testable as we can test each layer separately also we can inject vm mockable to the vc
4- the viewModel in the MVVM can be shared implementatioin between multiples VCs as long as they have same view model logic 

```swift 
protocol TrackListViewModelProtocol {
    var provider: NetworkClientProtocol { get }
    var tracks: [Track] { get set }
    var loadingErrorClosure: (() -> Void)? { get set }
    
    func fetchTracks(completion: (([Track]) -> Void)?)
    func trackTitle(for indexPath: IndexPath) -> String
}
```
> Note `TrackListViewController` now use a refrence from `TrackListViewModelProtocol` we can change the object passed and mock it easily check UT 

## 3- Make the Code clean and apply SOLID principle
Next step I reviewed the code to avoid any repetion and Applied the DRY principle and Single responsibilty and made the code more readable and easy to debug
- i have change file structure to have folder per each feature
- i removed any extra empty classes, models, images in assets

## 4- further changes to be applied

- we can apply paging while fetching the list so if the playlist has many tracks so no need to fetch all one time and 
- we can show the cached list if this playlist loaded before and then will request the updated plylist from network so user will not wait eachtime restart it 
- we can add Localization
- we can add Repository design pattern for caching
- we can add more UI testing 

Thanks 