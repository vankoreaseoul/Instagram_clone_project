package com.test.instagram.controller;

import com.test.instagram.entity.User;
import com.test.instagram.entity.UserFake;
import com.test.instagram.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping(value="/check")
    private Integer checkUserDuplicate(@RequestParam String username, @RequestParam String email) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);

        int result = userService.checkDuplicate(user);
        return result;
    }

    @GetMapping(value = "")
    private UserFake readUserByUsername(@RequestParam String username, @RequestParam String email) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (email.isEmpty()) {
            User user = userService.readUserByUsername(username);
            UserFake userFake = new UserFake();
            userFake.setProfileImage(user.getProfileImage());
            userFake.setUsername(user.getUsername());
            userFake.setName(user.getName());
            userFake.setBio(user.getBio());
            userFake.setEmail(user.getEmail());
            userFake.setEmailValidated(user.getEmailValidated());
            userFake.setDayString(formatter.format(user.getDay()));
            userFake.setId(user.getId());
            userFake.setPassword("");
            return userFake;
        } else {
            User user = userService.readUserByEmail(email);
            UserFake userFake = new UserFake();
            userFake.setProfileImage(user.getProfileImage());
            userFake.setUsername(user.getUsername());
            userFake.setName(user.getName());
            userFake.setBio(user.getBio());
            userFake.setEmail(user.getEmail());
            userFake.setEmailValidated(user.getEmailValidated());
            userFake.setDayString(formatter.format(user.getDay()));
            userFake.setId(user.getId());
            userFake.setPassword("");
            return userFake;
        }
    }

    @PostMapping(value = "")
    private Integer insertNewUser(@RequestBody UserFake userFake) throws ParseException {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = simpleDateFormat.parse(userFake.getDayString());
        User user = new User();
        user.setUsername(userFake.getUsername());
        user.setEmail(userFake.getEmail());
        user.setPassword(userFake.getPassword());
        user.setEmailValidated(userFake.getEmailValidated());
        user.setDay(date);
        int result = userService.insert(user);
        return  result;
    }

    @PostMapping(value = "/signin")
    private Integer signInUser(@RequestBody User user) {
        int result = userService.signInUser(user);
        return result;
    }

    @PutMapping(value = "")
    private Integer updateUser(@RequestBody UserFake userFake) throws ParseException {
        String newName = userFake.getName();
        String newUsername = userFake.getUsername();
        String newBio = userFake.getBio();

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = simpleDateFormat.parse(userFake.getDayString());

        User userFroDb = userService.readUserByEmail(userFake.getEmail());
        userFroDb.setName(newName);
        userFroDb.setUsername(newUsername);
        userFroDb.setBio(newBio);
        userFroDb.setDay(date);

        int result = userService.updateUser(userFroDb);
        return  result;
    }

    @GetMapping(value="/search")
    private List<UserFake> searchUsers(@RequestParam String username) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        List<User> users = userService.searchUsers(username);
        List<UserFake> userFakes = new ArrayList<>();
        for (User user : users) {
            UserFake userFake = new UserFake();
            userFake.setProfileImage(user.getProfileImage());
            userFake.setUsername(user.getUsername());
            userFake.setName(user.getName());
            userFake.setBio(user.getBio());
            userFake.setEmail(user.getEmail());
            userFake.setEmailValidated(user.getEmailValidated());
            userFake.setDayString(formatter.format(user.getDay()));
            userFake.setId(user.getId());
            userFake.setPassword("");
            userFakes.add(userFake);
        }
        return userFakes;
    }

}
