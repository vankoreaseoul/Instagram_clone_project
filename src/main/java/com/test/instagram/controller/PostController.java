package com.test.instagram.controller;

import com.test.instagram.entity.*;
import com.test.instagram.service.PostService;
import com.test.instagram.service.UserService;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.persistence.criteria.CriteriaBuilder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/post")
public class PostController {

    @Autowired
    PostService postService;
    @Autowired
    UserService userService;

    @PostMapping(value = "")
    private Integer insertNewPost(@RequestBody PostFake postFake) throws ParseException {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = simpleDateFormat.parse(postFake.getDayString());
        Post post = new Post();
        post.setContent(postFake.getContent());
        post.setUserId(postFake.getUserId());
        post.setTagPeopleUserIdList(postFake.getTagPeopleUserIdList());
        post.setLocation(postFake.getLocation());
        post.setDay(date);
        post.setMentionUserIdList(postFake.getMentionUserIdList());
        post.setHashTagIdList(postFake.getHashTagIdList());

        List<String> usernames = postFake.getLikes();
        List<String> userIdList = new ArrayList<>();
        for (String username : usernames) {
            User user = userService.readUserByUsername(username);
            int userId = user.getId();
            userIdList.add(String.valueOf(userId));
        }

        post.setLikeUserIdList(userIdList);

        return postService.insetNewPost(post);
    }

    @GetMapping(value = "")
    private List<PostFake2> readAllPostsByUserIdList(@RequestParam String userIdList) {
        String replace = userIdList.replace("[","");
        String replace1 = replace.replace("]","");
        List<String> stringList = new ArrayList<String>(Arrays.asList(replace1.split(",")));
        List<Integer> idList = new ArrayList<>();
        for (String s : stringList) {
            idList.add(Integer.valueOf(s.trim()));
        }
        return postService.readAllPostsByUserIdList(idList);
    }

    @GetMapping(value = "/tag")
    private List<PostFake2> readTaggedPostsByUserId(@RequestParam String userId) {
        return postService.readTaggedPostsByUserId(userId);
    }

    @GetMapping(value = "/hashtag")
    private List<PostFake2> readHashtagPosts(@RequestParam String hashtagId) {
        return postService.readHashtagPosts(hashtagId);
    }

    @PostMapping(value = "/likes")
    private PostFake2 insertLike(@RequestBody JSONObject jsonObject) {
        int postId = (Integer) jsonObject.get("postId");
        int userId = (Integer) jsonObject.get("userId");
        String userIdString = String.valueOf(userId);

        return postService.insertLike(postId, userIdString);
    }

    @DeleteMapping(value = "/likes")
    private PostFake2 deleteLike(@RequestBody JSONObject jsonObject) {
        int postId = (Integer) jsonObject.get("postId");
        int userId = (Integer) jsonObject.get("userId");
        String userIdString = String.valueOf(userId);

        return postService.deleteLike(postId, userIdString);
    }

}
