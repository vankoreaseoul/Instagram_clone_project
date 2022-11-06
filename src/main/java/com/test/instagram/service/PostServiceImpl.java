package com.test.instagram.service;

import com.test.instagram.entity.Post;
import com.test.instagram.entity.PostFake2;
import com.test.instagram.repository.HashTagRepository;
import com.test.instagram.repository.PostRepository;
import com.test.instagram.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class PostServiceImpl implements PostService {

    @Autowired PostRepository postRepository;
    @Autowired
    UserRepository userRepository;
    @Autowired
    HashTagRepository hashTagRepository;
    @Autowired
    FileUploadService fileUploadService;

    @Override
    public Integer insetNewPost(Post post) {
        try {
            Post savedPost = postRepository.save(post);
            return savedPost.getId();
        } catch(Error e) {
            return 0;
        }
    }

    @Override
    public Integer deletePost(int postId) {
        try {
            Post post = postRepository.findById(postId).get();
            int userId = post.getUserId();
            String filename = String.valueOf(userId) + "/" + String.valueOf(postId) + ".png";
            postRepository.delete(post);
            fileUploadService.deleteAtLocal(filename);
            return  0;
        } catch (IllegalArgumentException e) {
            return  1;
        }
    }

    @Override
    public PostFake2 updatePost(Post post) {
        System.out.println(post);
        try {
            Post savedPost = postRepository.save(post);

            PostFake2 postFake2 = new PostFake2();
            postFake2.setId(savedPost.getId());
            postFake2.setUsername(userRepository.findById(savedPost.getUserId()).get().getUsername());

            String content = savedPost.getContent();
            if (content == null) {
                content = "";
            }
            postFake2.setContent(content);

            List<String> tagUserIdList = savedPost.getTagPeopleUserIdList();
            List<String> tagUsernameList = new ArrayList<>();
            for (String userIdLetter : tagUserIdList) {
                int tagUserId = Integer.valueOf(userIdLetter);
                tagUsernameList.add(userRepository.findById(tagUserId).get().getUsername());
            }
            postFake2.setTagPeople(tagUsernameList);

            List<String> mentionUserIdList = savedPost.getMentionUserIdList();
            List<String> mentionUsernameList = new ArrayList<>();
            for (String mentionUserIdString : mentionUserIdList) {
                int mentionUserId = Integer.valueOf(mentionUserIdString);
                mentionUsernameList.add(userRepository.findById(mentionUserId).get().getUsername());
            }
            postFake2.setMentions(mentionUsernameList);

            List<String> hashTagIdList = savedPost.getHashTagIdList();
            List<String> hashTagNameList = new ArrayList<>();
            for (String hashTagIdString : hashTagIdList) {
                int hashTagId = Integer.valueOf(hashTagIdString);
                hashTagNameList.add(hashTagRepository.findById(hashTagId).get().getName());
            }
            postFake2.setHashtags(hashTagNameList);

            String location = savedPost.getLocation();
            if (location == null) {
                location = "";
            }
            postFake2.setLocation(location);

            Date date = savedPost.getDay();
            SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy");
            String strDate = formatter.format(date);
            postFake2.setDayString(strDate);

            List<String> userIdArray = savedPost.getLikeUserIdList();
            List<String> usernames = new ArrayList<>();
            for (String userIdSting : userIdArray) {
                int userIdNumber = Integer.valueOf(userIdSting);
                String username = userRepository.findById(userIdNumber).get().getUsername();
                usernames.add(username);
            }
            postFake2.setLikes(usernames);
            return postFake2;
        } catch(Error e) {
            return new PostFake2();
        }
    }

    @Override
    public List<PostFake2> readAllPostsByUserIdList(List<Integer> userIdList) {
        List<Post> postList = new ArrayList<>();
        for (int userId : userIdList) {
            List<Post> posts = postRepository.findAllByUserId(userId);
            postList.addAll(posts);
        }

        Collections.sort(postList, new PostTimeComparator().reversed());

        List<PostFake2> coreList = new ArrayList<>();
        for (Post post : postList) {
                PostFake2 postFake2 = new PostFake2();
                postFake2.setId(post.getId());
                postFake2.setUsername(userRepository.findById(post.getUserId()).get().getUsername());

                String content = post.getContent();
                if (content == null) {
                    content = "";
                }
                postFake2.setContent(content);

                List<String> tagUserIdList = post.getTagPeopleUserIdList();
                List<String> tagUsernameList = new ArrayList<>();
                for (String userIdString : tagUserIdList) {
                    int tagUserId = Integer.valueOf(userIdString);
                    tagUsernameList.add(userRepository.findById(tagUserId).get().getUsername());
                }
                postFake2.setTagPeople(tagUsernameList);

                List<String> mentionUserIdList = post.getMentionUserIdList();
                List<String> mentionUsernameList = new ArrayList<>();
                for (String mentionUserIdString : mentionUserIdList) {
                    int mentionUserId = Integer.valueOf(mentionUserIdString);
                    mentionUsernameList.add(userRepository.findById(mentionUserId).get().getUsername());
                }
                postFake2.setMentions(mentionUsernameList);

                List<String> hashTagIdList = post.getHashTagIdList();
                List<String> hashTagNameList = new ArrayList<>();
                for (String hashTagIdString : hashTagIdList) {
                    int hashTagId = Integer.valueOf(hashTagIdString);
                    hashTagNameList.add(hashTagRepository.findById(hashTagId).get().getName());
                }
                postFake2.setHashtags(hashTagNameList);

                String location = post.getLocation();
                if (location == null) {
                    location = "";
                }
                postFake2.setLocation(location);

                Date date = post.getDay();
                SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy");
                String strDate = formatter.format(date);
                postFake2.setDayString(strDate);

                List<String> userIds = post.getLikeUserIdList();
                List<String> usernames = new ArrayList<>();
                for (String userIdSting : userIds) {
                    int userId = Integer.valueOf(userIdSting);
                    String username = userRepository.findById(userId).get().getUsername();
                    usernames.add(username);
                }
                postFake2.setLikes(usernames);

                coreList.add(postFake2);
            }

        return coreList;
    }

    @Override
    public List<PostFake2> readTaggedPostsByUserId(String userId) {
        String q1 = userId;
        String q2 = "%," + userId;
        String q3 =  userId + ",%";
        String q4 = "%," + userId + ",%";
        List<Post> posts1 = postRepository.findAllTaggedByUserId(q1);
        List<Post> posts2 = postRepository.findAllTaggedByUserId(q2);
        List<Post> posts3 = postRepository.findAllTaggedByUserId(q3);
        List<Post> posts4 = postRepository.findAllTaggedByUserId(q4);

        List<Post> posts = new ArrayList<>();
        posts.addAll(posts1);
        posts.addAll(posts2);
        posts.addAll(posts3);
        posts.addAll(posts4);

        Collections.sort(posts, new PostTimeComparator().reversed());

        List<PostFake2> coreList = new ArrayList<>();
        for (Post post : posts) {
            PostFake2 postFake2 = new PostFake2();
            postFake2.setId(post.getId());
            postFake2.setUsername(userRepository.findById(post.getUserId()).get().getUsername());

            String content = post.getContent();
            if (content == null) {
                content = "";
            }
            postFake2.setContent(content);

            List<String> tagUserIdList = post.getTagPeopleUserIdList();
            List<String> tagUsernameList = new ArrayList<>();
            for (String userIdString : tagUserIdList) {
                int tagUserId = Integer.valueOf(userIdString);
                tagUsernameList.add(userRepository.findById(tagUserId).get().getUsername());
            }
            postFake2.setTagPeople(tagUsernameList);

            List<String> mentionUserIdList = post.getMentionUserIdList();
            List<String> mentionUsernameList = new ArrayList<>();
            for (String mentionUserIdString : mentionUserIdList) {
                int mentionUserId = Integer.valueOf(mentionUserIdString);
                mentionUsernameList.add(userRepository.findById(mentionUserId).get().getUsername());
            }
            postFake2.setMentions(mentionUsernameList);

            List<String> hashTagIdList = post.getHashTagIdList();
            List<String> hashTagNameList = new ArrayList<>();
            for (String hashTagIdString : hashTagIdList) {
                int hashTagId = Integer.valueOf(hashTagIdString);
                hashTagNameList.add(hashTagRepository.findById(hashTagId).get().getName());
            }
            postFake2.setHashtags(hashTagNameList);

            String location = post.getLocation();
            if (location == null) {
                location = "";
            }
            postFake2.setLocation(location);

            Date date = post.getDay();
            SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy");
            String strDate = formatter.format(date);
            postFake2.setDayString(strDate);

            List<String> userIds = post.getLikeUserIdList();
            List<String> usernames = new ArrayList<>();
            for (String userIdSting : userIds) {
                int userIdInteger = Integer.valueOf(userIdSting);
                String username = userRepository.findById(userIdInteger).get().getUsername();
                usernames.add(username);
            }
            postFake2.setLikes(usernames);

            coreList.add(postFake2);
        }
        return coreList;
    }

    @Override
    public List<PostFake2> readHashtagPosts(String hashtagId) {
        String q1 = hashtagId;
        String q2 = "%," + hashtagId;
        String q3 = hashtagId + ",%";
        String q4 = "%," + hashtagId + ",%";
        List<Post> posts1 = postRepository.findAllByHashtagId(q1);
        List<Post> posts2 = postRepository.findAllByHashtagId(q2);
        List<Post> posts3 = postRepository.findAllByHashtagId(q3);
        List<Post> posts4 = postRepository.findAllByHashtagId(q4);

        List<Post> posts = new ArrayList<>();
        posts.addAll(posts1);
        posts.addAll(posts2);
        posts.addAll(posts3);
        posts.addAll(posts4);

        Collections.sort(posts, new PostTimeComparator().reversed());

        List<PostFake2> coreList = new ArrayList<>();
        for (Post post : posts) {
            PostFake2 postFake2 = new PostFake2();
            postFake2.setId(post.getId());
            postFake2.setUsername(userRepository.findById(post.getUserId()).get().getUsername());

            String content = post.getContent();
            if (content == null) {
                content = "";
            }
            postFake2.setContent(content);

            List<String> tagUserIdList = post.getTagPeopleUserIdList();
            List<String> tagUsernameList = new ArrayList<>();
            for (String userIdString : tagUserIdList) {
                int tagUserId = Integer.valueOf(userIdString);
                tagUsernameList.add(userRepository.findById(tagUserId).get().getUsername());
            }
            postFake2.setTagPeople(tagUsernameList);

            List<String> mentionUserIdList = post.getMentionUserIdList();
            List<String> mentionUsernameList = new ArrayList<>();
            for (String mentionUserIdString : mentionUserIdList) {
                int mentionUserId = Integer.valueOf(mentionUserIdString);
                mentionUsernameList.add(userRepository.findById(mentionUserId).get().getUsername());
            }
            postFake2.setMentions(mentionUsernameList);

            List<String> hashTagIdList = post.getHashTagIdList();
            List<String> hashTagNameList = new ArrayList<>();
            for (String hashTagIdString : hashTagIdList) {
                int hashTagId = Integer.valueOf(hashTagIdString);
                hashTagNameList.add(hashTagRepository.findById(hashTagId).get().getName());
            }
            postFake2.setHashtags(hashTagNameList);

            String location = post.getLocation();
            if (location == null) {
                location = "";
            }
            postFake2.setLocation(location);

            Date date = post.getDay();
            SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy");
            String strDate = formatter.format(date);
            postFake2.setDayString(strDate);

            List<String> userIds = post.getLikeUserIdList();
            List<String> usernames = new ArrayList<>();
            for (String userIdSting : userIds) {
                int userIdInteger = Integer.valueOf(userIdSting);
                String username = userRepository.findById(userIdInteger).get().getUsername();
                usernames.add(username);
            }
            postFake2.setLikes(usernames);

            coreList.add(postFake2);
        }
        return coreList;
    }

    @Override
    public PostFake2 insertLike(int postId, String userId) {
        Post post = postRepository.findById(postId).get();
        List<String> userIdList = post.getLikeUserIdList();
        for (String userIdString : userIdList) {
            if (userIdString.equals(userId)) {
                return new PostFake2();
            }
        }
        List<String> userIds = new ArrayList<>();
        userIds.addAll(userIdList);
        userIds.add(userId);
        post.setLikeUserIdList(userIds);
        Post updatedPost = postRepository.save(post);

        PostFake2 postFake2 = new PostFake2();
        postFake2.setId(updatedPost.getId());
        postFake2.setUsername(userRepository.findById(updatedPost.getUserId()).get().getUsername());

        String content = updatedPost.getContent();
        if (content == null) {
            content = "";
        }
        postFake2.setContent(content);

        List<String> tagUserIdList = updatedPost.getTagPeopleUserIdList();
        List<String> tagUsernameList = new ArrayList<>();
        for (String userIdString : tagUserIdList) {
            int tagUserId = Integer.valueOf(userIdString);
            tagUsernameList.add(userRepository.findById(tagUserId).get().getUsername());
        }
        postFake2.setTagPeople(tagUsernameList);

        List<String> mentionUserIdList = updatedPost.getMentionUserIdList();
        List<String> mentionUsernameList = new ArrayList<>();
        for (String mentionUserIdString : mentionUserIdList) {
            int mentionUserId = Integer.valueOf(mentionUserIdString);
            mentionUsernameList.add(userRepository.findById(mentionUserId).get().getUsername());
        }
        postFake2.setMentions(mentionUsernameList);

        List<String> hashTagIdList = updatedPost.getHashTagIdList();
        List<String> hashTagNameList = new ArrayList<>();
        for (String hashTagIdString : hashTagIdList) {
            int hashTagId = Integer.valueOf(hashTagIdString);
            hashTagNameList.add(hashTagRepository.findById(hashTagId).get().getName());
        }
        postFake2.setHashtags(hashTagNameList);

        String location = updatedPost.getLocation();
        if (location == null) {
            location = "";
        }
        postFake2.setLocation(location);

        Date date = updatedPost.getDay();
        SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy");
        String strDate = formatter.format(date);
        postFake2.setDayString(strDate);

        List<String> userIdArray = updatedPost.getLikeUserIdList();
        List<String> usernames = new ArrayList<>();
        for (String userIdSting : userIdArray) {
            int userIdNumber = Integer.valueOf(userIdSting);
            String username = userRepository.findById(userIdNumber).get().getUsername();
            usernames.add(username);
        }
        postFake2.setLikes(usernames);

        return postFake2;
    }

    @Override
    public PostFake2 deleteLike(int postId, String userId) {
        Post post = postRepository.findById(postId).get();
        List<String> userIdList = post.getLikeUserIdList();
        List<String> userIds = new ArrayList<>();
        userIds.addAll(userIdList);

        for (String userIdString : userIds) {
            if (userIdString.equals(userId)) {
                userIds.remove(userId);
                post.setLikeUserIdList(userIds);
                Post updatedPost = postRepository.save(post);

                PostFake2 postFake2 = new PostFake2();
                postFake2.setId(updatedPost.getId());
                postFake2.setUsername(userRepository.findById(updatedPost.getUserId()).get().getUsername());

                String content = updatedPost.getContent();
                if (content == null) {
                    content = "";
                }
                postFake2.setContent(content);

                List<String> tagUserIdList = updatedPost.getTagPeopleUserIdList();
                List<String> tagUsernameList = new ArrayList<>();
                for (String userIdLetter : tagUserIdList) {
                    int tagUserId = Integer.valueOf(userIdLetter);
                    tagUsernameList.add(userRepository.findById(tagUserId).get().getUsername());
                }
                postFake2.setTagPeople(tagUsernameList);

                List<String> mentionUserIdList = updatedPost.getMentionUserIdList();
                List<String> mentionUsernameList = new ArrayList<>();
                for (String mentionUserIdString : mentionUserIdList) {
                    int mentionUserId = Integer.valueOf(mentionUserIdString);
                    mentionUsernameList.add(userRepository.findById(mentionUserId).get().getUsername());
                }
                postFake2.setMentions(mentionUsernameList);

                List<String> hashTagIdList = updatedPost.getHashTagIdList();
                List<String> hashTagNameList = new ArrayList<>();
                for (String hashTagIdString : hashTagIdList) {
                    int hashTagId = Integer.valueOf(hashTagIdString);
                    hashTagNameList.add(hashTagRepository.findById(hashTagId).get().getName());
                }
                postFake2.setHashtags(hashTagNameList);

                String location = updatedPost.getLocation();
                if (location == null) {
                    location = "";
                }
                postFake2.setLocation(location);

                Date date = updatedPost.getDay();
                SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy");
                String strDate = formatter.format(date);
                postFake2.setDayString(strDate);

                List<String> userIdArray = updatedPost.getLikeUserIdList();
                List<String> usernames = new ArrayList<>();
                for (String userIdSting : userIdArray) {
                    int userIdNumber = Integer.valueOf(userIdSting);
                    String username = userRepository.findById(userIdNumber).get().getUsername();
                    usernames.add(username);
                }
                postFake2.setLikes(usernames);

                return postFake2;
            }
        }
        return new PostFake2();
    }
}

class PostTimeComparator implements Comparator<Post> {

    @Override
    public int compare(Post o1, Post o2) {
        return o1.getDay().compareTo(o2.getDay());
    }
}
