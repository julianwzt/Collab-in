package com.impal.collabin;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
@SpringBootApplication
@EnableScheduling
public class CollabinApplication {

	public static void main(String[] args) {
		SpringApplication.run(CollabinApplication.class, args);
	}

}