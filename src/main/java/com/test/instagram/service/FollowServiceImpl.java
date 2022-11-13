package com.test.instagram.service;

import com.test.instagram.entity.Follow;
import com.test.instagram.entity.User;
import com.test.instagram.repository.FollowRepository;
import com.test.instagram.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.awt.*;
import java.util.*;
import java.util.List;

@Service
public class FollowServiceImpl implements  FollowService {

    @Autowired
    FollowRepository followRepository;
    @Autowired
    UserRepository userRepository;

    @Override
    public Integer insertNewFollowing(Follow follow) {
        int result = 0;
        List<String> followings = readAllFollowings(follow.getMyUserId());
        if (followings == null) {
            followRepository.save(follow);
            result = 1;
        } else {
            Integer id = (followRepository.findAllByMyUserId(follow.getMyUserId())).getId();
            follow.setId(id);

            List<String> newFollowing = follow.getFollowToUserIdList();
            List<String> list = new ArrayList<>();
            list.addAll(followings);
            list.add(newFollowing.get(0));
            Set<String> set = new HashSet<>();
            set.addAll(list);
            list.clear();
            list.addAll(set);
            follow.setFollowToUserIdList(list);
            followRepository.save(follow);
            result = 1;
        }
        return result;
    }

    @Override
    public List<String> readAllFollowings(Integer myUserId) {
        Follow follow = followRepository.findAllByMyUserId(myUserId);
        if (follow == null) {
            return null;
        } else {
            return (followRepository.findAllByMyUserId(myUserId)).getFollowToUserIdList();
        }
    }

    @Override
    public Integer checkIfFollowing(Integer myUserId, String followToUserId) {
        int result = 0;
        List<String> followings = readAllFollowings(myUserId);
        if (followings == null) {
            result = 1;
        } else {
            if (followings.contains(followToUserId)) {
                result = 0;
            } else {
                result = 1;
            }
        }
        return result;
    }

    @Override
    public Integer numberOfFollowing(Integer myUserId) {
        List<String> followings = readAllFollowings(myUserId);
        if (followings == null || followings.isEmpty()) {
            return 0;
        } else {
            return followings.size();
        }
    }

    @Override
    public Integer numberOfFollowers(String myUserId) {
        return readAllFollowers(myUserId).size();
    }

    @Override
    public List<User> listOfFollowing(Integer myUserId) {
        List<User> followingList = new ArrayList<>();
        List<String> followings = readAllFollowings(myUserId);
        if (followings != null && !followings.isEmpty()) {
            for (String userIdString : followings) {
                int userId = Integer.valueOf(userIdString);
                Optional<User> userOptional = userRepository.findById(userId);
                if (userOptional.isPresent()) {
                    User user = userOptional.get();
                    user.setPassword("");
                    user.setBio("");
                    user.setEmail("");
                    user.setName("");
                    if (user.getProfileImage() == null || user.getProfileImage().isEmpty()) {
                        user.setProfileImage("");
                    }
                    followingList.add(user);
                }
            }
        }
        return followingList;
    }

    @Override
    public List<User> listOfFollowers(String myUserId) {
        List<User> followersList = new ArrayList<>();
        List<Integer> followers = readAllFollowers(myUserId);
        if (followers != null && !followers.isEmpty()) {
            for (int userId : followers) {
                Optional<User> userOptional = userRepository.findById(userId);
                if (userOptional.isPresent()) {
                    User user = userOptional.get();
                    user.setPassword("");
                    user.setBio("");
                    user.setEmail("");
                    user.setName("");
                    if (user.getProfileImage() == null || user.getProfileImage().isEmpty()) {
                        user.setProfileImage("");
                    }
                    followersList.add(user);
                }
            }
        }
        return followersList;

    }

    @Override
    public List<User> readAllFollowsAndFollowers(String myUserId) {
        List<User> users1 = listOfFollowers(myUserId);
        List<User> users2 = listOfFollowing(Integer.valueOf(myUserId));
        List<User> users = new ArrayList<>();
        users.addAll(users1);
        users.addAll(users2);
        Set<User> set = new HashSet<>();
        set.addAll(users);
        users.clear();
        users.addAll(set);
        return users;
    }

    @Override
    public List<Integer> readAllFollowers(String myUserId) {
        List<Integer> userIdList = new ArrayList<>();
        String q1 = myUserId;
        String q2 = "%," + myUserId;
        String q3 =  myUserId + ",%";
        String q4 = "%," + myUserId + ",%";
        List<Integer> myUserIdList1 = followRepository.findAllMyUserIdByFollowToUserIdList(q1);
        if (myUserIdList1 != null && !myUserIdList1.isEmpty()) {
            for (Integer userId : myUserIdList1) {
                userIdList.add(userId);
            }
        }
        List<Integer> myUserIdList2 = followRepository.findAllMyUserIdByFollowToUserIdList(q2);
        if (myUserIdList2 != null && !myUserIdList2.isEmpty()) {
            for (Integer userId : myUserIdList2) {
                userIdList.add(userId);
            }
        }
        List<Integer> myUserIdList3 = followRepository.findAllMyUserIdByFollowToUserIdList(q3);
        if (myUserIdList3 != null && !myUserIdList3.isEmpty()) {
            for (Integer userId : myUserIdList3) {
                userIdList.add(userId);
            }
        }
        List<Integer> myUserIdList4 = followRepository.findAllMyUserIdByFollowToUserIdList(q4);
        if (myUserIdList4 != null && !myUserIdList4.isEmpty()) {
            for (Integer userId : myUserIdList4) {
                userIdList.add(userId);
            }
        }
        return userIdList;
    }

    @Override
    public Integer unfollowToUser(int myUserId, String theOtherUserId) {
        List<String> followings = readAllFollowings(myUserId);
        List<String> list = new ArrayList<>();
        list.addAll(followings);
        if (list.remove(theOtherUserId)) {
            Follow follow = new Follow();
            follow.setMyUserId(myUserId);
            follow.setFollowToUserIdList(list);
            Integer id = (followRepository.findAllByMyUserId(myUserId)).getId();
            follow.setId(id);
            System.out.println(follow);
            followRepository.save(follow);
            return 1;
        } else {
            return 0;
        }
    }

    @Override
    public Integer removeFollower(String myUserId, int theOtherUserId) {
        return unfollowToUser(theOtherUserId, myUserId);
    }


}
