package com.tradecopier.dto;

import java.util.Date;

import com.tradecopier.enums.UserType;

import lombok.Data;

@Data
public class UserDTO {

	private int userId;
	private int masterlimit;
	private int childlimit;
	private String firstName;
	private String lastName;
	private String gender;
	private String username;
	private String password;
	private String lastLoginIP;
	private String email;
	private String phoneNumber;
	private String state;
	private Date lastLoginTime;
	private Date regDate;
	private boolean active;
	private UserType userType;
}
