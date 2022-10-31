package com.test.instagram.service;

import com.test.instagram.entity.Comment;
import com.test.instagram.entity.CommentFake;
import com.test.instagram.repository.CommentRepository;
import com.test.instagram.repository.HashTagRepository;
import com.test.instagram.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    CommentRepository commentRepository;
    @Autowired
    UserService userService;
    @Autowired
    UserRepository userRepository;
    @Autowired
    HashTagRepository hashTagRepository;

    @Override
    public Integer insertComment(CommentFake commentFake) throws ParseException {
        Comment comment = new Comment();
        comment.setContent(commentFake.getContent());
        comment.setUserId(userService.readUserByUsername(commentFake.getUsername()).getId());
        comment.setPostId(commentFake.getPostId());

        List<String> mentionUsernameList = commentFake.getMentions();
        List<String> mentionUserIdList = new ArrayList<>();
        if (mentionUsernameList.size() > 0) {
            for (String username : mentionUsernameList) {
                int userId = userService.readUserByUsername(username).getId();
                mentionUserIdList.add(String.valueOf(userId));
            }
        }
        comment.setMentions(mentionUserIdList);

        List<String> hashtagNameList = commentFake.getHashtags();
        List<String> hashtagIdList = new ArrayList<>();
        if (hashtagNameList.size() > 0) {
            for (String hashtagName : hashtagNameList) {
                int hashtagId = hashTagRepository.findByName(hashtagName).getId();
                hashtagIdList.add(String.valueOf(hashtagId));
            }
        }
        comment.setHashtags(hashtagIdList);

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = simpleDateFormat.parse(commentFake.getDayString());
        comment.setDay(date);

        try {
            commentRepository.save(comment);
            return 0;
        } catch (Error error) {
            return 1;
        }
    }

    @Override
    public List<CommentFake> readAllComments(int postId) {
        List<Comment> comments = commentRepository.findAllByPostId(postId);
        List<CommentFake> commentFakeList = new ArrayList<>();
        Collections.sort(comments, new CommentTimeComparator().reversed());

        for (Comment comment : comments) {
            CommentFake commentFake = new CommentFake();

            int userId = comment.getUserId();
            String username = userRepository.findById(userId).get().getUsername();

            List<String> userIdList = comment.getLikes();
            List<String> usernameList = new ArrayList<>();
            for (String userIdString : userIdList) {
                String likeUsername = userRepository.findById(Integer.valueOf(userIdString)).get().getUsername();
                usernameList.add(likeUsername);
            }

            List<String> mentionUserIdList = comment.getMentions();
            List<String> mentionUsernameList = new ArrayList<>();
            if (mentionUserIdList.size() > 0) {
                for (String mentionUserIdString : mentionUserIdList) {
                    String mentionUsername = userRepository.findById(Integer.valueOf(mentionUserIdString)).get().getUsername();
                    mentionUsernameList.add(mentionUsername);
                }
            }

            List<String> hashtagIdList = comment.getHashtags();
            List<String> hashtagNameList = new ArrayList<>();
            if (hashtagIdList.size() > 0) {
                for (String hashtagIdString : hashtagIdList) {
                    String hashtagName = hashTagRepository.findById(Integer.valueOf(hashtagIdString)).get().getName();
                    hashtagNameList.add(hashtagName);
                }
            }

            Date date = comment.getDay();
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String strDate = formatter.format(date);

            commentFake.setId(comment.getId());
            commentFake.setContent(comment.getContent());
            commentFake.setUsername(username);
            commentFake.setLikes(usernameList);
            commentFake.setMentions(mentionUsernameList);
            commentFake.setHashtags(hashtagNameList);
            commentFake.setDayString(strDate);
            commentFake.setPostId(comment.getPostId());

            commentFakeList.add(commentFake);
        }

        return commentFakeList;
    }

    @Override
    public CommentFake insertLike(int commentId, String username) {
        Comment comment = commentRepository.findById(commentId).get();
        List<String> userIdStringList = comment.getLikes();
        List<Integer> userIdList = new ArrayList<>();
        for (String userIdString : userIdStringList) {
            userIdList.add(Integer.valueOf(userIdString));
        }
        int userId = userService.readUserByUsername(username).getId();
        for (int id : userIdList) {
            if (id == userId) {
                return new CommentFake();
            }
        }
        List<String> newUserIdStringList = new ArrayList<>();
        newUserIdStringList.addAll(userIdStringList);
        newUserIdStringList.add(String.valueOf(userId));
        comment.setLikes(newUserIdStringList);
        commentRepository.save(comment);

        CommentFake commentFake = new CommentFake();
        commentFake.setPostId(comment.getPostId());

        List<String> usernames = new ArrayList<>();
        for (String id : comment.getLikes()) {
            String username1 = userRepository.findById(Integer.valueOf(id)).get().getUsername();
            usernames.add(username1);
        }
        commentFake.setLikes(usernames);

        commentFake.setUsername(userRepository.findById(comment.getUserId()).get().getUsername());

        commentFake.setContent(comment.getContent());
        commentFake.setId(comment.getId());

        Date date = comment.getDay();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String strDate = formatter.format(date);
        commentFake.setDayString(strDate);

        return commentFake;
    }

    @Override
    public CommentFake deleteLike(int commentId, String username) {
        Comment comment = commentRepository.findById(commentId).get();
        List<String> userIdStringList = comment.getLikes();
        List<Integer> userIdList = new ArrayList<>();
        for (String userIdString : userIdStringList) {
            userIdList.add(Integer.valueOf(userIdString));
        }
        int userId = userService.readUserByUsername(username).getId();
        for (int id : userIdList) {
            if (id == userId) {
                List<String> newUserIdStringList = new ArrayList<>();
                newUserIdStringList.addAll(userIdStringList);
                newUserIdStringList.remove(String.valueOf(userId));
                comment.setLikes(newUserIdStringList);
                commentRepository.save(comment);

                CommentFake commentFake = new CommentFake();
                commentFake.setPostId(comment.getPostId());

                List<String> usernames = new ArrayList<>();
                for (String ids : comment.getLikes()) {
                    String username1 = userRepository.findById(Integer.valueOf(ids)).get().getUsername();
                    usernames.add(username1);
                }
                commentFake.setLikes(usernames);

                commentFake.setUsername(userRepository.findById(comment.getUserId()).get().getUsername());

                commentFake.setContent(comment.getContent());
                commentFake.setId(comment.getId());

                Date date = comment.getDay();
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String strDate = formatter.format(date);
                commentFake.setDayString(strDate);

                return commentFake;
            }
        }

        return new CommentFake();
    }

}

class CommentTimeComparator implements Comparator<Comment> {

    @Override
    public int compare(Comment o1, Comment o2) {
        return o1.getDay().compareTo(o2.getDay());
    }
}