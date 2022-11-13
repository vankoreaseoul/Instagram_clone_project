package com.test.instagram.service;

import com.test.instagram.entity.Message;
import com.test.instagram.entity.MessageFake;
import com.test.instagram.entity.UserFake;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface MessageService {
    Integer insertMessage(MessageFake messageFake) throws ParseException;
    List<MessageFake> readMessages(int senderId, int recipientId);
    List<UserFake> readAllMessageCounterparts(int myUserId);
    List<MessageFake> readLastMessage(int senderId, List<Integer> recipientIdList) throws ParseException;
}
