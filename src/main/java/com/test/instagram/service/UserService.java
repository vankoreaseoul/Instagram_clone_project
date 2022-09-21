package com.test.instagram.service;

import com.test.instagram.entity.User;

public interface UserService {

    // username and email should be unique.
    Integer checkDuplicate(User user);
    Integer insert(User user);
    Integer validateEmail(String email);
    Integer signInUser(User user);
    User readUserByUsername(String username);
    User readUserByEmail(String email);
    void insertImagePath(String email, String imagePath);
    Integer updateUser(User user);
    void deleteImagePath(String email);
}
