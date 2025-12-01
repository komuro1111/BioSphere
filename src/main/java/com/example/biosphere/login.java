package com.example.biosphere;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "loginServlet", value = "/login")
public class login extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // GETリクエストが来た場合はトップページへ転送
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // フォームから受け取ったIDに@を自動付与
        String userID = UserValidationUtils.formatUserID(request.getParameter("userID"));
        String pass = request.getParameter("pass");

        User user = UserRepository.findByUserID(userID);

        if (user != null && user.getPassword().equals(pass)) {
            // ログイン成功
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            // トップページへリダイレクト（リロード時の二重送信防止のためリダイレクト推奨）
            response.sendRedirect("index.jsp");
        } else {
            // ログイン失敗
            request.setAttribute("loginError", "ユーザーIDまたはパスワードが間違っています");
            // エラー情報を持ってトップページへ戻る
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}