package com.test.instagram.service;

import com.test.instagram.entity.HashTag;
import com.test.instagram.repository.HashTagRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HashTagServiceImpl implements HashTagService {
    @Autowired
    private HashTagRepository hashTagRepository;
    @Override
    public List<HashTag> searchHashTags(String name) {
        return hashTagRepository.findAllByNameContaining(name);
    }

    @Override
    public Integer insertHashTag(String name) {
        HashTag hashTag = new HashTag();
        hashTag.setName(name);

        int result = 0;
        try {
            hashTagRepository.save(hashTag);
        } catch (DataIntegrityViolationException error) {
            System.out.println("The hashtag name already exits!");
            result = 1;
        } finally {
            return result;
        }
    }

    @Override
    public HashTag readHashTag(String name) {
        return hashTagRepository.findByName(name);
    }
}
