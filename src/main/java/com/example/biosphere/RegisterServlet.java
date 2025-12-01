package com.example.biosphere;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "registerServlet", value = "/register")
public class RegisterServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // GETリクエストはトップへ
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8"); // 日本語入力対応
        String userID = request.getParameter("userID");
        String pass = request.getParameter("pass");
        String nickname = request.getParameter("nickname");

        if (UserRepository.exists(userID)) {
            // 登録エラー
            request.setAttribute("registerError", "そのUserIDは既に使用されています");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else {
            // 登録処理
            User newUser = new User(userID, pass, nickname);
            UserRepository.register(newUser);

            // 登録成功後、そのままログイン状態にする
            HttpSession session = request.getSession();
            session.setAttribute("user", newUser);

            // トップページへリダイレクト
            response.sendRedirect("index.jsp");
        }
    }
}