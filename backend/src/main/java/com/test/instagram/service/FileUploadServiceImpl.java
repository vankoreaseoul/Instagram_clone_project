package com.test.instagram.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class FileUploadServiceImpl implements FileUploadService {

    @Autowired UserService userService;
    private String uploadFolderPath = "/Users/heawonseo/Desktop/Instagram_image/profile/";

    @Override
    public void uploadToLocal(MultipartFile file) {
        try {
            byte[] data = file.getBytes();
            String pathString = uploadFolderPath + file.getOriginalFilename() + ".png";
            Path path = Paths.get(pathString);
            Files.write(path, data);
            userService.insertImagePath(file.getOriginalFilename(), pathString);
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
        return data;
    }

    @Override
    public void deleteAtLocal(String filename) {
        try {
            String pathString = uploadFolderPath + filename + ".png";
            Path path = Paths.get(pathString);
            Files.delete(path);
            userService.deleteImagePath(filename);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
