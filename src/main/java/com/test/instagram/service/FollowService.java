package com.test.instagram.service;

import com.test.instagram.entity.Follow;
import com.test.instagram.entity.User;

import java.util.List;

public interface FollowService {
    Integer insertNewFollowing(Follow follow);
    List<String> readAllFollowings(Integer myUserId);
    Integer checkIfFollowing(Integer myUserId, String followToUserId);
    Integer numberOfFollowing(Integer myUserId);
    Integer numberOfFollowers(String myUserId);
    List<User> listOfFollowing(Integer myUserId);
    List<User> listOfFollowers(String myUserId);
    List<Integer> readAllFollowers(String myUserId);
    Integer unfollowToUser(int myUserId, String theOtherUserId);
    Integer removeFollower(String myUserId, int theOtherUserId);
}
