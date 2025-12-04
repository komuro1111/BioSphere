package com.example.biosphere.utils;

import com.example.biosphere.repository.UserRepository;

import java.util.regex.Pattern;

public class UserValidationUtils {

    // ニックネーム: 日本語、英語、数字、20文字以内
    private static final String NICKNAME_PATTERN = "^[a-zA-Z0-9\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF]{1,20}$";
    // ユーザーID: @で始まり、英数字のみ、合計20文字以内 (例: @user123)
    private static final String USERID_PATTERN = "^@[a-zA-Z0-9]{1,19}$";
    // パスワード: 英数字のみ、20文字以内
    private static final String PASSWORD_PATTERN = "^[a-zA-Z0-9]{1,20}$";

    /**
     * ユーザーIDに@が付いていない場合、先頭に付与して返します。
     */
    public static String formatUserID(String userID) {
        if (userID != null && !userID.startsWith("@")) {
            return "@" + userID;
        }
        return userID;
    }

    /**
     * パスワードの形式チェックを行います。
     * @param password パスワード
     * @return エラーメッセージ (正常な場合はnull)
     */
    public static String validatePassword(String password) {
        if (password == null || password.isEmpty()) {
            return null; // 空の場合はチェックしない（更新時など）
        }
        if (!Pattern.matches(PASSWORD_PATTERN, password)) {
            return "パスワードは半角英数字20文字以内で入力してください。認められていない文字が含まれています。";
        }
        return null;
    }

    /**
     * ユーザー情報のバリデーションを行います。
     * @param nickname ニックネーム
     * @param userID ユーザーID (整形済み)
     * @param password パスワード (新規登録時は必須、更新時は任意)
     * @param currentUserID 現在のユーザーID (新規登録時はnull)
     * @return エラーメッセージ (エラーがない場合はnull)
     */
    public static String validate(String nickname, String userID, String password, String currentUserID) {
        // 1. 書式チェック
        if (nickname == null || !Pattern.matches(NICKNAME_PATTERN, nickname)) {
            return "ニックネームは日本語・英語・数字で20文字以内で入力してください。";
        }
        
        // ユーザーIDの文字種・長さチェック
        // @を除いた部分が1文字以上19文字以下であること、かつ英数字のみであることをチェック
        if (userID == null || !Pattern.matches(USERID_PATTERN, userID)) {
            return "ユーザーIDは半角英数字20文字以内で入力してください。認められていない文字が含まれています。";
        }

        // パスワードチェック
        String passError = validatePassword(password);
        if (passError != null) {
            return passError;
        }

        // 2. 重複チェック
        if (UserRepository.isNicknameTaken(nickname, currentUserID)) {
            return "そのニックネームは既に使用されています。";
        }
        if (UserRepository.isUserIDTaken(userID, currentUserID)) {
            return "そのユーザーIDは既に使用されています。";
        }

        return null;
    }
}