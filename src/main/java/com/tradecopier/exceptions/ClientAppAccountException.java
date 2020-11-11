package com.tradecopier.exceptions;

public class ClientAppAccountException extends Exception {
	private static final long serialVersionUID = 1L;
	
	public static class AccountNotFound extends Exception{
		private static final long serialVersionUID = 1L;
		public AccountNotFound(String message) {
			super(message);
		}
	}
	
	public static class UserBindedWithOtherDevice extends Exception{
		private static final long serialVersionUID = 1L;
		public UserBindedWithOtherDevice(String message) {
			super(message);
		}
	}
	
	public static class NotAuthorizedException extends Exception {
		private static final long serialVersionUID = 1L;
		public NotAuthorizedException(String string) {
			super(string);
		}
	}
	public static class DeviceBindedWithOtherUser extends Exception{
		private static final long serialVersionUID = 1L;
		public DeviceBindedWithOtherUser(String message) {
			super(message);
		}
	}
}
