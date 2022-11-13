package com.test.instagram.controller;

import com.test.instagram.entity.*;
import com.test.instagram.service.FollowService;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/following")
public class FollowController {

    @Autowired
    FollowService followService;

    @PostMapping(value = "")
    private Integer insertNewFollowing(@RequestBody Follow follow) throws ParseException {
        return followService.insertNewFollowing(follow);
    }

    @GetMapping(value = "/check")
    private Integer checkIfFollowing(@RequestParam String myUserId, @RequestParam String followToUserId) throws ParseException {
       return followService.checkIfFollowing(Integer.valueOf(myUserId), followToUserId);
    }

    @GetMapping(value = "/following_number")
    private Integer numberOfFollowing(@RequestParam String myUserId) throws ParseException {
        return followService.numberOfFollowing(Integer.valueOf(myUserId));
    }

    @GetMapping(value = "/followers_number")
    private Integer numberOfFollowers(@RequestParam String myUserId) throws ParseException {
        return followService.numberOfFollowers(myUserId);
    }

    @GetMapping(value = "/following_list")
    private List<UserFake> listOfFollowing(@RequestParam String myUserId) throws ParseException {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        List<UserFake> userFakes = new ArrayList<>();
        List<User> users = followService.listOfFollowing(Integer.valueOf(myUserId));
        for (User user: users) {
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

    @GetMapping(value = "/followers_list")
    private List<UserFake> listOfFollowers(@RequestParam String myUserId) throws ParseException {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        List<UserFake> userFakes = new ArrayList<>();
        List<User> users = followService.listOfFollowers(myUserId);

        for (User user: users) {
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

    @GetMapping(value = "/follows")
    private List<UserFake> readAllFollowsAndFollowers(@RequestParam String myUserId) throws ParseException {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        List<UserFake> userFakes = new ArrayList<>();
        List<User> users = followService.readAllFollowsAndFollowers(myUserId);

        for (User user: users) {
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

    @DeleteMapping(value = "")
    private Integer unfollowToUser(@RequestBody JSONObject jsonObject) throws ParseException {
        int myUserId = (Integer) jsonObject.get("myUserId");
        int theOtherUserId = (Integer) jsonObject.get("theOtherUserId");
        return followService.unfollowToUser(myUserId, String.valueOf(theOtherUserId));
    }

    @DeleteMapping(value = "/follower")
    private Integer removeFollower(@RequestBody JSONObject jsonObject) throws ParseException {
        int myUserId = (Integer) jsonObject.get("myUserId");
        int theOtherUserId = (Integer) jsonObject.get("theOtherUserId");
        return followService.removeFollower(String.valueOf(myUserId), theOtherUserId);
    }


}