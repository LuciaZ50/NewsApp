# NewsApp

This is the News App that I made usin SwiftUI and MVVM as a part of the recruitment process for Aras Digital Products.

**API-KEY**

The assignment was to make two tabs which fetch data from an API using an API key. Normally the API key shouldn't be
saved in the info.plist file or anywhere in the code where it is visible to others other than the person who uses. It should be passed around via .gitignore or 
something more secure but for the purposes of this assigment i put it in the Info.plist.

**Top Headlines**

This screen shows a list of articles fetched from the given API. The data for both screens is fetched when the screen appears and is passed to the viewMopdel for those
screens which is then passed to the view.
I implemented pagination on this screen. Each page retruns 30 items. The user can use the search bar to filter the fetched articles by using a keyword/keywords.

<img width="300" alt="Screenshot 2023-04-23 at 13 25 08" src="https://github.com/LuciaZ50/NewsApp/assets/93731591/e2a101a4-8b30-4756-b819-34122b8420db">

**Everythings**

This view shows a list of articles just like the previous screen. I also implemented pagination here and the user can filter the fetched data by a keyword/keywords.
In addition to that, this view has a sort button which sorts the fetched data by the newest date or oldest.

<img width="300" alt="Screenshot 2023-04-23 at 13 25 08" src="https://github.com/LuciaZ50/NewsApp/assets/93731591/49bb3a40-74b3-468b-b5e3-aa59acb14de8">

**Components**
-NewsCard -> In this view i use an asyncImage to show the image if an url is given in the response from the api. I also show the title and the author of the article. I added
a state var showDate to this view so i could show the dates of the articles when i use this component for the everythings(to show the sorting by the date).

-NewsFeedView -> I chose not to make unique views for the everythings and topHeadlines. Instead i handle both cases inside this view by using a switch statement on the selectedTab.

-HomeView -> Inside HomeView there is a tabView which consists of two NewsFeedView. Each of them has its own image and text as the navigation icon.

-HomeViewModel -> I chose to inject one viewModel into the tabs since there is not much functionality that i need to work with, in a larger app i would have made two separate views with two separate viewModels




