package com.tradecopier.exceptions;

public class InvalidRequestParameterValueException extends Exception{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public InvalidRequestParameterValueException(String msg) {
		super(msg);
	}
}
