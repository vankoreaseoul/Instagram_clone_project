package com.test.instagram.entity;

import lombok.Data;

import java.util.List;

@Data
public class PostFake {
    private Integer id;
    private String content;
    private Integer userId;
    private List<String> tagPeopleUserIdList;
    private String location;
    private String dayString;
    private List<String> mentionUserIdList;
    private List<String> hashTagIdList;
    private List<String> likes; // usernameList
}
