package com.test.instagram.service;

import com.test.instagram.entity.HashTag;

import java.util.List;

public interface HashTagService {
    List<HashTag> searchHashTags(String name);
    Integer insertHashTag(String name);
    HashTag readHashTag(String name);
}
