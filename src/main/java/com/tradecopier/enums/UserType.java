package com.tradecopier.enums;

public enum UserType {

        ADMIN("Admin"),
        USER("Regular User"),
        PREMIUM_USER("Premium User");
	
        private String type;
        
        private UserType(String type) {
            this.type = type;
        }

        public String stringValue() {
            return this.type;
        }
    }