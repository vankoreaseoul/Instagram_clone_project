package com.test.instagram.entity;

import com.test.instagram.converter.StringArrayToStringConverter;
import lombok.Data;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Data
@SequenceGenerator(
        name = "COMMENTS_SEQ_GEN",
        sequenceName = "COMMENTS_SEQ",
        initialValue = 1,
        allocationSize = 1
)
@Table(name = "COMMENTS")
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO,
            generator = "COMMENTS_SEQ_GEN"
    )
    private Integer id;
    private String content;
    private Integer userId;
    @Convert(converter = StringArrayToStringConverter.class)
    private List<String> likes; // userIdList
    @Convert(converter = StringArrayToStringConverter.class)
    private List<String> mentions; // userIdList
    @Convert(converter = StringArrayToStringConverter.class)
    private List<String> hashtags; // hashtagIdList
    private Date day;
    private Integer postId;
}
