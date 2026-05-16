/**
 * 罗小黑战记辟谣查询工具 - 多语言支持
 * 版本: 1.0.0
 */

const I18N_DATA = {
    "zh_cn": {
        "app_title": "罗小黑战记辟谣查询",
        "all_categories": "全部分类",
        "search_placeholder": "输入关键词搜索",
        "search": "搜索",
        "loading": "加载中...",
        "select_platform": "选择下载平台",
        "download_windows": "下载Windows版本",
        "download_android": "下载Android版本",
        "download_ios": "下载iOS版本",
        "dark_mode": "深色模式",
        "light_mode": "浅色模式",
        "categories": "分类",
        "no_results": "未找到相关结果",
        "back_to_home": "返回主页",
        "copy_text": "复制文本",
        "view_images": "查看相关图片",
        "export_content": "导出内容",
        "export_word": "导出为Word",
        "export_txt": "导出为TXT",
        "export_success": "导出成功",
        "export_failed": "导出失败",
        "copied": "已复制到剪贴板",
        "image_viewer": "图片查看器",
        "image_count": "{current}/{total}",
        "close": "关闭",
        "previous": "上一张",
        "next": "下一张",
        "share": "分享",
        "select_category": "选择一个分类",
        "click_to_copy": "点击复制",
        "current_version": "当前版本",
        "check_update": "检查更新",
        "new_version": "发现新版本",
        "download_now": "立即下载",
        "latest_version": "已是最新版本",
        "update_check_failed": "检查更新失败",
        "no_images_found": "没有找到相关图片",
        "open_in_browser": "在浏览器中打开",
        "download_client": "下载客户端"
    },
    "zh_tw": {
        "app_title": "羅小黑戰記闢謠查詢",
        "all_categories": "全部類別",
        "search_placeholder": "輸入關鍵詞搜索",
        "search": "搜索",
        "loading": "加載中...",
        "select_platform": "選擇下載平臺",
        "download_windows": "下載Windows版本",
        "download_android": "下載Android版本",
        "download_ios": "下載iOS版本",
        "dark_mode": "深色模式",
        "light_mode": "淺色模式",
        "categories": "類別",
        "no_results": "未找到相關結果",
        "back_to_home": "返回主頁",
        "copy_text": "複製文本",
        "view_images": "查看相關圖片",
        "export_content": "導出內容",
        "export_word": "導出為Word",
        "export_txt": "導出為TXT",
        "export_success": "導出成功",
        "export_failed": "導出失敗",
        "copied": "已複製到剪貼板",
        "image_viewer": "圖片查看器",
        "image_count": "{current}/{total}",
        "close": "關閉",
        "previous": "上一張",
        "next": "下一張",
        "share": "分享",
        "select_category": "選擇一個類別",
        "click_to_copy": "點擊複製",
        "current_version": "當前版本",
        "check_update": "檢查更新",
        "new_version": "發現新版本",
        "download_now": "立即下載",
        "latest_version": "已是最新版本",
        "update_check_failed": "檢查更新失敗",
        "no_images_found": "沒有找到相關圖片",
        "open_in_browser": "在瀏覽器中打開",
        "download_client": "下載客戶端"
    },
    "en_gb": {
        "app_title": "The Legend of Luo Xiaohei Rumor Refutation",
        "all_categories": "All Categories",
        "search_placeholder": "Enter keywords to search",
        "search": "Search",
        "loading": "Loading...",
        "select_platform": "Select Download Platform",
        "download_windows": "Download Windows Version",
        "download_android": "Download Android Version",
        "download_ios": "Download iOS Version",
        "dark_mode": "Dark Mode",
        "light_mode": "Light Mode",
        "categories": "Categories",
        "no_results": "No results found",
        "back_to_home": "Back to Home",
        "copy_text": "Copy Text",
        "view_images": "View Related Images",
        "export_content": "Export Content",
        "export_word": "Export as Word",
        "export_txt": "Export as TXT",
        "export_success": "Export Successful",
        "export_failed": "Export Failed",
        "copied": "Copied to clipboard",
        "image_viewer": "Image Viewer",
        "image_count": "{current}/{total}",
        "close": "Close",
        "previous": "Previous",
        "next": "Next",
        "share": "Share",
        "select_category": "Select a category",
        "click_to_copy": "Click to copy",
        "current_version": "Current Version",
        "check_update": "Check for Updates",
        "new_version": "New Version Found",
        "download_now": "Download Now",
        "latest_version": "Already Latest Version",
        "update_check_failed": "Update Check Failed",
        "no_images_found": "No images found",
        "open_in_browser": "Open in Browser",
        "download_client": "Download Client"
    },
    "ja": {
        "app_title": "羅小黒戦記 噂の真相",
        "all_categories": "全カテゴリー",
        "search_placeholder": "キーワードを入力して検索",
        "search": "検索",
        "loading": "読み込み中...",
        "select_platform": "ダウンロードプラットフォームを選択",
        "download_windows": "Windowsバージョンをダウンロード",
        "download_android": "Androidバージョンをダウンロード",
        "download_ios": "iOSバージョンをダウンロード",
        "dark_mode": "ダークモード",
        "light_mode": "ライトモード",
        "categories": "カテゴリー",
        "no_results": "結果が見つかりません",
        "back_to_home": "ホームに戻る",
        "copy_text": "テキストをコピー",
        "view_images": "関連画像を表示",
        "export_content": "コンテンツをエクスポート",
        "export_word": "Wordとしてエクスポート",
        "export_txt": "TXTとしてエクスポート",
        "export_success": "エクスポート成功",
        "export_failed": "エクスポート失敗",
        "copied": "クリップボードにコピーされました",
        "image_viewer": "画像ビューア",
        "image_count": "{current}/{total}",
        "close": "閉じる",
        "previous": "前へ",
        "next": "次へ",
        "share": "共有",
        "select_category": "カテゴリーを選択",
        "click_to_copy": "クリックしてコピー",
        "current_version": "現在のバージョン",
        "check_update": "更新を確認",
        "new_version": "新バージョンが見つかりました",
        "download_now": "今すぐダウンロード",
        "latest_version": "既に最新バージョン",
        "update_check_failed": "更新の確認に失敗しました",
        "no_images_found": "画像が見つかりません",
        "open_in_browser": "ブラウザで開く",
        "download_client": "クライアントをダウンロード"
    },
    "ko": {
        "app_title": "라오소흑전기 루머 반박",
        "all_categories": "모든 카테고리",
        "search_placeholder": "키워드를 입력하여 검색하세요",
        "search": "검색",
        "loading": "로딩 중...",
        "select_platform": "다운로드 플랫폼 선택",
        "download_windows": "Windows 버전 다운로드",
        "download_android": "Android 버전 다운로드",
        "download_ios": "iOS 버전 다운로드",
        "dark_mode": "다크 모드",
        "light_mode": "라이트 모드",
        "categories": "카테고리",
        "no_results": "결과를 찾을 수 없습니다",
        "back_to_home": "홈으로 돌아가기",
        "copy_text": "텍스트 복사",
        "view_images": "관련 이미지 보기",
        "export_content": "내보내기",
        "export_word": "Word로 내보내기",
        "export_txt": "TXT로 내보내기",
        "export_success": "내보내기 성공",
        "export_failed": "내보내기 실패",
        "copied": "클립보드에 복사되었습니다",
        "image_viewer": "이미지 뷰어",
        "image_count": "{current}/{total}",
        "close": "닫기",
        "previous": "이전",
        "next": "다음",
        "share": "공유",
        "select_category": "카테고리를 선택하세요",
        "click_to_copy": "클릭하여 복사",
        "current_version": "현재 버전",
        "check_update": "업데이트 확인",
        "new_version": "새 버전 발견",
        "download_now": "지금 다운로드",
        "latest_version": "이미 최신 버전",
        "update_check_failed": "업데이트 확인 실패",
        "no_images_found": "이미지를 찾을 수 없습니다",
        "open_in_browser": "브라우저에서 열기",
        "download_client": "클라이언트 다운로드"
    },
    "ru": {
        "app_title": "Оправдание слухов о Ло Сяохэ",
        "all_categories": "Все категории",
        "search_placeholder": "Введите ключевые слова для поиска",
        "search": "Поиск",
        "loading": "Загрузка...",
        "select_platform": "Выберите платформу для загрузки",
        "download_windows": "Скачать версию для Windows",
        "download_android": "Скачать версию для Android",
        "download_ios": "Скачать версию для iOS",
        "dark_mode": "Тёмный режим",
        "light_mode": "Светлый режим",
        "categories": "Категории",
        "no_results": "Результаты не найдены",
        "back_to_home": "Вернуться на главную",
        "copy_text": "Копировать текст",
        "view_images": "Просмотреть связанные изображения",
        "export_content": "Экспорт содержимого",
        "export_word": "Экспорт в Word",
        "export_txt": "Экспорт в TXT",
        "export_success": "Экспорт успешен",
        "export_failed": "Экспорт не удался",
        "copied": "Скопировано в буфер обмена",
        "image_viewer": "Просмотр изображений",
        "image_count": "{current}/{total}",
        "close": "Закрыть",
        "previous": "Предыдущее",
        "next": "Следующее",
        "share": "Поделиться",
        "select_category": "Выберите категорию",
        "click_to_copy": "Нажмите, чтобы скопировать",
        "current_version": "Текущая версия",
        "check_update": "Проверить обновления",
        "new_version": "Обнаружена новая версия",
        "download_now": "Скачать сейчас",
        "latest_version": "У вас уже последняя версия",
        "update_check_failed": "Не удалось проверить обновления",
        "no_images_found": "Изображения не найдены",
        "open_in_browser": "Открыть в браузере",
        "download_client": "Скачать клиент"
    }
};

class I18n {
    constructor() {
        this.currentLang = 'zh_cn';
        this.init();
    }

    init() {
        const savedLang = localStorage.getItem('lxhpy_language');
        if (savedLang && I18N_DATA[savedLang]) {
            this.currentLang = savedLang;
        } else {
            const browserLang = navigator.language || navigator.userLanguage;
            if (browserLang.startsWith('zh-TW') || browserLang.startsWith('zh_TW')) {
                this.currentLang = 'zh_tw';
            } else if (browserLang.startsWith('ja')) {
                this.currentLang = 'ja';
            } else if (browserLang.startsWith('ko')) {
                this.currentLang = 'ko';
            } else if (browserLang.startsWith('ru')) {
                this.currentLang = 'ru';
            } else if (browserLang.startsWith('en')) {
                this.currentLang = 'en_gb';
            } else {
                this.currentLang = 'zh_cn';
            }
        }
        
        this.applyLanguage();
    }

    setLanguage(lang) {
        if (I18N_DATA[lang]) {
            this.currentLang = lang;
            localStorage.setItem('lxhpy_language', lang);
            this.applyLanguage();
        }
    }

    t(key, params = {}) {
        const text = I18N_DATA[this.currentLang][key] || I18N_DATA['zh_cn'][key] || key;
        
        let result = text;
        Object.keys(params).forEach(param => {
            result = result.replace(`{${param}}`, params[param]);
        });
        
        return result;
    }

    applyLanguage() {
        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            el.textContent = this.t(key);
        });

        document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
            const key = el.getAttribute('data-i18n-placeholder');
            el.placeholder = this.t(key);
        });

        document.querySelectorAll('[data-i18n-title]').forEach(el => {
            const key = el.getAttribute('data-i18n-title');
            el.setAttribute('title', this.t(key));
        });

        document.title = this.t('app_title');
        
        const htmlLang = this.currentLang.replace('_', '-');
        document.documentElement.lang = htmlLang;

        document.dispatchEvent(new CustomEvent('languageChanged', {
            detail: { language: this.currentLang }
        }));
    }
}

const i18n = new I18n();
