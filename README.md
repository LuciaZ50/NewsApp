# NewsApp

This is the News App that I made as a part of the recruitment process for Aras Digital Products.

**API-KEY**
The assignment was to make two tabs which fetch data from an API using an API key. Normally the API key shouldn't be
saved in the info.plist file or anywhere in the code where it is visible to others other than the person who uses. It should be passed around via .gitignore or 
something more secure but for the purposes of this assigment i put it in the Info.plist.

**Top Headlines**

This screen shows a list of articles fetched from the given API. The data for both screens is fetched when the screen appears and is passed to the viewMopdel for those
screens which is then passed to the view.
I implemented pagination on this screen. Each page retruns 30 items. The user can use the search bar to filter the fetched articles by using a keyword/keywords.

<img src="![WhatsApp Image 2023-11-01 at 11 48 22](https://github.com/LuciaZ50/NewsApp/assets/93731591/0414e876-ac7c-40bd-9fba-9523ecf22194)" width="400" height="300">

**Everythings**

This view shows a list of articles just like the previous screen. I also implemented pagination here and the user can filter the fetched data by a keyword/keywords.
In addition to that, this view has a sort button which sorts the fetched data by the newest date or oldest.

<img src="![WhatsApp Image 2023-11-01 at 11 48 22](https://github.com/LuciaZ50/NewsApp/assets/93731591/c32fc22f-b5e4-4c21-9b9c-b1d3880303fd)" width="400" height="300">

**Components**
-NewsCard -> In this view i use an asyncImage to show the image if an url is given in the response from the api. I also show the title and the author of the article. I added
a state var showDate to this view so i could show the dates of the articles when i use this component for the everythings(to show the sorting by the date).
-NewsFeedView -> I chose not to make unique views for the everythings and topHeadlines. Instead i handle both cases inside this view by using a switch statement on the selectedTab.
-HomeView -> Inside HomeView there is a tabView which consists of two NewsFeedView. Each of them has its own image and text as the navigation icon.



