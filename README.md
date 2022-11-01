## Instagram_clone_project
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
1. Sign up <br/>  
![](https://github.com/vankoreaseoul/Instagram_clone_project/blob/main/gifs/Simulator%20Screen%20Recording%20-%20iPhone%208%20-%202022-11-01%20at%2016.56.39.png)
<br/>  
You should satisfy all conditions, then the button will be enable. And you will get an email on which a specific number array is written. It's for knowing if the email is valid. After you can sign in. 
2. Edit profile <br/>  

