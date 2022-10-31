package com.test.instagram.controller;

import antlr.collections.impl.LList;
import com.test.instagram.entity.Comment;
import com.test.instagram.entity.CommentFake;
import com.test.instagram.service.CommentService;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.util.List;

@RestController
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    CommentService commentService;

    @PostMapping(value = "")
    private Integer insertComment(@RequestBody CommentFake commentFake) throws ParseException {
        return commentService.insertComment(commentFake);
    }

    @GetMapping(value = "")
    private List<CommentFake> readAllComments(@RequestParam String postIdString) {
        int postId = Integer.valueOf(postIdString);
        return commentService.readAllComments(postId);
    }

    @PostMapping(value = "/like")
    private CommentFake insertLike(@RequestBody JSONObject jsonObject) {
        int commentId = (Integer) jsonObject.get("commentId");
        String username = (String) jsonObject.get("username");

        return commentService.insertLike(commentId, username);
    }

    @DeleteMapping(value = "/like")
    private CommentFake deleteLike(@RequestBody JSONObject jsonObject) {
        int commentId = (Integer) jsonObject.get("commentId");
        String username = (String) jsonObject.get("username");

        return commentService.deleteLike(commentId, username);
    }
}
