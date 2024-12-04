# GSRouting

A light-weight Swift Package to improve the way different types of sheets and navigation destinations are presented, as well as
navigating between tabs.

> [!WARNING]  
> **Only suitable for iOS 16 and above**

## Table of Contents

-   [Installation](#installation)
-   [Usage](#usage)
-   [License](#license)

## Installation <a name="installation"></a>

### Xcode

To integrate GSRouting into your Xcode project using Swift Package Manager, follow these steps:

1. Open your Xcode project.
2. Navigate to "File" -> "Swift Packages" -> "Add Package Dependency..."
3. Paste the package URL `https://github.com/ryan-creator/GSRouting.git` and click "Next."
4. Choose the version rule according to your preference and click "Next."
5. Click "Finish."

Now you can import the package in your Swift files.

### Swift Package Manager (SPM)

If you want to use GSRouting in any other project that uses SPM, add the package as a dependency in Package.swift:

```swift
dependencies: [
    .package(
        name: "GSRouting",
        url: "https://github.com/ryan-creator/GSRouting.git",
        from: "1.0.0"
    ),
]
```

Next, add GSRouting as a dependency of your test target:

````swift
targets: [
  .target(
    name: "MyApp",
    dependencies: ["GSRouting", ...]
  ),
  .testTarget(...)
]

## Usage <a name="usage"></a>

### Step 1: Using `RoutableTabView`

RoutableTabView allows for programmatic navigation between tabs in the TabBar.

```swift
@main
struct AppView: App {

    var body: some Scene {
        WindowGroup {
            // Use `RoutableTabView` at the root of the app in the `@main` view.
            // Initialise it by passing in an array of routes, in the order you wish them to be displayed.
            RoutableTabView(tabs: [
              HomeTabRoute(),
              SettingsTabRoute()
            ])
        }
    }

}
````

## Usage <a name="usage"></a>

### Creating a `TabRoute`:

A TabRoute conforming object represents a single tab, providing functions to render the label displayed in the tab bar,
as well as the content displayed when the tab is selected.

**Note:** The `makeLabel` and `makeContent` functions are called when the state of the tab
changes, so it is possible to do things like changing the tab icon when selected/deselected etc.

```swift
struct HomeTabRoute: TabRoute {
let id: String = "home"

    func makeLabel(context: Context) -> some View {
        Label("Home", systemImage: context.isSelected ? "house.fill" : "house")
    }

    func makeContent(context: Context) -> some View {
        HomeView()
    }

}
```

### Step 2: Navigating to & presenting views.

All navigation operations can be performed by interacting with the injected instance of `AppNavigationRouter`. This can be done by a property marked with `@Router` in a SwiftUI view.

**Important:** It's important the parent view applies the `.routable()` modifier which injects the router and enables navigation functionality.

### Usage of `@Router`:

```swift
struct ContentView: View {

  @Router private var router

  var body: some View {
    VStack {
      Button("Go to next page") {
        router.push(PageView())
      }

      Button("Present a sheet") {
        router.presentSheet(SheetView())
      }
    }
  }
}
```

### Creating a `ViewRoute` for presentation/navigation:

A ViewRoute declaration allows for presenting and navigating to the view returned in it's `body` var.

ViewRoutes are passed into functions on the router like `push(_:), presentSheet(_:)`, etc.

```swift
struct MyViewRoute: ViewRoute {
  var body: some View {
    MyView()
  }
}
```

For convenience, an extension on `ViewRoute` can be made to declare the route as a property, so XCode will suggest our custom `ViewRoute` in the auto-complete window that appears when typing.

```swift
extension ViewRoute where Self == MyViewRoute {
  var myView: Self { .init() }
}
```

That allows for this syntax to work:

```swift
router.push(.myView)
```

## Advanced Usage

### Queueing & Priority

GSRouting supports queueing for sheets and full-screen covers, allowing multiple presentation requests to be handled sequentially based on their assigned priority. This ensures that the highest-priority views are displayed first.

#### Setting Priority

Each route has an associated RoutePriority value, which can be set when calling navigation functions such as push, presentSheet, or presentCover. By default, the priority is .normal.

Example of assigning a priority:

```swift
router.presentSheet(MySheetViewRoute(), priority: .high)
```

#### How the Queue Works

When a navigation request is made for a sheet or cover: 1. It is added to a queue managed by QueueManager. 2. The queue automatically processes the highest-priority request first. 3. Subsequent requests are handled only after the currently presented view is dismissed.

This mechanism ensures that multiple requests don’t cause overlapping presentations.

### Access Navigation Path

GSRouting provides access to the navigation path, enabling developers to track or modify the sequence of navigations.

#### Tracking the Path

The AppNavigationRouter updates a path of navigation steps (NavigationStep) whenever a navigation action occurs. This path is available via the environment:

```swift
@Environment(\.navigationPath) private var navigationPath
```

Example of using the navigation path:

```swift
struct MyView: View {

  @Environment(\.navigationPath) private var navigationPath

  @State private var sheetId = "unknown"

  var body: some View {
    Text("This is \(sheetId)")
      .onAppear {
        if case .sheet(let id) = navigationPath {
          sheetId = id
        }
      }
  }
}
```

### Logging Navigation Path

For debugging purposes, GSRouting can log the navigation path to the console whenever it changes. This feature is activated by passing the --log-navigation runtime argument when launching the app. The log provides insights into navigation behavior, which can be useful for tracking unexpected navigations or ensuring navigation steps are executed as expected.

#### Adding Runtime Arguments in Xcode Scheme

To enable logging in Xcode during development: 1. Open your project in Xcode. 2. In the toolbar, click the Scheme Selector (next to the Stop button) and choose Edit Scheme. 3. In the Edit Scheme dialog, select the Run action from the sidebar. 4. Navigate to the Arguments tab at the top of the dialog. 5. Under the Arguments Passed On Launch section, click the + button. 6. Add the argument --log-navigation and ensure the checkbox next to it is selected. 7. Click Close to save your changes.

Now, every time the app runs using this scheme, navigation path changes will be logged to the console.

With logging enabled, the console will display updates like the following when navigation steps are added or removed:

```
[Navigation Path Update] Current path: [NavigationStep.push(id: "home"), NavigationStep.sheet(id: "details")]
[Navigation Path Update] Current path: [NavigationStep.push(id: "home")]
```

This log output helps you verify the flow of navigation actions, ensuring they align with your expectations during development and debugging.

## License <a name="license"></a>

This library is released under the MIT license.
