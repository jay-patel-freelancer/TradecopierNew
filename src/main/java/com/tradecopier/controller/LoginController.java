package com.tradecopier.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.tradecopier.dto.LoginDTO;
import com.tradecopier.services.Userservice;

import lombok.NoArgsConstructor;

@RestController
@NoArgsConstructor
public class LoginController {
	
	@Autowired
	Userservice userservice;
	
	@GetMapping("/login")
	public String loginUser(@RequestBody LoginDTO loginDTO) {
		userservice.loginUser(loginDTO.);
		return "login";
	}
}
