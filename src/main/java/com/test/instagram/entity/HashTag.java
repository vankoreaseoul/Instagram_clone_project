package com.test.instagram.entity;

import lombok.Data;

import javax.persistence.*;

@Entity
@Data
@SequenceGenerator(
        name = "HASHTAGS_SEQ_GEN",
        sequenceName = "HASHTAGS_SEQ",
        initialValue = 1,
        allocationSize = 1
)
@Table(name = "HASHTAGS")
public class HashTag {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO,
            generator = "HASHTAGS_SEQ_GEN"
    )
    private Integer id;
    @Column(unique = true)
    private String name;
}