package com.test.instagram.entity;

import com.test.instagram.converter.StringArrayToStringConverter;
import lombok.Data;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Data
@SequenceGenerator(
        name = "POSTS_SEQ_GEN",
        sequenceName = "POSTS_SEQ",
        initialValue = 1,
        allocationSize = 1
)
@Table(name = "POSTS")
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO,
            generator = "POSTS_SEQ_GEN"
    )
    private Integer id;
    private String content;
    private Integer userId;
    @Convert(converter = StringArrayToStringConverter.class)
    private List<String> tagPeopleUserIdList;
    private String location;
    private Date day;
    @Convert(converter = StringArrayToStringConverter.class)
    private List<String> mentionUserIdList;
    @Convert(converter = StringArrayToStringConverter.class)
    private List<String> hashTagIdList;
    @Convert(converter = StringArrayToStringConverter.class)
    private List<String> likeUserIdList;
}
