package com.test.instagram.service;

import com.test.instagram.entity.*;
import com.test.instagram.repository.MessageRepository;
import com.test.instagram.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class MessageServiceImpl implements MessageService{

    @Autowired
    MessageRepository messageRepository;
    @Autowired
    UserRepository userRepository;

    @Override
    public Integer insertMessage(MessageFake messageFake) throws ParseException {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = simpleDateFormat.parse(messageFake.getDayString());
        Message message = new Message();
        message.setContent(messageFake.getContent());
        message.setSenderId(messageFake.getSenderId());
        message.setRecipientId(messageFake.getRecipientId());
        message.setPostId(messageFake.getPostId());
        message.setDay(date);

        try {
            System.out.println(message);
            messageRepository.save(message);
            return 0;
        } catch (IllegalArgumentException e) {
            return 1;
        }
    }

    @Override
    public List<MessageFake> readMessages(int senderId, int recipientId) {
        List<Message> messageList1 = messageRepository.findAllBySenderIdAndRecipientId(senderId, recipientId);
        List<Message> messageList2 = messageRepository.findAllBySenderIdAndRecipientId(recipientId, senderId);
        List<Message> messageList = new ArrayList<>();
        messageList.addAll(messageList1);
        messageList.addAll(messageList2);
        Collections.sort(messageList, new MessageTimeComparator());

        List<MessageFake> messages = new ArrayList<>();
        for (Message message : messageList) {
            MessageFake messageFake = new MessageFake();
            messageFake.setId(message.getId());
            messageFake.setSenderId(message.getSenderId());
            messageFake.setRecipientId(message.getRecipientId());
            messageFake.setContent(message.getContent());
            messageFake.setPostId(message.getPostId());

            SimpleDateFormat formatter = new SimpleDateFormat("dd-MMMM-yyyy HH:mm:ss");
            String strDate = formatter.format(message.getDay());
            messageFake.setDayString(strDate);

            messages.add(messageFake);
        }
        return messages;
    }

    @Override
    public List<UserFake> readAllMessageCounterparts(int myUserId) {
        List<Integer> userIdList1 = messageRepository.findAllRecipientIdBySenderId(myUserId);
        List<Integer> userIdList2 = messageRepository.findAllSenderIdByRecipientId(myUserId);
        List<Integer> userIdList = new ArrayList<>();
        userIdList.addAll(userIdList1);
        userIdList.addAll(userIdList2);
        Set<Integer> set = new HashSet<>();
        set.addAll(userIdList);
        userIdList.clear();
        userIdList.addAll(set);

        List<UserFake> users = new ArrayList<>();
        for (int userId : userIdList) {
            User user = userRepository.findById(userId).get();
            UserFake newUser = new UserFake();
            newUser.setId(user.getId());
            newUser.setUsername(user.getUsername());
            newUser.setDayString("");
            newUser.setBio("");
            newUser.setEmail("");
            newUser.setName("");
            newUser.setPassword("");
            newUser.setProfileImage("");
            newUser.setEmailValidated(true);
            users.add(newUser);
        }
        return users;
    }

    @Override
    public List<MessageFake> readLastMessage(int senderId, List<Integer> recipientIdList) throws ParseException {
        List<MessageFake> lastMessages = new ArrayList<>();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MMMM-yyyy HH:mm:ss");

        for (int userId : recipientIdList) {
            List<MessageFake> messages = readMessages(senderId, userId);
            if (messages.size() != 0) {
                MessageFake lastWord = messages.get(messages.size() - 1);
                lastMessages.add(lastWord);
            }
        }

        List<Message> messages = new ArrayList<>();
        if (lastMessages.size() != 0) {
            for (MessageFake messageFake : lastMessages) {
                Message message = new Message();
                Date date = simpleDateFormat.parse(messageFake.getDayString());
                message.setDay(date);
                message.setId(messageFake.getId());
                message.setContent(messageFake.getContent());
                message.setRecipientId(messageFake.getRecipientId());
                message.setSenderId(messageFake.getSenderId());
                messages.add(message);
            }
        }

        lastMessages.clear();
        if (messages.size() != 0) {
            Collections.sort(messages, new MessageTimeComparator().reversed());

            for (Message message : messages) {
                MessageFake messageFake = new MessageFake();
                messageFake.setId(message.getId());
                messageFake.setSenderId(message.getSenderId());
                messageFake.setRecipientId(message.getRecipientId());
                messageFake.setContent(message.getContent());
                String strDate = simpleDateFormat.format(message.getDay());
                messageFake.setDayString(strDate);
                lastMessages.add(messageFake);
            }
        }
        return lastMessages;
    }
}

class MessageTimeComparator implements Comparator<Message> {
    @Override
    public int compare(Message o1, Message o2) {
        return o1.getDay().compareTo(o2.getDay());
    }
}
