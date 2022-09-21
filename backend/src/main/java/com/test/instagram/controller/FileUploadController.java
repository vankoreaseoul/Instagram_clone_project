package com.test.instagram.controller;

import com.test.instagram.entity.User;
import com.test.instagram.service.FileUploadService;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class FileUploadController {

    @Autowired private FileUploadService fileUploadService;

    @PostMapping(value = "/upload_profile_info")
    private void uploadProfileInfo(@RequestParam("file") MultipartFile file) {
        fileUploadService.uploadToLocal(file);
    }

    @GetMapping(value = "/download_profile_info")
    private byte[] downloadProfileInfo(@RequestParam("pathString") String pathString) {
        return fileUploadService.downloadFromLocal(pathString);
    }

    @DeleteMapping(value = "/delete_profile_info")
    private void deleteProfileInfo(@RequestBody JSONObject filename) {
        String newFileName = (String) filename.get("filename");
        fileUploadService.deleteAtLocal(newFileName);
    }
}
