package com.example.biosphere.model;

import java.sql.Timestamp;

public class Post {
    private int postID;
    private String userID;
    private String nickname; // 表示用（DB保存時は使わない）
    private String title;
    private String content;
    private String category;
    private String imagePath;
    private Timestamp createdAt;

    //  コンストラクタ1：DBから取得するとき用（全部入り）
    public Post(int postID, String userID, String nickname, String title, String content, String category, String imagePath, Timestamp createdAt) {
        this.postID = postID;
        this.userID = userID;
        this.nickname = nickname;
        this.title = title;
        this.content = content;
        this.category = category;
        this.imagePath = imagePath;
        this.createdAt = createdAt;
    }

    //  コンストラクタ2：新規投稿を作成するとき用
    // (postIDとcreatedAtはDBが自動で決めるので、それ以外を受け取る)
    public Post(String userID, String title, String content, String category, String imagePath) {
        this.userID = userID;
        this.title = title;
        this.content = content;
        this.category = category;
        this.imagePath = imagePath;
    }

    public int getPostID() { return postID; }
    public void setPostID(int postID) { this.postID = postID; }

    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}