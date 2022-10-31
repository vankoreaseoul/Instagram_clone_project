package com.test.instagram.repository;

import com.test.instagram.entity.Follow;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface FollowRepository extends JpaRepository<Follow, Integer> {
    Follow findAllByMyUserId(Integer myUserId);
    @Query(value = "SELECT my_user_id FROM follows WHERE follow_to_user_id_list LIKE ?1", nativeQuery = true)
    List<Integer> findAllMyUserIdByFollowToUserIdList(String userId);
}