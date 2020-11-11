package com.tradecopier.domains;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import com.tradecopier.util.AppSubscription;
import com.tradecopier.util.ClientAppName;

import lombok.Data;
@Data
@Entity
@Table(name = "t_users")
public class ClientAppAccount {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer rowId;
	
	@Column(name="user")
	private User user;
	
	@Column(name="clientAppName")
	private ClientAppName clientAppName;
	
	@Column(name="bindedDeviceId")
	private String bindedDeviceId;
	
	@Column(name="bindedDeviceName")
	private String bindedDeviceName;
	
	@Column(name="appRegisterId")
	private String appRegisterId;
	
	@Column(name="subscriptionName")
	private String subscriptionName;
	
	@Column(name="lastLoginIP")
	private String lastLoginIP;
	
	@Column(name="token")
	private String token;
	
	@Column(name="subscriptionStartDate")
	private Date subscriptionStartDate;
	
	@Column(name="subscriptionExpireDate")
	private Date subscriptionExpireDate;
	
	@Column(name="lastLoginTime")
	private Date lastLoginTime;
	
	@Column(name="deviceRegTime")
	private Date deviceRegTime;
	
	@Column(name="subscriptionFor")
	private AppSubscription.Subscriptions subscriptionFor;
}
