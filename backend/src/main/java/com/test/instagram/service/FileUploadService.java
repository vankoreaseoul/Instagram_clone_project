package com.test.instagram.service;

import org.springframework.web.multipart.MultipartFile;

public interface FileUploadService {
    public void uploadToLocal(MultipartFile file);
    public byte[] downloadFromLocal(String pathString);
    public void deleteAtLocal(String fileName);
}
