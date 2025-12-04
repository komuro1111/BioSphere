<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.biosphere.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ブログ作成 | Bio-Sphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 'bio-accent': '#84cc16', 'bio-dark': '#1a1a1a', 'bio-card': '#2d2d2d' }
                }
            }
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans JP', sans-serif; background-color: #1a1a1a; color: #ffffff; }

        /* エディタ風のスタイル */
        #editor {
            min-height: 400px;
            outline: none;
            overflow-y: auto;
        }
        #editor img {
            cursor: pointer;
            transition: 0.2s;
            max-width: 100%; /* はみ出し防止 */
        }
        #editor img:hover {
            outline: 2px solid #84cc16; /* ホバー時に枠線 */
        }
        #editor img.selected {
            outline: 3px solid #84cc16;
            box-shadow: 0 0 10px rgba(132, 204, 22, 0.5);
        }

        /* 画像設定ポップアップ */
        #image-settings-popup {
            transition: opacity 0.2s, transform 0.2s;
        }
    </style>
</head>
<body class="bg-bio-dark min-h-screen flex flex-col items-center py-10">

<div class="w-full max-w-4xl flex justify-between items-center mb-6 px-4">
    <h1 class="text-2xl font-bold flex items-center gap-2">
        <i class="fa-solid fa-pen-nib text-bio-accent"></i> ブログ作成
    </h1>
    <a href="index.jsp" class="text-gray-400 hover:text-white transition-colors">
        <i class="fa-solid fa-xmark"></i> キャンセル
    </a>
</div>

<form action="create-post" method="post" enctype="multipart/form-data" class="w-full max-w-4xl bg-[#1e1e1e] p-8 rounded-xl shadow-2xl border border-gray-800" onsubmit="prepareSubmission()">

    <div class="mb-6">
        <label class="block text-gray-400 text-xs font-bold mb-2">タイトル</label>
        <input type="text" name="title" required placeholder="記事のタイトルを入力"
               class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors">
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
        <div>
            <label class="block text-gray-400 text-xs font-bold mb-2">分類</label>
            <div class="relative">
                <select name="category" class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 appearance-none focus:outline-none focus:border-bio-accent">
                    <option value="animal">動物</option>
                    <option value="reptile">爬虫類</option>
                    <option value="aquatic">水生生物</option>
                    <option value="plant">植物</option>
                    <option value="fossil">古生物・化石</option>
                    <option value="insect">昆虫</option>
                    <option value="microbe">微生物</option>
                    <option value="other">その他</option>
                </select>
            </div>
        </div>
        <div>
            <label class="block text-gray-400 text-xs font-bold mb-2">一覧用サムネイル画像</label>
            <input type="file" name="image" accept="image/*" class="w-full text-xs text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-full file:bg-[#333] file:text-white cursor-pointer"/>
        </div>
    </div>

    <div class="mb-8 relative">
        <label class="block text-gray-400 text-xs font-bold mb-2">本文</label>

        <div class="flex gap-2 mb-2 bg-[#262626] p-2 rounded border border-[#333]">
            <button type="button" onclick="execCmd('bold')" class="p-2 text-gray-400 hover:text-white" title="太字"><i class="fa-solid fa-bold"></i></button>
            <button type="button" onclick="execCmd('italic')" class="p-2 text-gray-400 hover:text-white" title="斜体"><i class="fa-solid fa-italic"></i></button>
            <button type="button" onclick="triggerBodyImageUpload()" class="p-2 text-gray-400 hover:text-white" title="本文に画像を挿入"><i class="fa-regular fa-image"></i> 画像挿入</button>
            <input type="file" id="body-image-input" class="hidden" accept="image/*" onchange="insertBodyImage(this)">
        </div>

        <div id="editor" contenteditable="true"
             class="w-full bg-[#262626] text-white border border-[#333333] rounded px-4 py-3 focus:outline-none focus:border-bio-accent focus:ring-1 focus:ring-bio-accent transition-colors leading-relaxed"
             placeholder="ここに記事を入力..."></div>

        <input type="hidden" name="content" id="hidden-content">
    </div>

    <div class="flex justify-center">
        <button type="submit" class="bg-bio-accent hover:bg-lime-500 text-bio-dark font-bold py-4 px-12 rounded-full shadow-lg transform transition hover:scale-105 active:scale-95 flex items-center gap-2 text-lg">
            <i class="fa-solid fa-paper-plane"></i> 投稿する
        </button>
    </div>
</form>

<div id="image-settings-popup" class="hidden absolute z-50 bg-white text-gray-800 p-4 rounded-lg shadow-xl border border-gray-300 w-72">
    <h3 class="text-sm font-bold border-b pb-2 mb-3 text-gray-600">画像設定</h3>

    <div class="mb-4">
        <label class="block text-xs font-bold text-gray-500 mb-1">サイズ (幅 px)</label>
        <div class="flex gap-2">
            <input type="number" id="img-width" class="border p-1 w-20 rounded text-sm" placeholder="600">
            <button type="button" onclick="applySize('small')" class="text-xs bg-gray-200 px-2 py-1 rounded hover:bg-gray-300">小</button>
            <button type="button" onclick="applySize('medium')" class="text-xs bg-gray-200 px-2 py-1 rounded hover:bg-gray-300">中</button>
            <button type="button" onclick="applySize('original')" class="text-xs bg-gray-200 px-2 py-1 rounded hover:bg-gray-300">原寸</button>
        </div>
    </div>

    <div class="mb-4">
        <label class="block text-xs font-bold text-gray-500 mb-1">貼り付け位置</label>
        <div class="flex justify-between bg-gray-100 p-1 rounded">
            <button type="button" onclick="applyAlign('left')" class="p-2 hover:bg-white rounded w-full text-center"><i class="fa-solid fa-align-left"></i></button>
            <button type="button" onclick="applyAlign('center')" class="p-2 hover:bg-white rounded w-full text-center"><i class="fa-solid fa-align-center"></i></button>
            <button type="button" onclick="applyAlign('right')" class="p-2 hover:bg-white rounded w-full text-center"><i class="fa-solid fa-align-right"></i></button>
        </div>
    </div>

    <div class="mb-4">
        <label class="block text-xs font-bold text-gray-500 mb-1">代替テキスト (alt)</label>
        <input type="text" id="img-alt" class="border p-1 w-full rounded text-sm" placeholder="画像の説明">
    </div>

    <div class="text-right">
        <button type="button" onclick="closePopup()" class="text-xs text-gray-400 hover:text-gray-600 mr-2">閉じる</button>
        <button type="button" onclick="updateImageFromPopup()" class="bg-bio-accent text-white px-3 py-1 rounded text-sm font-bold hover:bg-lime-600">反映</button>
    </div>
</div>

<script>
    // 編集機能を有効にする簡易スクリプト
    function execCmd(command) {
        document.execCommand(command, false, null);
        document.getElementById('editor').focus();
    }

    // --- 画像挿入処理 ---
    function triggerBodyImageUpload() {
        document.getElementById('body-image-input').click();
    }

    function insertBodyImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                // カーソル位置に画像を挿入
                document.getElementById('editor').focus();
                // 一旦Base64で挿入 (本格的なアプリではここでAjaxアップロードしてURLをもらうのが一般的)
                const html = `<img src="${e.target.result}" style="max-width:100%; display:block; margin: 10px 0;">`;
                document.execCommand('insertHTML', false, html);
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // --- 画像設定ポップアップ処理 ---
    let currentImg = null; // 現在選択中の画像
    const popup = document.getElementById('image-settings-popup');
    const editor = document.getElementById('editor');

    // エディタ内でクリックしたときの処理
    editor.addEventListener('click', function(e) {
        if (e.target.tagName === 'IMG') {
            // 画像がクリックされたらポップアップ表示
            selectImage(e.target);
        } else {
            // 画像以外ならポップアップを閉じる
            closePopup();
        }
    });

    function selectImage(img) {
        currentImg = img;

        // 既存の選択状態を解除
        document.querySelectorAll('#editor img').forEach(i => i.classList.remove('selected'));
        img.classList.add('selected');

        // ポップアップに入力値をセット
        document.getElementById('img-width').value = img.width;
        document.getElementById('img-alt').value = img.alt;

        // ポップアップの位置調整（画像の右下あたりに表示）
        const rect = img.getBoundingClientRect();
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

        popup.style.top = (rect.bottom + scrollTop + 10) + 'px';
        popup.style.left = (rect.right > window.innerWidth - 300 ? window.innerWidth - 320 : rect.right - 50) + 'px';
        popup.classList.remove('hidden');
    }

    function closePopup() {
        popup.classList.add('hidden');
        if(currentImg) currentImg.classList.remove('selected');
        currentImg = null;
    }

    // ポップアップの操作反映
    function applySize(size) {
        if (!currentImg) return;
        if (size === 'small') currentImg.style.width = '200px';
        if (size === 'medium') currentImg.style.width = '400px';
        if (size === 'original') currentImg.style.width = 'auto';
        document.getElementById('img-width').value = currentImg.width;
    }

    function applyAlign(align) {
        if (!currentImg) return;
        // Tailwindのクラスではなくstyleを直接操作（保存時のため）
        if (align === 'left') {
            currentImg.style.float = 'left';
            currentImg.style.margin = '0 10px 10px 0';
            currentImg.style.display = 'block';
        } else if (align === 'right') {
            currentImg.style.float = 'right';
            currentImg.style.margin = '0 0 10px 10px';
            currentImg.style.display = 'block';
        } else if (align === 'center') {
            currentImg.style.float = 'none';
            currentImg.style.margin = '0 auto 10px auto';
            currentImg.style.display = 'block';
        }
    }

    function updateImageFromPopup() {
        if (!currentImg) return;
        // 幅の手動入力
        const w = document.getElementById('img-width').value;
        if(w) currentImg.style.width = w + 'px';

        // Altテキスト
        currentImg.alt = document.getElementById('img-alt').value;

        closePopup();
    }

    // --- 送信準備 ---
    function prepareSubmission() {
        // contenteditableの中身（HTML）をhidden inputに移す
        const content = document.getElementById('editor').innerHTML;
        document.getElementById('hidden-content').value = content;
    }
</script>
</body>
</html>