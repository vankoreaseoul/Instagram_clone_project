package com.test.instagram.repository;

import com.test.instagram.entity.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Integer> {
    List<Post> findAllByUserId(Integer userId);

    @Query(value = "SELECT * FROM posts WHERE tag_people_user_id_list LIKE ?1", nativeQuery = true)
    List<Post> findAllTaggedByUserId(String userId);

    @Query(value = "SELECT * FROM posts WHERE hash_tag_id_list LIKE ?1", nativeQuery = true)
    List<Post> findAllByHashtagId(String hashtagId);
}