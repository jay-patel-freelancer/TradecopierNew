package com.tradecopier.domains;

import java.io.InputStream;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.tradecopier.enums.UserType;

import lombok.Data;

@Data
@Entity
@Table(name = "t_users")
public class User {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer userId;
	
	@Column(name="masterlimit")
	private Integer masterlimit;
	
	@Column(name="childlimit")
	private Integer childlimit;
	
	@Column(name="firstName")
	private String firstName;
	
	@Column(name="lastName")
	private String lastName;
	
	@Column(name="gender")
	private String gender;
	
	@Column(name="username")
	private String username;
	
	@Column(name="password")
	private String password;
	
	@Column(name="lastLoginIP")
	private String lastLoginIP;
	
	@Column(name="email")
	private String email;
	
	@Column(name="phoneNumber")
	private String phoneNumber;
	
	@Column(name="state")
	private String state;
	
	@Column(name="lastLoginTime")
	@Temporal(TemporalType.TIMESTAMP)
	private Date lastLoginTime;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="regDate")
	private Date regDate;
	
	@Column(name="active")
	private boolean active;
	
	@Column(name="userType")
	private UserType userType;
}
