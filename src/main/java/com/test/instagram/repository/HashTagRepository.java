package com.test.instagram.repository;

import com.test.instagram.entity.HashTag;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HashTagRepository extends JpaRepository<HashTag, Integer> {
    List<HashTag> findAllByNameContaining(String name);
    HashTag findByName(String name);
}