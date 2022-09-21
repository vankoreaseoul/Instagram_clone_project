package com.test.instagram.controller;

import com.fasterxml.jackson.core.JsonParser;
import com.test.instagram.service.MailService;
import com.test.instagram.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/mail")
public class MailController {

    private final MailService mailService;
    @Autowired
    private UserService userService;
    private Map<String, String> map = new HashMap<>();

    @GetMapping(value="/validEmail")
    private Integer mailConfirm(@RequestParam String email) throws Exception {
        try {
            String code = mailService.sendSimpleMessage(email);
            log.info("인증코드 : " + code);
            map.put(email, code);
            return 0;
        } catch (Error error){
            System.out.println(error);
            return 1;
        }
    }

    @PostMapping(value="/validEmail")
    private Integer codeConfirm(@RequestBody String params) throws ParseException {
        JSONParser jsonParser = new JSONParser();
        Object obj = jsonParser.parse(params);
        JSONObject jsonObject = (JSONObject) obj;

        String email = (String) jsonObject.get("email");
        String code = (String) jsonObject.get("code");

        if (map.get(email).equals(code)) {
            if (userService.validateEmail(email) == 0) {
                return 0;
            }
            return 1;
        } else {
            return 1;
        }
    }


}
