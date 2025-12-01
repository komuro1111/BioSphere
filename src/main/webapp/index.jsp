<%@ page import="com.example.biosphere.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String loginError = (String) request.getAttribute("loginError");
    String registerError = (String) request.getAttribute("registerError");
    // 設定画面のエラー取得
    String settingsError = (String) request.getAttribute("settingsError");

    // 背景スタイルの決定
    String bodyStyle = "background-color: #1a1a1a;"; // デフォルト
    if (currentUser != null) {
        if ("image".equals(currentUser.getBackgroundType()) && currentUser.getBackgroundImagePath() != null && !currentUser.getBackgroundImagePath().isEmpty()) {
            // 画像の場合はパスを指定
            bodyStyle = "background-image: url('" + request.getContextPath() + "/uploads/" + currentUser.getBackgroundImagePath() + "'); background-size: cover; background-attachment: fixed; background-position: center;";
        } else if ("color".equals(currentUser.getBackgroundType()) && currentUser.getBackgroundColor() != null) {
            // 単色の場合は色を指定
            bodyStyle = "background-color: " + currentUser.getBackgroundColor() + ";";
        }
    }
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
                        'bio-accent': '#84cc16',
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
            /* background-color: #1a1a1a;  <-- ここを削除または上書き */
            color: #ffffff;
            transition: background-color 0.5s ease; /* 色変更時のアニメーション */
        }
        /* チェックボックスのトグルデザイン用 */
        .toggle-checkbox:checked {
            right: 0;
            border-color: #84cc16;
        }
        .toggle-checkbox:checked + .toggle-label {
            background-color: #84cc16;
        }



    </style>
</head>
<%-- bodyタグにスタイルを適用 --%>
<body style="<%= bodyStyle %>" class="flex flex-col min-h-screen"><%-- flex Flexboxコンテナにする　flex-col　縦方向に並べる　min-h-screen　screen	最小高さを画面全体に設定--%>

<!-- ヘッダーエリア -->
<header class="w-full p-4 bg-bio-card shadow-lg flex justify-between items-center border-b border-gray-700">
    <div class="flex items-center gap-3 ml-4">
        <a href="#" onclick="resetHome()" class="flex items-center gap-2 group cursor-pointer">   <!-- homeに戻る関数後で作る -->
            <i class="fa-solid fa-earth-asia text-3xl text-bio-accent group-hover:rotate-12 transition"></i>
            <div class="flex flex-col">
                <span class="text-2xl font-bold tracking-wider">Bio-Sphere</span>
                <span class="text-xs text-gray-400">生物系総合ナレッジベース</span>
            </div>
        </a>
    </div>

    <div class="flex gap-4 mr-4">
        <% if (currentUser == null) { %>
        <button onclick="openModal('loginModal')" class="group relative px-6 py-2 font-bold text-bio-dark bg-bio-accent rounded-full overflow-hidden transition-all hover:scale-105 active:scale-95 hover:bg-lime-400 cursor-pointer">
                <span class="relative z-10 flex items-center gap-2">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    ログイン / 新規登録
                </span>
        </button>
        <% } else { %>
        <div class="flex items-center">
            <!-- 設定アイコン (クリックでモーダルを開く) -->
            <button onclick="openModal('settingsModal')" class="text-gray-400 hover:text-white transition-colors mr-6">
                <i class="fa-solid fa-gear text-xl"></i>
            </button>

            <div class="flex items-center gap-3 mr-6">
                <div class="w-10 h-10 rounded-full bg-[#3f3f46] flex items-center justify-center text-gray-300">
                    <i class="fa-solid fa-user text-lg"></i>
                </div>
                <!-- ニックネーム表示 -->
                <span class="text-bio-accent font-bold text-xl"><%= currentUser.getNickname() %></span>
            </div>

            <a href="logout" class="px-5 py-1.5 border border-gray-600 rounded-md text-gray-300 hover:text-white hover:border-gray-400 text-sm transition-colors">
                ログアウト
            </a>
        </div>
        <% } %>
    </div>

</header>

<!-- メインコンテンツ -->
<main class="container mx-auto mt-10 p-6 text-center **flex-grow**"> <!-- flex-grow   <body>内で残っているすべての空きスペースをこの要素（メインコンテンツ）が占有するようにし、<footer>を強制的に最下部まで押し出す-->

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
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <span class="text-gray-500 font-bold">@</span>
                    </div>
                    <input type="text" name="userID"
                               class="w-full bg-[#262626] text-white border border-[#333333] rounded pl-10 pr-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors placeholder-gray-600"
                               placeholder="demouser">
                </div>
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
            <!-- ユーザーID入力欄の変更 (新規登録) -->
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">ユーザーID (半角英数字)</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <span class="text-gray-500 font-bold">@</span>
                    </div>
                    <input type="text" name="userID" required
                           class="w-full bg-[#262626] text-white border border-[#333333] rounded pl-10 pr-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors placeholder-gray-600"
                           placeholder="user123">
                </div>
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

<!-- アカウント設定モーダル -->
<div id="settingsModal" class="fixed inset-0 z-50 hidden flex items-center justify-center">
    <div class="absolute inset-0 bg-black bg-opacity-90 backdrop-blur-sm" onclick="closeModal('settingsModal')"></div>
    <div class="relative bg-[#121212] w-full max-w-md p-8 rounded-xl shadow-2xl border border-gray-800 transform transition-all scale-100">
        <button onclick="closeModal('settingsModal')" class="absolute top-4 right-4 text-gray-400 hover:text-white transition-colors">
            <i class="fa-solid fa-xmark text-xl"></i>
        </button>

        <h2 class="text-2xl font-bold text-white text-center mb-8 tracking-wide">アカウント設定</h2>

        <% if (settingsError != null) { %>
        <div class="bg-red-900/50 border border-red-500 text-red-200 px-4 py-3 rounded mb-6 text-sm">
            <i class="fa-solid fa-circle-exclamation mr-2"></i><%= settingsError %>
        </div>
        <% } %>

        <% if (currentUser != null) { %>
        <!-- enctypeを追加してファイルアップロードに対応 -->
        <form action="update-profile" method="post" enctype="multipart/form-data" class="space-y-6">
            <!-- ニックネーム -->
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">ニックネーム (日本語・英語・数字 20文字以内)</label>
                <input type="text" name="nickname" value="<%= currentUser.getNickname() %>" required
                       class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors">
            </div>

            <!-- ユーザーID入力欄の変更 (設定変更) -->
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">ユーザーID (半角英数字 20文字以内)</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <span class="text-gray-500 font-bold">@</span>
                    </div>
                    <%
                        // 既存のIDから@を取り除いて表示用にする処理
                        String displayID = currentUser.getUserID();
                        if (displayID != null && displayID.startsWith("@")) {
                            displayID = displayID.substring(1);
                        }
                    %>
                    <input type="text" name="userID" value="<%= displayID %>" required
                           class="w-full bg-[#262626] text-white border border-[#333333] rounded pl-10 pr-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors">
                </div>
            </div>

            <!-- 新しいパスワード -->
            <div>
                <label class="block text-gray-400 text-xs font-bold mb-2">新しいパスワード</label>
                <input type="password" name="pass"
                       class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors"
                       placeholder="変更しない場合は空欄">
            </div>

            <!-- 背景設定エリアの追加 -->
            <div class="border-t border-gray-700 pt-4 mt-2">
                <h3 class="text-sm font-bold text-gray-300 mb-3">壁紙 (背景設定)</h3>
                
                <!-- タイプ選択 -->
                <div class="flex gap-6 mb-4">
                    <label class="flex items-center gap-2 cursor-pointer group">
                        <input type="radio" name="backgroundType" value="color" 
                               <%= (currentUser.getBackgroundType() == null || "color".equals(currentUser.getBackgroundType())) ? "checked" : "" %>
                               onclick="toggleBackgroundSettings('color')"
                               class="text-bio-accent focus:ring-bio-accent bg-[#262626] border-gray-600">
                        <span class="text-sm text-gray-400 group-hover:text-white transition-colors">単色カラー</span>
                    </label>
                    <label class="flex items-center gap-2 cursor-pointer group">
                        <input type="radio" name="backgroundType" value="image" 
                               <%= "image".equals(currentUser.getBackgroundType()) ? "checked" : "" %>
                               onclick="toggleBackgroundSettings('image')"
                               class="text-bio-accent focus:ring-bio-accent bg-[#262626] border-gray-600">
                        <span class="text-sm text-gray-400 group-hover:text-white transition-colors">画像アップロード</span>
                    </label>
                </div>

                <!-- カラー選択パレット -->
                <div id="colorSettings" class="<%= "image".equals(currentUser.getBackgroundType()) ? "hidden" : "" %>">
                    <div class="flex gap-3 flex-wrap">
                        <% 
                        String[] presetColors = {"#1a1a1a", "#0f172a", "#14532d", "#312e81", "#4c0519", "#000000"}; 
                        for(String c : presetColors) { 
                        %>
                        <label class="cursor-pointer relative w-8 h-8 rounded-full border-2 border-gray-600 hover:border-white transition-colors shadow-md" style="background-color: <%= c %>;">
                            <input type="radio" name="backgroundColor" value="<%= c %>" class="opacity-0 absolute inset-0 w-full h-full cursor-pointer" 
                                   <%= c.equals(currentUser.getBackgroundColor()) ? "checked" : "" %>>
                            <!-- 選択時にチェックマークを表示するなどの装飾が可能 -->
                        </label>
                        <% } %>
                    </div>
                </div>

                <!-- 画像アップロードフォーム -->
                <div id="imageSettings" class="<%= "image".equals(currentUser.getBackgroundType()) ? "" : "hidden" %>">
                    <input type="file" name="backgroundImage" accept="image/*" class="block w-full text-xs text-gray-400
                        file:mr-4 file:py-2 file:px-4
                        file:rounded-full file:border-0
                        file:text-xs file:font-semibold
                        file:bg-[#333] file:text-white
                        hover:file:bg-bio-accent hover:file:text-bio-dark
                        cursor-pointer file:cursor-pointer file:transition-colors
                    "/>
                    <p class="text-xs text-gray-500 mt-2">※ jpeg, png, gif 形式のみ</p>
                </div>
            </div>

            <button type="submit"
                    class="w-full bg-bio-accent hover:bg-lime-500 text-bio-dark font-bold py-3 rounded transition-all transform hover:scale-[1.01] active:scale-[0.99] mt-2">
                設定を保存
            </button>
        </form>
        <% } %>
    </div>
</div>

<footer class="bg-black text-gray-400 py-12 border-t border-gray-800 mt-auto">
    <div class="container mx-auto px-4 grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
        <div class="col-span-1 md:col-span-1"><h3 class="text-white text-lg font-bold mb-4 flex items-center gap-2"><i class="fa-solid fa-earth-asia text-bio-accent"></i> Bio-Sphere</h3><p class="text-sm leading-relaxed mb-4">地球上のあらゆる生命の記録を集積するナレッジベース。</p></div>
        <div><h4 class="text-white font-bold mb-4 border-b border-gray-700 pb-2 inline-block">コンテンツ</h4><ul class="space-y-2 text-sm"><li><a href="#" class="hover:text-bio-accent">最新ニュース</a></li><li><a href="#" class="hover:text-bio-accent">生物図鑑</a></li><li><a href="#" class="hover:text-bio-accent">論文検索</a></li></ul></div>
        <div><h4 class="text-white font-bold mb-4 border-b border-gray-700 pb-2 inline-block">コミュニティ</h4><ul class="space-y-2 text-sm"><li><a href="#" class="hover:text-bio-accent">新規登録</a></li><li><a href="#" class="hover:text-bio-accent">お問い合わせ</a></li></ul></div>
        <div><h4 class="text-white font-bold mb-4 border-b border-gray-700 pb-2 inline-block">運営</h4><div class="flex gap-4"><a href="#" class="text-xl hover:text-white"><i class="fa-brands fa-x-twitter"></i></a><a href="#" class="text-xl hover:text-white"><i class="fa-brands fa-instagram"></i></a></div></div>
    </div>
    <div class="border-t border-gray-800 pt-8 text-center text-xs text-gray-500"><p>&copy; 2024 Bio-Sphere Project.</p></div>
</footer>

<script>
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
    }
    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }
    
    // 背景設定の切り替え用スクリプト
    function toggleBackgroundSettings(type) {
        const colorSettings = document.getElementById('colorSettings');
        const imageSettings = document.getElementById('imageSettings');
        
        if (type === 'color') {
            colorSettings.classList.remove('hidden');
            imageSettings.classList.add('hidden');
        } else {
            colorSettings.classList.add('hidden');
            imageSettings.classList.remove('hidden');
        }
    }

    function switchToRegister() {
        closeModal('loginModal');
        openModal('registerModal');
    }
    function switchToLogin() {
        closeModal('registerModal');
        openModal('loginModal');
    }

    // サーバーサイドからのエラーがある場合に自動で対応するモーダルを開く
    window.onload = function() {
        <% if (loginError != null) { %>
        openModal('loginModal');
        <% } else if (registerError != null) { %>
        openModal('registerModal');
        <% } else if (settingsError != null) { %>
        openModal('settingsModal');
        <% } %>
    }

    // ESCキーで閉じる
    document.addEventListener('keydown', function(event) {
        if (event.key === "Escape") {
            closeModal('loginModal');
            closeModal('registerModal');
            closeModal('settingsModal');
        }
    });
</script>

</body>
</html>