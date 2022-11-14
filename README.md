## Instagram_clone_project
### Summary
- Project name: &nbsp;  Instagram clone project
- Development objectives: &nbsp;  Using swift, embody social network service
- Development period: &nbsp;  02 September 2022 ~ 13 November 2022 (Around 10 weeks)
- Developer / Role: &nbsp;  Seo Heawon / Full-stack
- Main functions
  - Sign in / up
  - Edit profile
  - Post upload / update / delete / share
  - Mention / Hashtag / Tag
  - Follow / UnFollow
  - Message
  - Like
  - Comment upload / delete
- Structure
  - Front-end: &nbsp;  Swift UIKit <br/>
  - Back-end: &nbsp;  Java Spring boot (including storage inside) <br/>
  - Database: &nbsp;  Oracle cloud <br/>
  - Details: &nbsp;  When clients request text information such as comments, server brings the information from remote database. On the other hand, in case that clients require image information like profile image, server brings from internal storage. <br /><br />
![](https://user-images.githubusercontent.com/91598430/201608176-aa7a2505-a504-4e1d-936f-25417d0fd3bc.jpg)

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
- User authentication and user default
- Google Place API
- Image Cache
- JSON Decoding
- Error handling

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
#### 5. How to post and etc..
It's hard to show every function here because of the restricted file upload size. Here is a link where you can see overall. <br/>
https://drive.google.com/file/d/1ESgeVUxJE7d4CrkDAyQ43TqtMhbhrEoF/view?usp=share_link

### Improvements
1. Needs to apply MVVM design pattern.
- These days, more and more mobile apps are accepting MVVM pattern. MVC pattern I applied for this project, which has long history, used for long time and still one of stable good patterns, but it puts a lot of burdens on controller. So I need to learn and apply MVVM pattern. 
2. Needs to learn more stable ways to handle image.
- As you can see on video, even though image is uploaded well, sometimes a few image views are blank. I made code which downloads image from server and saves in its own image cache. The way is used commonly to deal with image based on my research, but I can see it's not enough and doesn't work perfectly. I don't know if I'm wrong with this way or there are better ways or perhaps it might be a problem on server. I need to research.
3. Needs to get more used to Auto Layout.
- The concept of Auto Layout is really important in UIKit. So I tried to use it rather than assign frame directly, but often I faced errors or warnings to say I broke Auto Layout and sometimes I really couldn't find which part was wrong. In this project, some layouts are not stable. I need to get more used to Auto Layout.    
