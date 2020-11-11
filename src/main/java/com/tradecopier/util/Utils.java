package util;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

import exceptions.InvalidRequestParameterValueException;

public class Utils {
	public static String getParam(String key, HttpServletRequest request) throws InvalidRequestParameterValueException{
    	if(request.getParameter(key)==null || request.getParameter(key).trim().equals("")){
    		throw new InvalidRequestParameterValueException("Null Parameter: "+key.toUpperCase());
    	}else{
    		return request.getParameter(key);
    	}
    }
	public static String getHashCode(String type, String str){
		byte[] hashseq=str.getBytes();
		StringBuffer hexString = new StringBuffer();
		try{
		MessageDigest algorithm = MessageDigest.getInstance(type);
		algorithm.reset();
		algorithm.update(hashseq);
		byte messageDigest[] = algorithm.digest();
            
		for (int i=0;i<messageDigest.length;i++) {
			String hex=Integer.toHexString(0xFF & messageDigest[i]);
			if(hex.length()==1) hexString.append("0");
			hexString.append(hex);
		}
			
		}catch(NoSuchAlgorithmException nsae){ }
		
		return hexString.toString();
	}
	
	public static boolean empty(String s){
		if(s == null || s.trim().equals("")){
			return true;
		}else{
			return false;
		}
	}
}
