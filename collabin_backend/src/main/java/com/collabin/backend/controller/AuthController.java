package com.collabin.backend.controller;

import com.collabin.backend.model.User;
import com.collabin.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User user) {
        if (user.getEmail() == null || user.getPassword() == null) {
            return ResponseEntity.badRequest().body("Email dan password wajib diisi");
        }
        return ResponseEntity.ok().body("Login berhasil");
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        if (user.getEmail() == null || user.getPassword() == null || user.getNamaLengkap() == null) {
            return ResponseEntity.badRequest().body("Lengkapi semua field pendaftaran");
        }
        User saved = userRepository.save(user);
        return ResponseEntity.ok(saved);
    }
}
