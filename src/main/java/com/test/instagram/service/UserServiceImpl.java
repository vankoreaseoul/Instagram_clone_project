package com.test.instagram.service;

import com.test.instagram.entity.User;
import com.test.instagram.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UserRepository userRepository;

    @Override
    public Integer checkDuplicate(User user) {
        int result = -1; // Server or DB problem
        String username = user.getUsername();
        String email = user.getEmail();

        if (userRepository.findByUsername(username).isEmpty() && userRepository.findByEmail(email).isEmpty()) {
            result = 0; // No duplicate for username and email
        } else if (!userRepository.findByUsername(username).isEmpty()) {
            result =  1; // email duplicate
        } else if (!userRepository.findByEmail(email).isEmpty()) {
            result = 2; // username duplicate
        }
        return result;
    }

    @Override
    public Integer insert(User user) {
        try {
            userRepository.save(user);
            return 0; // insert done
        } catch (Error error) {
            return -1; // Server or DB problem
        }
    }

    @Override
    public Integer validateEmail(String email) {
        User user = userRepository.findByEmail(email).get(0);
        user.setEmailValidated(true);
        try {
            userRepository.save(user);
            return 0; // validate email
        } catch (Error error) {
            return -1; // Server or DB problem
        }
    }

    @Override
    public Integer signInUser(User user) {
        int result = -1; // Server or DB problem
        List<User> users = new ArrayList<>();

        if (user.getUsername() == null) {
            String email = user.getEmail();
            String password = user.getPassword();

            users = userRepository.findByEmailAndPassword(email, password);
        } else {
            String username = user.getUsername();
            String password = user.getPassword();

            users = userRepository.findByUsernameAndPassword(username, password);
        }

        if (users.isEmpty()) {
            result =  2; // wrong password
        } else {
            if (users.get(0).getEmailValidated()) {
                result = 0; // sign in
            } else {
                result = 1; // email not validated
            }
        }
        return result;
    }

    @Override
    public User readUserByUsername(String username) {
        User user = userRepository.findByUsername(username).get(0);
        if (user.getName() == null) {
            user.setName("");
        }
        if (user.getBio() == null) {
            user.setBio("");
        }
        if (user.getProfileImage() == null) {
            user.setProfileImage("");
        }
        return user;
    }

    @Override
    public User readUserByEmail(String email) {
        User user = userRepository.findByEmail(email).get(0);
        if (user.getName() == null) {
            user.setName("");
        }
        if (user.getBio() == null) {
            user.setBio("");
        }
        if (user.getProfileImage() == null) {
            user.setProfileImage("");
        }
        return user;
    }

    @Override
    public void insertImagePath(String email, String imagePath) {
        User user = userRepository.findByEmail(email).get(0);
        user.setProfileImage(imagePath);
        userRepository.save(user);
    }

    @Override
    public Integer updateUser(User user) {
        try {
            userRepository.save(user);
            return 0; // update done
        } catch (Error error) {
            return -1; // Server or DB problem
        }
    }

    @Override
    public void deleteImagePath(String email) {
        User user = userRepository.findByEmail(email).get(0);
        user.setProfileImage(null);
        userRepository.save(user);
    }


}
