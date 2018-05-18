# unsplash-ios

## Description:

Combining FRP (RXSwift) and IP. Using delegate pattern where it made more sense than reactive. Separate navigation logic with help of Coordinators for dynamic scaling. Writing layout in code because of personal preference. Using Alamofire for networking and Hero for transitions. 

## Known issues:

- Not checking for Reachability
- CollectionViewLayout bug with content height (cache)
- SearchBar not resigning as first responder when vc dissappear (navigation controller)
- No paging
- No localization
- Not retrying requests
