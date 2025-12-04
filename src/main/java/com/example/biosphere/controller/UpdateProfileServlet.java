package com.example.biosphere.controller;

import java.io.*;
import java.nio.file.Paths;
// Patternのインポートは不要になります
import com.example.biosphere.model.User;
import com.example.biosphere.repository.UserRepository;
import com.example.biosphere.utils.UserValidationUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "updateProfileServlet", value = "/update-profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class UpdateProfileServlet extends HttpServlet {

    // 定数定義を削除

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String newNickname = request.getParameter("nickname");
        String currentUserID = currentUser.getUserID();

        // 共通処理を使用: IDのフォーマット
        String newUserID = UserValidationUtils.formatUserID(request.getParameter("userID"));

        String newPassword = request.getParameter("pass");

        // 背景設定の取得
        String backgroundType = request.getParameter("backgroundType");
        String backgroundColor = request.getParameter("backgroundColor");

        // 共通処理を使用: バリデーション (パスワード引数を追加)
        String error = UserValidationUtils.validate(newNickname, newUserID, newPassword, currentUserID);

        if (error != null) {
            // エラーがある場合、設定画面を開いたままエラーを表示
            request.setAttribute("settingsError", error);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // --- 更新処理 ---

        // パスワードが入力されている場合のみ更新（空欄なら変更なし）
        if (newPassword != null && !newPassword.isEmpty()) {
            currentUser.setPassword(newPassword);
        }

        // 背景設定の更新処理
        if (backgroundType != null) {
            currentUser.setBackgroundType(backgroundType);

            if ("color".equals(backgroundType)) {
                if (backgroundColor != null) {
                    currentUser.setBackgroundColor(backgroundColor);
                }
            } else if ("image".equals(backgroundType)) {
                try {
                    Part filePart = request.getPart("backgroundImage");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        // ファイル名の衝突を防ぐためにタイムスタンプを付与
                        String safeFileName = System.currentTimeMillis() + "_" + fileName;

                        // 保存先ディレクトリ (webapp/uploads)
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdir();
                        }

                        filePart.write(uploadPath + File.separator + safeFileName);
                        currentUser.setBackgroundImagePath(safeFileName);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    // 必要であればログ出力など
                }
            }
        }

        // リポジトリ更新
        UserRepository.update(currentUserID, currentUser);

        // セッション情報の更新（参照は同じだが念のため）
        session.setAttribute("user", currentUser);

        // 完了してリダイレクト
        response.sendRedirect("index.jsp");
    }
}