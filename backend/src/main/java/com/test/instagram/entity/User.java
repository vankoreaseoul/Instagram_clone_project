package com.test.instagram.entity;


import lombok.Data;

import javax.persistence.*;

@Entity
@Data
@SequenceGenerator(
        name = "USERS_SEQ_GEN",
        sequenceName = "USERS_SEQ",
        initialValue = 1,
        allocationSize = 1
)
@Table(name = "USERS")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO,
            generator = "USERS_SEQ_GEN"
    )
    private Integer id;
    private String username;
    private String email;
    private String password;
    private Boolean emailValidated = false;
    private String name;
    private String bio;
    private String profileImage;

}
