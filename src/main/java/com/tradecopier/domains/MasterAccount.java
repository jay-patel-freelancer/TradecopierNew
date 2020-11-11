/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tradecopier.domains;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "t_users")
public class MasterAccount {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
	
	@Column(name="user")
    private User user;
	
	@Column(name="name")
    private String name;
	
	@Column(name="broker")
    private String broker; 
	
	@Column(name="loginId")
    private String loginId;
	
	@Column(name="password")
    private String password;
	
	@Column(name="pin")
    private String pin;
	
	@Column(name="passcode")
    private String passcode;
	
	@Column(name="q1")
    private String q1;
	
	@Column(name="q2")
    private String q2;
	
	@Column(name="token")
    private String token; 
	
	@Column(name="onoff")
    private String onOff;
	
	@Column(name="cookie")
    private java.net.CookieStore cookie;
	
	@Column(name="loged")
    private boolean loged;
	
	@Column(name="orf")
    private boolean orf;
}
