# PureCache

<a href="https://swift.org/package-manager">
  <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
</a>

PureCache is a no frills implementation of a caching system in Swift.
The main target of this library is to provide a cross-platform implementation that works across all the supported Swift platforms without any additional dependency. In order to maintain that, some principles were defined while implementing this package:

- It's simple: **dead simple**. You pass a (`Codable`) value and its (`Codable & Hashable`) key and you can rest assured it'll be cached.
- It's thread-safe: you can read and write from any thread (even concurrently) and nothing will break.
- It's fast: the library provides in-memory caching out-of-the-box. It also writes to the disk asynchronously *(if disk storage is configured)*.
- It's consistent: the API is very similar to `NSCache`.

Following these principles, some advanced features of other caching mechanisms might never see the light in this library. For example:

- There is no support for automatic objects expiration nor the ability to specify the maximum cache capacity.
- The library does not clean objects automatically when the memory pressure is rising.

*This doesn't mean that these features will never be implemented, it just means that they aren't available right now.*

## Installation
PureCache is available through [Swift Package Manager](https://swift.org/package-manager).

```
.package(url: "https://github.com/MrAsterisco/PureCache", from: "<see GitHub releases>")
```

### Latest Release
To find out the latest version, look at the Releases tab of this repository.

## Getting Started
Using PureCache is very simple. First, you need a `Codable` implementation that is going to be stored in the cache:

```swift
struct SomeCodable: Codable {
  let id: String
  let value: Double
}
```
Then, you can create a `PureCache` instance by calling the initializer:

```swift
let cache = PureCache<UUID, SomeCodable>()
```
To save a value into the cache, you just call:

```swift
let someValue = SomeCodable(id: "ID", value: 25)
cache.setValue(someValue, forKey: someValue.id)
```
Removing the value from the cache, it's as easy as calling:

```swift
let someKey = UUID()
cache.removeValue(forKey: someKey)
```
## Disk Storage
A decent caching system should also support storing its values on the disk *(looking at you, NSCache)*. PureCache provides an implementation called `FileStorage` that manages a Property List file on the disk. You can create an instance as follows:

```swift
let storage = FileStorage()
```
This will automatically point to a file in the user's Caches directory, called `Cache.db`. You can then pass this instance when creating a `PureCache`:

```swift
let cache = PureCache<UUID, SomeCodable>(storage: storage)
```

## Advanced Usages
While the most common use cases are covered with the functions shown above, there are some additional perks hidden in this library that, depending on your specific situation, you may find useful.

### Custom Storage
`FileStorage` is an implementation of the `Storage` protocol. While you can customize the file location when instantiating it, you might want to provide a completely different way of storing your cached values (such as database, if you're managing large sets of data). You can do so by implementing the `Storage` protocol, which only requires you to provide functions to `read` and `write` the whole cached content.

You can find further information on the documentation of the `Storage` protocol

### Custom Queues
By default, all read and write operations happen on a specific queue that is generated for every instance of `PureCache`. In case your application is already managing multiple queues, you can provide a custom one when instantiating `PureCache`, using the `queue` parameter.

You can find further information on the documentation of the `PureCache` class.

### Syntax-sugar for Identifiable implementations
If the values you are storing in PureCache conform to `Identifiable`, you can use an extension method to save values that allows to not specify the key. The `id` property will be used automatically.

## Documentation
All the protocols and classes are fully documented.

You can find the [autogenerated documentation here](https://mrasterisco.github.io/PureCache/).

## Compatibility
PureCache is compatible with **iOS**, **macOS**, **Mac Catalyst**, **watchOS** and **tvOS**.

PureCache targets **iOS 9 or later**, **macOS 10.12 or later**, **Mac Catalyst 13.0 or later**, **watchOS 2 or later** and **tvOS 9 or later**.

PureCache has no external dependencies.

## Contributions
All contributions to expand the library are welcome. Fork the repo, make the changes you want, and open a Pull Request. When making changes, you should try to keep in mind the principles that guide this library: if you want to challenge one or more of them, be prepared to argue your case well, as I am trying to **keep PureCache really simple**.

If you make changes to the codebase, I am not enforcing a coding style, but I may ask you to make changes based on how the rest of the library is made.

## Status
This library is under **active development**. It is used in one app in Production.

Even if most of the APIs are pretty straightforward, **they may change in the future**; but you don't have to worry about that, because releases will follow [Semantic Versioning 2.0.0](https://semver.org/).

## License
PureCache is distributed under the MIT license. [See LICENSE](https://github.com/MrAsterisco/PureCache/blob/master/LICENSE) for details.
