## Instagram_clone_project
### Summary
- Project name: Instagram clone project
- Development objectives: Using swift, embody social network service
- Development period: 02 September 2022 ~ 13 November 2022 (about 10 weeks)
- Structure
![](https://user-images.githubusercontent.com/91598430/201608176-aa7a2505-a504-4e1d-936f-25417d0fd3bc.jpg)
&nbsp;&nbsp;- Front-end: Swift UIKit <br/>
&nbsp;&nbsp;- Back-end: Java Spring boot (including storage inside) <br/>
&nbsp;&nbsp;- Database: Oracle cloud <br/>
&nbsp;&nbsp;- Details: When clients request text information such as comments, server brings the information from remote database. On the other hand, in case that clients require image information like profile image, server brings from internal storage.

### Introduction
To setup this project, you need to follow this instruction. 
1. Connect to your own database and mail account.
- You can find back-end code in master branch. That's done by Spring boot. If you get used to the framework, you must understand what I meant. Otherwise, go to 'application.properties' file and repalce some settings with yours.
2. Make storage on your computer for Server.
- I didn't use Image host server. Instead I get Server to save images in local directory. Go to 'FileUploadServiceImpl' file in back-end code and check two variables named 'uploadProfileFolderPath' and 'uploadPostFolderPath'. That's the pathname for folders where images will be saved. You have to make your own folders and put the pathname on there.
3. Download Google Place API library on pods and get API key.
- In this project, I tried not to use third party libraries. But it looks way better to use this to search location. Here is a link. <br/>  https://cocoapods.org/pods/GooglePlaces  <br/> You need to make Google developer account to use their services. You can get API key after. Put API key in function called GMSPlacesClient.provideAPIKey("xxxx") in 'AppDelegate' file.
### Feature
- Swift, Cocoa Touch
- Xcode
- Auto Layout
- RESTful APIs to connect iOS application to back-end services
- MVC design pattern
- user authentication and user default
- Google Place API
- Image Cache
- JSON Decoding
- error handling
### Screenshot
#### 1. Sign up <br/>  
![](https://github.com/vankoreaseoul/Instagram_clone_project/blob/main/gifs/sign_up.png)
<br/>  
You should satisfy all conditions, then the button will be enable. And you will get an email on which a specific number array is written. It's for knowing if the email is valid. After you can sign in.
#### 2. Edit profile <br/>  
![](https://github.com/vankoreaseoul/Instagram_clone_project/blob/main/gifs/edit_profile.png)
<br/>  
You can edit your profile information on profile page. To change your profile image, you can take a photo by camera or choose in your library. And your username should be unique, any username can't be duplicated. 
#### 3. How to follow and unfollow <br/>
![](https://github.com/vankoreaseoul/Instagram_clone_project/blob/main/gifs/follow.png)
<br/> 
You can find friends in people tab on search page. You can see thier uploaded posts or tagged posts. If you want to get thier news, you can follow them. But if you want to unfollow them, you can do in your profile page.  
#### 4. Search with Hashtag <br/>
![](https://github.com/vankoreaseoul/Instagram_clone_project/blob/main/gifs/hashtag.png)
<br/> 
You can search certain themed posts by hashtag in search page. 
#### 5. How to post and etc...
It's hard to show every function here because of the restricted file upload size. Here is a link where you can see overall. <br/>
https://drive.google.com/file/d/1ESgeVUxJE7d4CrkDAyQ43TqtMhbhrEoF/view?usp=share_link
### Improvements
-
