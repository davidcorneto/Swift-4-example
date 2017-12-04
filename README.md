# Swift-4-example

Task Description:
Create an App that accesses the public SpaseX-API to retrieve a list of Launchpads.
List of launchpads should be cached in the database and updated after every App launch in background.

API
GET https://api.spacexdata.com/v1/launchpads

UI Description
Screen 1:
1) Portrait orientation
2) Connect to the SpaceX-API to retrieve a list of Launchpads
3) Table view cells display fullName and status of Launchpad
4) Open detail of Launchpad on selection of cell

Screen 2:
1) fullName in title of view controller
2) name and region information from Location model
3) details of Launchpad in text box

Requirements:
1) Must use latest Xcode and Swift versions
2) iOS 10+
3) Need to be able to go back between screens

Will be an advantage:
1) Project architecture that allows easy app functionality expansion (adding new requests, new screens)
2) CocoaPods as dependency management system
3) Realm
4) PromiseKit or RxSwift
5) Code style, syntax sugar and best-practices
