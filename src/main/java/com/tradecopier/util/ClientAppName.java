package util;



public enum ClientAppName {
	TRADE_COPIER;
	
	public static boolean isAppExist(String appName){
		boolean isExist = false;
		for(ClientAppName sname : ClientAppName.values()){
			if(sname.toString().equals(appName)){
				isExist = true;
				break;
			}
		}
		return isExist;
	}
}