package com.example.biosphere;

public class User {
    private String userID;
    private String password;
    private String nickname;

    public User(String userID,String password,String nickname) {
        this.userID = userID;
        this.password = password;
        this.nickname = nickname;
    }

    public String getUserID() {
        return userID;
    }

    public String getPassword() {
        return password;
    }

    public String getNickname(){
        return nickname;
    }
}
