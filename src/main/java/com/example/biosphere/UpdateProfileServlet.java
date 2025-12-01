package com.example.biosphere;

import java.io.*;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "updateProfileServlet", value = "/update-profile")
public class UpdateProfileServlet extends HttpServlet {

    // ニックネーム: 日本語、英語、数字、20文字以内
    private static final String NICKNAME_PATTERN = "^[a-zA-Z0-9\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF]{1,20}$";
    // ユーザーID: @で始まり、英数字のみ、合計20文字以内 (例: @user123)
    private static final String USERID_PATTERN = "^@[a-zA-Z0-9]{1,19}$";

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("index.jsp"); // セッション切れ対応
            return;
        }

        String newNickname = request.getParameter("nickname");
        String newUserID = request.getParameter("userID");
        String newPassword = request.getParameter("pass");
        String currentUserID = currentUser.getUserID();

        // --- バリデーション ---
        String error = null;

        // 1. 書式チェック
        if (newNickname == null || !Pattern.matches(NICKNAME_PATTERN, newNickname)) {
            error = "ニックネームは日本語・英語・数字で20文字以内で入力してください。";
        } else if (newUserID == null || !Pattern.matches(USERID_PATTERN, newUserID)) {
            error = "ユーザーIDは@から始まる半角英数字20文字以内で入力してください。";
        }
        // 2. 重複チェック
        else if (UserRepository.isNicknameTaken(newNickname, currentUserID)) {
            error = "そのニックネームは既に使用されています。";
        } else if (UserRepository.isUserIDTaken(newUserID, currentUserID)) {
            error = "そのユーザーIDは既に使用されています。";
        }

        if (error != null) {
            // エラーがある場合、設定画面を開いたままエラーを表示
            request.setAttribute("settingsError", error);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // --- 更新処理 ---
        currentUser.setNickname(newNickname);
        currentUser.setUserID(newUserID);

        // パスワードが入力されている場合のみ更新（空欄なら変更なし）
        if (newPassword != null && !newPassword.isEmpty()) {
            currentUser.setPassword(newPassword);
        }

        // リポジトリ更新
        UserRepository.update(currentUserID, currentUser);

        // セッション情報の更新（参照は同じだが念のため）
        session.setAttribute("user", currentUser);

        // 完了してリダイレクト
        response.sendRedirect("index.jsp");
    }
}