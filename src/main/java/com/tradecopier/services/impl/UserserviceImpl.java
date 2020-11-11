package com.tradecopier.services.impl;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.stereotype.Service;

import com.tradecopier.domains.User;
import com.tradecopier.dto.LoginDTO;
import com.tradecopier.dto.UserDTO;
import com.tradecopier.mapper.UserMapper;
import com.tradecopier.repository.UserRepository;
import com.tradecopier.services.Userservice;

@Service
public class UserserviceImpl implements Userservice {

	@Autowired
	UserRepository userRepository;
	
	@Autowired
	UserMapper userMapper;

	public UserDTO loginUser(LoginDTO loginDTO) throws Exception {
		Optional<User> user=userRepository.findByUsername(loginDTO.getUsername());
		if(user.isPresent()) {
			return userMapper.toDto(user.get());
		}
		return null;
	}
}
