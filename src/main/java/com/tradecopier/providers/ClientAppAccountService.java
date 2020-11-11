package com.tradecopier.providers;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;



import dblayer.ClientAppDAO;
import dblayer.UserDAO;
import exceptions.ClientAppAccountException.AccountNotFound;
import exceptions.MemberNotFoundException;
import to.ClientAppAccount;
import to.User;
import util.AppSubscription;
import util.ClientAppName;

public class ClientAppAccountService {
	private final ClientAppDAO clientAppDAO = new ClientAppDAO();
	private final UserDAO userDAO = new UserDAO();
	
	private void createUnbindedAppAccount(int userId, ClientAppName appName) throws SQLException{
		ClientAppAccount appAccount = new ClientAppAccount();
		appAccount.setUserId(userId);
		appAccount.setClientAppName(appName);
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata"));
		cal.setTime(new Date());
		appAccount.setBindedDeviceId("NA");
		appAccount.setBindedDeviceName("NA");
		appAccount.setDeviceRegTime(cal.getTime());
		appAccount.setSubscriptionStartDate(cal.getTime());
		cal.add(Calendar.DAY_OF_MONTH, 6);
		appAccount.setSubscriptionExpireDate(cal.getTime());
		appAccount.setSubscriptionName("6 Days Demo");
		appAccount.setSubscriptionFor(AppSubscription.McxRatesAutoTips.COMPLETE_PACKAGE);
		clientAppDAO.setClientAppAccount(appAccount);
	}
	
	public ClientAppAccount getUserAppAccountByUserId(int userId, ClientAppName appName) throws SQLException{
		ClientAppAccount appAccountWithUser = null;
		try{
			appAccountWithUser = clientAppDAO.getClientAppAccountByUserId(userId, appName);
		}catch(AccountNotFound e){
			System.out.println("Exception" +e.getMessage());
			createUnbindedAppAccount(userId, appName);
			try{
				appAccountWithUser = clientAppDAO.getClientAppAccountByUserId(userId, appName);
			}catch(AccountNotFound ex){/* Ignored */}
		}
		return appAccountWithUser;
	}
	
	public User getDeviceBindedUser(String deviceId, ClientAppName appName) throws SQLException, MemberNotFoundException{
		User deviceBindedUser = null;
		try{
			ClientAppAccount acc = clientAppDAO.getClientAppAccountByDeviceId(deviceId, appName);
			deviceBindedUser = userDAO.getUserById(acc.getUserId());
		}catch(AccountNotFound e){
			throw new MemberNotFoundException("No user is associated with device: "+deviceId);
		}
		return deviceBindedUser;
	}
	
	public ArrayList<ClientAppAccount> getUserAppAccounts(int userId) throws SQLException{
		return clientAppDAO.getUserAppAccounts(userId);
	}
	
	public void bindUserWithDevice(ClientAppAccount userAppAccount) throws SQLException{
		clientAppDAO.setDevice(userAppAccount.getRowId(), userAppAccount.getBindedDeviceId(), 
				userAppAccount.getBindedDeviceName(), userAppAccount.getAppRegisterId(), userAppAccount.getToken());
	}
	
	public void clearAllRegIdWithRegId(String regId) throws SQLException {
		clientAppDAO.clearAllRegIdWithRegId(regId);
	}
	
	public void setApplicationRegisterId(ClientAppAccount userAppAccount) throws SQLException{
		clientAppDAO.setApplicationRegisterId(userAppAccount.getRowId(), userAppAccount.getAppRegisterId());
	}
	
	public void releaseDevice(int rowId) throws SQLException{
		clientAppDAO.setDevice(rowId, "NA", "NA", "NA", "");
	}
	
	public void updateLastLoginStatus(ClientAppAccount userAppAccount) throws SQLException{
		clientAppDAO.updateLastLoginStatus(userAppAccount);
	}
	
	public void updateSubscription(ClientAppAccount userAppAccount) throws SQLException{
		clientAppDAO.updateSubscription(userAppAccount);
	}
}
