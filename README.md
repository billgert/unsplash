# unsplash-ios

## Description

Combining FRP (RXSwift) and IP. Using delegate pattern where it made more sense than reactive. Separate navigation logic with help of Coordinators for dynamic scaling. Writing layout in code because of personal preference. Using Alamofire for networking and Hero for transitions. 

## CollectionViewLayout

Current layout is easy to accomplish with UICollectionViewFlowLayout so why create a custom one? The reason was to always have the same widths, but dynamic heghts depending on photo height. I skipped this part (making the view controller delegate of the layout and returning the height) because I missed the parameter in the Photo object and therefore kept it because it was already done. 

## Known issues

- Not checking for Reachability
- CollectionViewLayout bug with content height (cache)
- SearchBar not resigning as first responder when vc dissappear (navigation controller)
- No paging
- No localization
- Not retrying requests
- Padding issue for iPhoneX on bottom (probably SafeArea-fix)
