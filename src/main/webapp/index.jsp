<%@ page import="com.example.biosphere.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // セッションからユーザー情報を取得
    User currentUser = (User) session.getAttribute("user");
    // エラーメッセージの取得
    String loginError = (String) request.getAttribute("loginError");
    String registerError = (String) request.getAttribute("registerError");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bio-Sphere | AI搭載 生物系総合情報データベース</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'bio-accent': '#84cc16', // lime-500
                        'bio-dark': '#1a1a1a',
                        'bio-card': '#2d2d2d',
                        'bio-danger': '#ef4444',
                        'ai-sparkle': '#d946ef',
                    }
                }
            }
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Noto Sans JP', sans-serif;
            background-color: #1a1a1a; /* bio-dark */
            color: #ffffff;
        }
    </style>
</head>
<body>

<!-- ヘッダーエリア -->
<header class="w-full p-4 bg-bio-card shadow-lg flex justify-between items-center border-b border-gray-700">
    <!-- ロゴエリア -->
    <div class="flex items-center gap-3 ml-4">
        <i class="fa-solid fa-dna text-bio-accent text-3xl"></i>
        <div class="text-2xl font-bold tracking-wide text-white">
            Bio-Sphere <span class="text-xs text-bio-accent font-normal block -mt-1">test</span>
        </div>
    </div>

    <!-- 右上のアクションエリア -->
    <div class="flex gap-4 mr-4">
        <% if (currentUser == null) { %>
            <button onclick="openModal('loginModal')" class="group relative px-6 py-2 font-bold text-bio-dark bg-bio-accent rounded-full overflow-hidden transition-all hover:scale-105 active:scale-95 hover:bg-lime-400 cursor-pointer">
                <span class="relative z-10 flex items-center gap-2">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    ログイン / 新規登録
                </span>
            </button>
        <% } else { %>
            <div class="flex items-center gap-4">
                <span class="text-white font-bold">ようこそ、<%= currentUser.getNickname() %> さん</span>
                <a href="logout" class="text-sm text-gray-400 hover:text-white">ログアウト</a>
            </div>
        <% } %>
    </div>
</header>

<!-- メインコンテンツ -->
<main class="container mx-auto mt-10 p-6 text-center">
    <h1 class="text-4xl font-bold mb-4 text-white">Bio-Sphere</h1>

    <!-- ... existing code ... -->
</main>

<!-- ログインモーダル -->
<div id="loginModal" class="fixed inset-0 z-50 hidden flex items-center justify-center">
    <div class="absolute inset-0 bg-black bg-opacity-90 backdrop-blur-sm" onclick="closeModal('loginModal')"></div>
    <div class="relative bg-[#121212] w-full max-w-md p-8 rounded-xl shadow-2xl border border-gray-800 transform transition-all scale-100">
        <button onclick="closeModal('loginModal')" class="absolute top-4 right-4 text-gray-400 hover:text-white transition-colors">
            <i class="fa-solid fa-xmark text-xl"></i>
        </button>

        <h2 class="text-2xl font-bold text-white text-center mb-8 tracking-wide">ログイン</h2>

        <% if (loginError != null) { %>
            <div class="bg-red-900/50 border border-red-500 text-red-200 px-4 py-3 rounded mb-6 text-sm">
                <i class="fa-solid fa-circle-exclamation mr-2"></i><%= loginError %>
            </div>
        <% } %>

        <form action="login" method="post" class="space-y-6">
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">ユーザーID</label>
                <input type="text" name="userID"
                       class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors placeholder-gray-600"
                       placeholder="demouser">
            </div>
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">パスワード</label>
                <input type="password" name="pass"
                       class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors placeholder-gray-600"
                       placeholder="••••••••">
            </div>
            <button type="submit"
                    class="w-full bg-bio-accent hover:bg-lime-500 text-bio-dark font-bold py-3 rounded transition-all transform hover:scale-[1.01] active:scale-[0.99] mt-2">
                ログイン
            </button>
        </form>

        <div class="mt-6 text-center">
            <button onclick="switchToRegister()" class="text-bio-accent hover:text-lime-400 text-xs font-medium transition-colors hover:underline">
                新規会員登録
            </button>
        </div>
    </div>
</div>

<!-- 新規登録モーダル -->
<div id="registerModal" class="fixed inset-0 z-50 hidden flex items-center justify-center">
    <div class="absolute inset-0 bg-black bg-opacity-90 backdrop-blur-sm" onclick="closeModal('registerModal')"></div>
    <div class="relative bg-[#121212] w-full max-w-md p-8 rounded-xl shadow-2xl border border-gray-800 transform transition-all scale-100">
        <button onclick="closeModal('registerModal')" class="absolute top-4 right-4 text-gray-400 hover:text-white transition-colors">
            <i class="fa-solid fa-xmark text-xl"></i>
        </button>

        <h2 class="text-2xl font-bold text-white text-center mb-8 tracking-wide">新規会員登録</h2>

        <% if (registerError != null) { %>
        <div class="bg-red-900/50 border border-red-500 text-red-200 px-4 py-3 rounded mb-6 text-sm">
            <i class="fa-solid fa-circle-exclamation mr-2"></i><%= registerError %>
        </div>
        <% } %>

        <form action="register" method="post" class="space-y-6">
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">ニックネーム</label>
                <input type="text" name="nickname" required
                       class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors placeholder-gray-600">
            </div>
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">ユーザーID</label>
                <input type="text" name="userID" required
                       class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors placeholder-gray-600">
            </div>
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">パスワード</label>
                <input type="password" name="pass" required
                       class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors placeholder-gray-600">
            </div>
            <button type="submit"
                    class="w-full bg-bio-accent hover:bg-lime-500 text-bio-dark font-bold py-3 rounded transition-all transform hover:scale-[1.01] active:scale-[0.99] mt-2">
                登録してログイン
            </button>
        </form>

        <div class="mt-6 text-center">
            <button onclick="switchToLogin()" class="text-bio-accent hover:text-lime-400 text-xs font-medium transition-colors hover:underline">
                ログイン画面に戻る
            </button>
        </div>
    </div>
</div>

<script>
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
    }
    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }
    function switchToRegister() {
        closeModal('loginModal');
        openModal('registerModal');
    }
    function switchToLogin() {
        closeModal('registerModal');
        openModal('loginModal');
    }

    // サーバーサイドからのエラーがある場合に自動でモーダルを開く
    window.onload = function() {
        <% if (loginError != null) { %>
            openModal('loginModal');
        <% } else if (registerError != null) { %>
            openModal('registerModal');
        <% } %>
    }
</script>

</body>
</html>