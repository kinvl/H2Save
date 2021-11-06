# Changelog
All significant changes to this project will be listed in this file.

***

## 2.0.0 - 2021-11-04
The whole app has been rewritten from scratch and no longer uses storyboards. That's why I mark it as 2.0 instead of 1.1.0.
- two major memory leaks, the first was ML Sound Recognition class leaking a lot of memory, the second was Settings View Controller not being properly dismissed
- the unfortunate CountdownLabel has been fixed as much as I could. It is still leaking memory but very small amount and I can't do anything about it. Water statistics are now working as intended tho.
- changed "About" view controller to WKWebView instead of some UILabels
- adjusted some UI colors
- general code clean up

## 1.0.0 - 2021-09-17
- Initial release
