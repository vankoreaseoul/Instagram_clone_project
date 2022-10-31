package com.test.instagram.service;

import com.test.instagram.entity.Comment;
import com.test.instagram.entity.CommentFake;

import java.text.ParseException;
import java.util.List;

public interface CommentService {
    Integer insertComment(CommentFake commentFake) throws ParseException;
    List<CommentFake> readAllComments(int postId);
    CommentFake insertLike(int commentId, String username);
    CommentFake deleteLike(int commentId, String username);
}
