package com.example.biosphere.model;

public class User {
    private String userID;
    private String password;
    private String nickname;

    // 背景設定用のフィールドを追加
    private String backgroundType; // "color" または "image"
    private String backgroundColor; // カラーコード (例: #000000)
    private String backgroundImagePath; // 画像のパス


    public User(String userID,String password,String nickname) {
        this.userID = userID;
        this.password = password;
        this.nickname = nickname;
        // デフォルト値を設定
        this.backgroundType = "color";
        this.backgroundColor = "#000000";
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNickname(){
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    // 以下のGetter/Setterを追加
    public String getBackgroundType() {
        return backgroundType;
    }

    public void setBackgroundType(String backgroundType) {
        this.backgroundType = backgroundType;
    }

    public String getBackgroundColor() {
        return backgroundColor;
    }

    public void setBackgroundColor(String backgroundColor) {
        this.backgroundColor = backgroundColor;
    }

    public String getBackgroundImagePath() {
        return backgroundImagePath;
    }

    public void setBackgroundImagePath(String backgroundImagePath) {
        this.backgroundImagePath = backgroundImagePath;
    }
}