package com.test.instagram.service;

import com.test.instagram.entity.Post;
import com.test.instagram.entity.PostFake2;
import org.springframework.stereotype.Service;

import java.util.List;

public interface PostService {

    Integer insetNewPost(Post post);
    Integer deletePost(int postId);
    PostFake2 updatePost(Post post);
    List<PostFake2> readAllPostsByUserIdList(List<Integer> userIdList);
    List<PostFake2> readTaggedPostsByUserId(String userId);
    List<PostFake2> readHashtagPosts(String hashtagId);
    PostFake2 insertLike(int postId, String userId);
    PostFake2 deleteLike(int postId, String userId);
}
