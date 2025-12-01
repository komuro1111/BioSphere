package com.example.biosphere;

import java.util.ArrayList;
import java.util.List;

public class UserRepository {
    // ユーザーリストをメモリ上で管理（DBの代わり）
    private static final List<User> users = new ArrayList<>();

    // 静的初期化ブロックでテストユーザーを追加
    static {
        // UserIDはシステム上 @test となるように登録します
        // ログイン時は入力欄に "test" と入れると、内部で "@test" に変換されマッチします
        users.add(new User("@test", "test", "テストユーザー"));
    }

    // ユーザー登録
    public static void register(User user) {
        users.add(user);
    }

    // IDでユーザー検索
    public static User findByUserID(String userID) {
        for (User user : users) {
            if (user.getUserID().equals(userID)) {
                return user;
            }
        }
        return null;
    }

    // ID重複チェック
    public static boolean exists(String userID) {
        return findByUserID(userID) != null;
    }

    // ニックネーム重複チェック (自分以外)
    public static boolean isNicknameTaken(String nickname, String currentUserID) {
        for (User user : users) {
            if (user.getNickname().equals(nickname)) {
                // currentUserIDがnull（新規登録時）か、別のIDの場合のみtrue
                if (currentUserID == null || !user.getUserID().equals(currentUserID)) {
                    return true;
                }
            }
        }
        return false;
    }

    // ID重複チェック (自分以外 - 更新時用)
    public static boolean isUserIDTaken(String userID, String currentUserID) {
        for (User user : users) {
            if (user.getUserID().equals(userID)) {
                if (currentUserID == null || !user.getUserID().equals(currentUserID)) {
                    return true;
                }
            }
        }
        return false;
    }

    // ユーザー情報更新
    public static void update(String currentUserID, User updatedUser) {
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserID().equals(currentUserID)) {
                users.set(i, updatedUser);
                return;
            }
        }
    }
}