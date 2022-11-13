package com.test.instagram.controller;

import com.test.instagram.entity.MessageFake;
import com.test.instagram.entity.UserFake;
import com.test.instagram.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/message")
public class MessageController {
    @Autowired
    MessageService messageService;

    @PostMapping(value = "")
    private Integer insertMessage(@RequestBody MessageFake messageFake) throws ParseException {
        return messageService.insertMessage(messageFake);
    }

    @GetMapping(value = "")
    private List<MessageFake> readMessages(@RequestParam String senderIdString, @RequestParam String recipientIdString) {
        int senderId = Integer.valueOf(senderIdString);
        int recipientId = Integer.valueOf(recipientIdString);
        return  messageService.readMessages(senderId, recipientId);
    }

    @GetMapping(value = "/user_list")
    private List<UserFake> readAllMessageCounterparts(@RequestParam String myUserIdString) {
        int myUserId = Integer.valueOf(myUserIdString);
        return  messageService.readAllMessageCounterparts(myUserId);
    }

    @GetMapping(value = "/last")
    private List<MessageFake> readLastMessage(@RequestParam String senderIdString, @RequestParam String recipientIdListString) throws ParseException {
        int senderId = Integer.valueOf(senderIdString);
        recipientIdListString = recipientIdListString.substring(1, recipientIdListString.length() - 1);

        List<Integer> userIdList = new ArrayList<>();
        if (!recipientIdListString.equals("")) {
            String[] array = recipientIdListString.split(", ");
            for (String s : array) {
                userIdList.add(Integer.valueOf(s));
            }
        }

        return  messageService.readLastMessage(senderId, userIdList);
    }

}
