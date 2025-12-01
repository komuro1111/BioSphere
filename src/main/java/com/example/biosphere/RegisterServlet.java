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

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String nickname = request.getParameter("nickname");
        
        // 共通処理を使用
        String userID = UserValidationUtils.formatUserID(request.getParameter("userID"));
        String pass = request.getParameter("pass");

        // 共通バリデーションを使用
        // 新規登録なのでパスワードは必須。空チェックもUtils側あるいはここで行う必要がありますが
        // Utils.validatePasswordは空を許容する設定にしたため、ここで必須チェックを追加しても良いでしょう
        if (pass == null || pass.isEmpty()) {
             request.setAttribute("registerError", "パスワードを入力してください。");
             request.getRequestDispatcher("/index.jsp").forward(request, response);
             return;
        }

        String error = UserValidationUtils.validate(nickname, userID, pass, null);

        if (error != null) {
            request.setAttribute("registerError", error);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

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