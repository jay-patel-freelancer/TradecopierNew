/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tradecopier.domains;

import javax.persistence.Entity;
import javax.persistence.Table;

import lombok.Data;

@Data
@Entity
@Table(name = "t_users")
public class ChildAccount {
    
	private Integer id;
	private User user;
	private MasterAccount master;
	private String broker;
	private String loginId;
	private String password;
	private String pin;
	private String passcode;
	private String q1;
	private String q2;
	private String masterName;
	private String qtyMultiply;
	private String onOff;    
}
