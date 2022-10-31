package com.test.instagram.entity;

import lombok.Data;

import java.util.List;

@Data
public class PostFake2 {
    private Integer id;
    private String username;
    private String content;
    private List<String> mentions; // usernameList
    private List<String> hashtags; // hashtagNameList
    private List<String> tagPeople; // usernameList
    private String location;
    private String dayString;
    private List<String> likes; // usernameList
}