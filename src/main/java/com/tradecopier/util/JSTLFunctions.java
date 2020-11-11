package util;

public class JSTLFunctions {
	public static String[] getAppSubscriptionStringArray(util.ClientAppName appName){
		return util.AppSubscription.Utils.getAppSubscriptionStringArray(appName);
	}
}
