package com.test.instagram.entity;

import lombok.Data;

import javax.persistence.*;

@Data
public class UserFake {
    private Integer id;
    private String username;
    private String email;
    private String password;
    private Boolean emailValidated = false;
    private String name;
    private String bio;
    private String profileImage;
    private String dayString;
}
