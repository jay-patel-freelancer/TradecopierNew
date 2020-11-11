package com.tradecopier.services;

import com.tradecopier.dto.LoginDTO;
import com.tradecopier.dto.UserDTO;

public interface Userservice  {

	public UserDTO loginUser(LoginDTO loginDTO) throws Exception;

}
