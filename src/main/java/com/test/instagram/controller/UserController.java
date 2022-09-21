package com.test.instagram.controller;

import com.test.instagram.entity.User;
import com.test.instagram.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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
    private User readUserByUsername(@RequestParam String username, @RequestParam String email) {
        if (email.isEmpty()) {
            User user = userService.readUserByUsername(username);
            user.setPassword("");
            return user;
        } else {
            User user = userService.readUserByEmail(email);
            user.setPassword("");
            return  user;
        }
    }

    @PostMapping(value = "")
    private Integer insertNewUser(@RequestBody User user) {
        int result = userService.insert(user);
        return  result;
    }

    @PostMapping(value = "/signin")
    private Integer signInUser(@RequestBody User user) {
        int result = userService.signInUser(user);
        return result;
    }

    @PutMapping(value = "")
    private Integer updateUser(@RequestBody User user) {
        String newName = user.getName();
        String newUsername = user.getUsername();
        String newBio = user.getBio();

        User userFroDb = userService.readUserByEmail(user.getEmail());
        userFroDb.setName(newName);
        userFroDb.setUsername(newUsername);
        userFroDb.setBio(newBio);

        int result = userService.updateUser(userFroDb);
        return  result;
    }


}
