package com.example.biosphere;

import java.util.HashMap;
import java.util.Map;

public class UserRepository {
    // メモリ上でユーザーを保存する簡易的なマップ (実運用ではデータベースを使用)
    private static final Map<String, User> users = new HashMap<>();

    public static void register(User user) {
        users.put(user.getUserID(), user);
    }

    public static User findByUserID(String userID) {
        return users.get(userID);
    }

    public static boolean exists(String userID) {
        return users.containsKey(userID);
    }
}
