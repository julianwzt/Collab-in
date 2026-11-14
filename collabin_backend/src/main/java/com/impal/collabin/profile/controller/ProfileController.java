package com.impal.collabin.profile.controller;

import com.impal.collabin.profile.model.response.ProfileResponse;
import com.impal.collabin.profile.service.ProfileService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/profile")
public class ProfileController {

    private final ProfileService profileService;

    public ProfileController(ProfileService profileService) {
        this.profileService = profileService;
    }

    @GetMapping
    public ResponseEntity<ProfileResponse> getMyProfile(
            @RequestHeader("Authorization") String authorizationHeader
    ) {
        ProfileResponse response = profileService.getMyProfile(authorizationHeader);
        return ResponseEntity.ok(response);
    }
}