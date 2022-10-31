package com.test.instagram.entity;

import com.test.instagram.converter.StringArrayToStringConverter;
import lombok.Data;

import javax.persistence.*;
import java.util.List;

@Entity
@Data
@SequenceGenerator(
        name = "FOLLOWS_SEQ_GEN",
        sequenceName = "FOLLOWS_SEQ",
        initialValue = 1,
        allocationSize = 1
)
@Table(name = "FOLLOWS")
public class Follow {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO,
            generator = "FOLLOWS_SEQ_GEN"
    )
    private Integer id;
    private Integer myUserId;
    @Convert(converter = StringArrayToStringConverter.class)
    private List<String> followToUserIdList;
}
