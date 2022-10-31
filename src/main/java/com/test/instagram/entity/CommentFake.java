package com.test.instagram.entity;

import lombok.Data;

import java.util.List;

@Data
public class CommentFake {
    private Integer id;
    private String content;
    private String username;
    private List<String> likes; // usernameList
    private List<String> mentions; // usernameList
    private List<String> hashtags; // hashtagNameList
    private String dayString;
    private Integer postId;
}