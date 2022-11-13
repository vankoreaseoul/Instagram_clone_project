package com.test.instagram.repository;

import com.test.instagram.entity.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Integer> {
    List<Message> findAllBySenderIdAndRecipientId(int senderId, int recipientId);
    @Query(value = "SELECT recipient_id FROM messages WHERE sender_id = ?1", nativeQuery = true)
    List<Integer> findAllRecipientIdBySenderId(int senderId);
    @Query(value = "SELECT sender_id FROM messages WHERE recipient_id = ?1", nativeQuery = true)
    List<Integer> findAllSenderIdByRecipientId(int recipientId);
}
