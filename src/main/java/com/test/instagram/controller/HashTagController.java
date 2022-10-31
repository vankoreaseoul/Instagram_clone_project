package com.test.instagram.controller;

import com.test.instagram.entity.HashTag;
import com.test.instagram.service.HashTagService;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/hashTag")
public class HashTagController {
    @Autowired
    private HashTagService hashTagService;

    @GetMapping(value = "/search")
    private List<HashTag> searchHashTags(@RequestParam String name) {
        return hashTagService.searchHashTags(name);
    }

    @PostMapping(value = "")
    private Integer insertHashTag(@RequestBody JSONObject jsonObject) {
        String name = (String) jsonObject.get("name");
        return hashTagService.insertHashTag(name);
    }

    @GetMapping(value = "")
    private HashTag readHashTag(@RequestParam String name) {
        return hashTagService.readHashTag(name);
    }
}
