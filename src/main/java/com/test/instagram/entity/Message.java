package com.test.instagram.entity;

import com.test.instagram.converter.StringArrayToStringConverter;
import lombok.Data;

import javax.persistence.*;
import java.util.Date;

@Entity
@Data
@SequenceGenerator(
        name = "MESSAGES_SEQ_GEN",
        sequenceName = "MESSAGES_SEQ",
        initialValue = 1,
        allocationSize = 1
)
@Table(name = "MESSAGES")
public class Message {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO,
            generator = "MESSAGES_SEQ_GEN"
    )
    private int id;
    private int senderId;
    private int recipientId;
    private String content;
    private Date day;
    private int postId;
}
