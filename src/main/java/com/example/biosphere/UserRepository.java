package com.example.biosphere;

import java.util.HashMap;
import java.util.Map;

public class UserRepository {
    // メモリ上でユーザーを保存する簡易的なマップ
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

    // ユーザー情報の更新（ID変更に対応するため、古いIDで削除して新しいIDで登録し直す）
    public static void update(String oldUserID, User user) {
        if (!oldUserID.equals(user.getUserID())) {
            users.remove(oldUserID);
        }
        users.put(user.getUserID(), user);
    }

    // ニックネームの重複チェック（自分自身は除外）
    public static boolean isNicknameTaken(String nickname, String currentUserID) {
        for (User user : users.values()) {
            if (user.getNickname().equals(nickname) && !user.getUserID().equals(currentUserID)) {
                return true;
            }
        }
        return false;
    }

    // ユーザーIDの重複チェック（自分自身は除外）
    public static boolean isUserIDTaken(String newUserID, String currentUserID) {
        if (newUserID.equals(currentUserID)) {
            return false;
        }
        return users.containsKey(newUserID);
    }
}
