package com.test.instagram.entity;

import lombok.Data;

@Data
public class MessageFake {
    private int id;
    private int senderId;
    private int recipientId;
    private String content;
    private String dayString;
    private int postId;
}
