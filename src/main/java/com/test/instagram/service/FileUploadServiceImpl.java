package com.test.instagram.service;

import com.test.instagram.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class FileUploadServiceImpl implements FileUploadService {

    @Autowired UserService userService;
    @Autowired PostRepository postRepository;

    private String uploadProfileFolderPath = "/Users/heawonseo/Desktop/Instagram_image/profile/";
    private String uploadPostFolderPath = "/Users/heawonseo/Desktop/Instagram_image/post/";

    @Override
    public void uploadToLocal(MultipartFile file) {
        try {
            byte[] data = file.getBytes();
            String pathString = "";
            String filename = file.getOriginalFilename();

            if (filename.contains("@")) {
                pathString = uploadProfileFolderPath + filename + ".png";
            } else {
                Integer postId = Integer.valueOf(filename);
                Integer userId = postRepository.findById(postId).get().getUserId();
                String userIdString = String.valueOf(userId);
                File postStorage = new File(uploadPostFolderPath + userIdString);
                postStorage.mkdirs();
                pathString = uploadPostFolderPath + userIdString + "/" + filename + ".png";
            }

            Path path = Paths.get(pathString);
            Files.write(path, data);

            if (filename.contains("@")) {
                userService.insertImagePath(file.getOriginalFilename(), pathString);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    @Override
    public byte[] downloadFromLocal(String pathString) {
        byte[] data = null;

        try {
            System.out.println("pathString = " + pathString);
            Path path = Paths.get(pathString);
            data = Files.readAllBytes(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(data);
        return data;
    }

    @Override
    public void deleteAtLocal(String filename) {
        try {
            String pathString = "";
            if (filename.contains("@")) {
                userService.deleteImagePath(filename);
                pathString = uploadProfileFolderPath + filename + ".png";
            } else {
                pathString = uploadPostFolderPath + filename;
            }
            Path path = Paths.get(pathString);
            Files.delete(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
