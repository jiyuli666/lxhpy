/**
 * 罗小黑战记辟谣查询工具 - 重构版主程序
 */

(function() {
    'use strict';

    // ==================== 状态管理 ====================
    const state = {
        RUMOR_DATA: null,
        flatItems: [],
        darkMode: false,
        lastSearchResults: [],
        lastKeyword: '',
        currentImageIndex: 0,
        currentImages: [],
        isSearching: false,
        typewriterTimer: null
    };

    // ==================== DOM 引用缓存 ====================
    const $ = (id) => document.getElementById(id);
    const $$ = (sel, ctx = document) => ctx.querySelectorAll(sel);

    const els = {};

    // ==================== 图片映射（兼容原数据） ====================
    const IMAGE_MAPPING = {
        "弃养谣言（\"从小养的奶猫丢到野外\"\"吃猫血馒头\"）": ["弃养谣言.jpg", "弃养谣言2.jpg", "弃养谣言3.jpg", "弃养谣言4.jpg", "弃养谣言5.jpg", "弃养谣言6.JPG"],
        "二次丢猫谣言（\"小黑跑回家后被开车丢到燕郊\"）": ["二次丢猫谣言.jpg"],
        "小黑原型的真实经历与性格": ["小黑原型的真实经历与性格.jpg"],
        "政治立场谣言（亲日、辱华、侮辱红军/烈士等）": ["政治立场谣言.PNG", "政治立场谣言2.jpg", "政治立场谣言3.jpg", "政治立场谣言4.jpg"],
        "荤段子及辱女、恋童癖谣言": ["荤段子及辱女、恋童癖谣言.jpg"],
        "性别相关谣言（《灵魂之旅》辱女）": ["性别相关谣言.jpg"],
        "主动下场、不站队引战谣言": ["主动下场、不站队引战谣言.jpg"],
        "歌词篡改谣言（侮辱红军、恶搞《十送红军》）": ["歌词篡改谣言.jpg"],
        "黑神话事件牵连谣言（性别歧视、洗白）": ["黑神话事件牵连谣言.jpg"],
        "色图争议（\"画色图就该接受性骚扰\"）": ["色图争议.jpg"],
        "中外粉丝态度不一、亲近日本谣言": ["中外粉丝态度不一、亲近日本谣言.jpg", "中外粉丝态度不一、亲近日本谣言2.JPG"],
        "粉丝网暴、开盒、泼油漆谣言": ["粉丝网暴、开盒谣言.jpg", "粉丝网暴、开盒谣言2.jpg"],
        "关于顾杰编剧分工和\"老登\"的谣言": ["关于顾杰编剧分工和\"老登\"的谣言.jpg"],
        "关于鹿野角色创作的谣言": ["关于鹿野角色创作的谣言.jpg"],
        "外网918更新谣言": ["外网918更新谣言.JPG"],
        "更新不认真、频繁请假谣言": ["更新不认真、频繁请假谣言.jpg"],
        "抄袭谣言（抄袭《酷猫小黑的生活日记》《鬼灭之刃》）": ["抄袭谣言.JPG"],
        "催更者死诅咒谣言": ["催更者死诅咒谣言.jpg"],
        "靠IP圈钱、不重视作品谣言": ["靠IP圈钱、不重视作品谣言.jpg"],
        "12人公司一年500场官司\"版权流氓\"谣言": ["12人公司1年500官司.jpg"],
        "更新慢谣言（\"公司忙着打官司不认真更新\"\"年更只为圈钱\"）": ["更新慢谣言.jpg", "更新慢谣言2.jpg"],
        "黑神话悟空性别歧视牵连谣言": ["黑神话事件牵连谣言.jpg"]
    };

    // 按文章顺序排列的图片列表（与 RUMOR_DATA_ALL 各语言条目顺序一致）
    const IMAGE_LIST = [
        ["弃养谣言.jpg", "弃养谣言2.jpg", "弃养谣言3.jpg", "弃养谣言4.jpg", "弃养谣言5.jpg", "弃养谣言6.JPG"],
        ["二次丢猫谣言.jpg"],
        ["小黑原型的真实经历与性格.jpg"],
        ["政治立场谣言.PNG", "政治立场谣言2.jpg", "政治立场谣言3.jpg", "政治立场谣言4.jpg"],
        ["荤段子及辱女、恋童癖谣言.jpg"],
        ["性别相关谣言.jpg"],
        ["主动下场、不站队引战谣言.jpg"],
        ["歌词篡改谣言.jpg"],
        ["黑神话事件牵连谣言.jpg"],
        ["色图争议.jpg"],
        ["中外粉丝态度不一、亲近日本谣言.jpg", "中外粉丝态度不一、亲近日本谣言2.JPG"],
        ["抄袭谣言.JPG"],
        ["更新慢谣言.jpg", "更新慢谣言2.jpg"],
        ["催更者死诅咒谣言.jpg"],
        ["12人公司1年500官司.jpg"],
        ["靠IP圈钱、不重视作品谣言.jpg"],
        ["外网918更新谣言.JPG"],
        ["更新不认真、频繁请假谣言.jpg"],
        ["黑神话事件牵连谣言.jpg"],
        ["粉丝网暴、开盒谣言.jpg", "粉丝网暴、开盒谣言2.jpg"],
        ["关于顾杰编剧分工和\"老登\"的谣言.jpg"],
        ["关于鹿野角色创作的谣言.jpg"]
    ];

    // ==================== 初始化 ====================
    function init() {
        cacheElements();
        loadRumorData(getCurrentLang());
        loadUserSettings();
        initEventListeners();
        initCanvasBackground();
        buildSidebar();
        typeWriterTitle();
        showHome();

        document.addEventListener('languageChanged', onLanguageChanged);
    }

    function cacheElements() {
        const ids = [
            'appToolbar', 'darkModeBtn', 'categoryBtn', 'languageSelect', 'downloadBtn',
            'overlay', 'sidebar', 'closeSidebar', 'categoryContainer',
            'searchInput', 'searchBtn', 'searchClear', 'searchHistory', 'searchBox',
            'heroSection', 'heroTitle', 'heroSubtitle',
            'resultSection', 'resultBox', 'resultMeta', 'backHomeBtn',
            'contentArea',
            'downloadModal', 'closeModal', 'downloadWindows', 'downloadAndroid', 'addIOS',
            'imageViewer', 'viewerImage', 'prevBtn', 'nextBtn', 'closeViewerBtn', 'imageCount',
            'toast', 'backToTop', 'bgCanvas'
        ];
        ids.forEach(id => els[id] = $(id));
    }

    // ==================== 数据加载 ====================
    function loadRumorData(lang) {
        if (!lang) lang = 'zh_cn';
        if (typeof RUMOR_DATA_ALL !== 'undefined' && RUMOR_DATA_ALL[lang]) {
            state.RUMOR_DATA = RUMOR_DATA_ALL[lang];
        } else if (typeof RUMOR_DATA_ALL !== 'undefined' && RUMOR_DATA_ALL['zh_cn']) {
            state.RUMOR_DATA = RUMOR_DATA_ALL['zh_cn'];
        } else {
            state.RUMOR_DATA = {};
        }

        flattenData();
    }

    function flattenData() {
        state.flatItems = [];
        if (!state.RUMOR_DATA) return;
        for (const category in state.RUMOR_DATA) {
            for (const title in state.RUMOR_DATA[category]) {
                state.flatItems.push({
                    category,
                    title,
                    content: state.RUMOR_DATA[category][title]
                });
            }
        }
    }

    function getCurrentLang() {
        return (typeof i18n !== 'undefined' && i18n.currentLang) ? i18n.currentLang : 'zh_cn';
    }

    function t(key, params = {}) {
        if (typeof i18n !== 'undefined' && i18n.t) {
            return i18n.t(key, params);
        }
        const fallbacks = {
            'search_placeholder': '输入关键词搜索',
            'back_to_home': '返回主页',
            'copy_text': '复制文本',
            'copied': '已复制',
            'view_images': '查看相关图片',
            'no_results': '未找到相关结果',
            'no_images_found': '没有找到相关图片',
            'image_count': '{current}/{total}',
            'download_client': '下载客户端',
            'select_platform': '选择下载平台',
            'download_windows': '下载Windows版本',
            'download_android': '下载Android版本',
            'download_ios': '下载iOS版本',
            'open_in_browser': '在浏览器中打开',
            'all_categories': '全部分类'
        };
        let text = fallbacks[key] || key;
        Object.keys(params).forEach(p => text = text.replace(`{${p}}`, params[p]));
        return text;
    }

    // ==================== 用户设置 ====================
    function loadUserSettings() {
        const savedDark = localStorage.getItem('lxhpy_darkMode_v2') === 'true';
        if (savedDark) setDarkMode(true);
        els.languageSelect.value = getCurrentLang();
    }

    function saveUserSettings() {
        localStorage.setItem('lxhpy_darkMode_v2', state.darkMode);
    }

    // ==================== 深色模式 ====================
    function setDarkMode(isDark) {
        state.darkMode = isDark;
        document.body.classList.toggle('dark-mode', isDark);
        saveUserSettings();
    }

    function toggleDarkMode() {
        setDarkMode(!state.darkMode);
    }

    // ==================== 多语言切换 ====================
    function onLanguageChanged(e) {
        const lang = e.detail.language;
        loadRumorData(lang);
        buildSidebar();
        typeWriterTitle();
        showHome();
        els.languageSelect.value = lang;
    }

    // ==================== 标题打字机效果 ====================
    function typeWriterTitle() {
        const el = els.heroTitle;
        const text = t('app_title');
        if (state.typewriterTimer) clearInterval(state.typewriterTimer);
        el.textContent = '';
        let i = 0;
        state.typewriterTimer = setInterval(() => {
            el.textContent += text.charAt(i);
            i++;
            if (i >= text.length) clearInterval(state.typewriterTimer);
        }, 45);
    }

    // ==================== 侧边栏 ====================
    function toggleSidebar(show) {
        const isVisible = els.sidebar.classList.contains('visible');
        const next = show === undefined ? !isVisible : !!show;
        els.sidebar.classList.toggle('visible', next);
        els.overlay.classList.toggle('visible', next);
        els.sidebar.setAttribute('aria-hidden', !next);
    }

    function buildSidebar() {
        els.categoryContainer.innerHTML = '';
        if (!state.RUMOR_DATA) return;

        for (const cat in state.RUMOR_DATA) {
            const group = document.createElement('div');
            group.className = 'category-group';
            group.dataset.cat = cat;

            const item = document.createElement('div');
            item.className = 'category-item';
            item.textContent = cat;
            item.addEventListener('click', () => group.classList.toggle('open'));

            const list = document.createElement('ul');
            list.className = 'subcategory-list';

            for (const title in state.RUMOR_DATA[cat]) {
                const li = document.createElement('li');
                li.className = 'subcategory-item';
                li.textContent = title;
                li.dataset.title = title;
                li.addEventListener('click', () => {
                    state.lastSearchResults = [];
                    state.lastKeyword = '';
                    showDetail(title, state.RUMOR_DATA[cat][title]);
                    toggleSidebar(false);
                });
                list.appendChild(li);
            }

            group.appendChild(item);
            group.appendChild(list);
            els.categoryContainer.appendChild(group);
        }
    }

    // ==================== 搜索 ====================
    function updateSearchClear() {
        const hasValue = els.searchInput.value.trim().length > 0;
        els.searchClear.classList.toggle('visible', hasValue);
    }

    function clearSearchInput() {
        els.searchInput.value = '';
        updateSearchClear();
        hideSearchHistory();
        showHome();
    }

    function loadSearchHistory() {
        try {
            return JSON.parse(localStorage.getItem('lxhpy_searchHistory_v2') || '[]');
        } catch {
            return [];
        }
    }

    function saveSearchHistory(keyword) {
        const history = loadSearchHistory().filter(k => k !== keyword);
        history.unshift(keyword);
        localStorage.setItem('lxhpy_searchHistory_v2', JSON.stringify(history.slice(0, 10)));
    }

    function showSearchHistory() {
        const history = loadSearchHistory();
        const val = els.searchInput.value.trim();
        const filtered = history.filter(h => h !== val);
        if (filtered.length === 0) {
            hideSearchHistory();
            return;
        }
        els.searchHistory.innerHTML = '';
        filtered.forEach(item => {
            const div = document.createElement('div');
            div.className = 'history-item';
            div.textContent = item;
            div.addEventListener('mousedown', (e) => {
                e.preventDefault();
                els.searchInput.value = item;
                updateSearchClear();
                hideSearchHistory();
                performSearch();
            });
            els.searchHistory.appendChild(div);
        });
        els.searchHistory.classList.add('visible');
    }

    function hideSearchHistory() {
        els.searchHistory.classList.remove('visible');
    }

    function performSearch() {
        const keyword = els.searchInput.value.trim();
        if (!keyword) {
            showHome();
            return;
        }
        saveSearchHistory(keyword);
        hideSearchHistory();
        updateSearchClear();

        state.isSearching = true;
        els.resultBox.innerHTML = `
            <div class="loading-wrap">
                <div class="spinner"></div>
                <span>${t('loading')}</span>
            </div>
        `;
        showSearchMode();

        setTimeout(() => {
            const kw = keyword.toLowerCase();
            const results = state.flatItems.filter(item =>
                item.title.toLowerCase().includes(kw) ||
                item.content.toLowerCase().includes(kw)
            );
            state.isSearching = false;
            showSearchResults(results, keyword);
        }, 0);
    }

    // ==================== 视图切换 ====================
    function showHome() {
        els.heroSection.classList.remove('hidden');
        els.resultSection.classList.remove('active');
        els.searchInput.value = '';
        updateSearchClear();
        hideSearchHistory();
        state.lastSearchResults = [];
        state.lastKeyword = '';
        els.resultMeta.innerHTML = '';
        els.contentArea.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function showSearchMode() {
        els.heroSection.classList.add('hidden');
        els.resultSection.classList.add('active');
    }

    function showSearchResults(results, keyword) {
        state.lastSearchResults = results;
        state.lastKeyword = keyword;
        showSearchMode();
        els.contentArea.scrollTo({ top: 0, behavior: 'auto' });
        els.resultBox.innerHTML = '';

        els.resultMeta.innerHTML = results.length
            ? `${t('search')}: <strong>${escapeHtml(keyword)}</strong> · ${results.length}${t('no_results').includes('未找到') ? ' 条结果' : ' results'}`
            : '';

        if (!results.length) {
            els.resultBox.innerHTML = `
                <div class="empty-tip">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M15.5 14h-.79l-.28-.27a6.5 6.5 0 001.48-5.34c-.47-2.78-2.79-5-5.59-5.34a6.505 6.505 0 00-7.27 7.27c.34 2.8 2.56 5.12 5.34 5.59a6.5 6.5 0 005.34-1.48l.27.28v.79l4.25 4.25c.41.41 1.08.41 1.49 0 .41-.41.41-1.08 0-1.49L15.5 14zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                    <div>${t('no_results').replace('{keyword}', escapeHtml(keyword))}</div>
                </div>
            `;
            return;
        }

        results.forEach((item, i) => {
            const div = document.createElement('div');
            div.className = 'list-item';
            div.style.animationDelay = `${i * 0.05}s`;
            div.innerHTML = `
                <div class="list-item-title">${highlightText(escapeHtml(item.title), keyword)}</div>
                <span class="list-item-cat">${escapeHtml(item.category)}</span>
            `;
            div.addEventListener('click', () => showDetail(item.title, item.content));
            els.resultBox.appendChild(div);
        });
    }

    function showDetail(title, content) {
        showSearchMode();
        els.resultBox.innerHTML = '';
        els.resultMeta.innerHTML = '';
        const images = findImageMapping(title);
        const hasImages = images && images.length > 0;

        const detail = document.createElement('div');
        detail.className = 'detail-page';
        detail.innerHTML = `
            <div class="detail-title">${escapeHtml(title)}</div>
            <div class="detail-content">${formatContent(content)}</div>
            <div class="action-bar">
                <button class="btn btn-ghost" id="btnBack">${t('back_to_home')}</button>
                <button class="btn btn-success" id="btnCopy">${t('copy_text')}</button>
                ${hasImages ? `<button class="btn btn-secondary" id="btnImages">${t('view_images')}</button>` : ''}
            </div>
        `;
        els.resultBox.appendChild(detail);
        els.contentArea.scrollTo({ top: 0, behavior: 'smooth' });

        $('btnBack').addEventListener('click', () => {
            if (state.lastSearchResults.length) {
                showSearchResults(state.lastSearchResults, state.lastKeyword);
            } else {
                showHome();
            }
        });

        $('btnCopy').addEventListener('click', function() {
            navigator.clipboard.writeText(content).then(() => {
                showToast(t('copied'));
                this.textContent = t('copied');
                setTimeout(() => this.textContent = t('copy_text'), 1500);
            });
        });

        if (hasImages) {
            $('btnImages').addEventListener('click', () => showImageViewer(images));
        }
    }

    function formatContent(text) {
        return escapeHtml(text).replace(/\n/g, '<br>');
    }

    function escapeHtml(str) {
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function highlightText(text, keyword) {
        if (!keyword) return text;
        const regex = new RegExp(`(${escapeRegExp(keyword)})`, 'gi');
        return text.replace(regex, '<mark>$1</mark>');
    }

    function escapeRegExp(str) {
        return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }

    // ==================== 图片查看器 ====================
    function findImageMapping(title) {
        // 优先使用中文完整标题精确匹配
        if (IMAGE_MAPPING[title]) {
            return IMAGE_MAPPING[title];
        }
        // 其他语言按当前语言数据中的顺序索引匹配
        const idx = state.flatItems.findIndex(item => item.title === title);
        if (idx >= 0 && idx < IMAGE_LIST.length) {
            return IMAGE_LIST[idx];
        }
        return null;
    }

    function showImageViewer(images) {
        if (!images || images.length === 0) {
            showToast(t('no_images_found'));
            return;
        }
        state.currentImages = images;
        state.currentImageIndex = 0;
        els.imageViewer.classList.add('visible');
        document.body.style.overflow = 'hidden';
        loadCurrentImage();
    }

    function closeImageViewer() {
        els.imageViewer.classList.remove('visible');
        document.body.style.overflow = '';
        els.viewerImage.classList.remove('loaded');
        els.viewerImage.src = '';
    }

    function loadCurrentImage() {
        const name = state.currentImages[state.currentImageIndex];
        els.viewerImage.classList.remove('loaded');
        els.viewerImage.src = `images/${name}`;
        els.imageCount.textContent = t('image_count', {
            current: state.currentImageIndex + 1,
            total: state.currentImages.length
        });
    }

    function showPrevImage() {
        if (state.currentImageIndex > 0) {
            state.currentImageIndex--;
            loadCurrentImage();
        }
    }

    function showNextImage() {
        if (state.currentImageIndex < state.currentImages.length - 1) {
            state.currentImageIndex++;
            loadCurrentImage();
        }
    }

    // ==================== 下载弹窗 ====================
    function showDownloadModal() {
        els.downloadModal.classList.add('show');
    }

    function hideDownloadModal() {
        els.downloadModal.classList.remove('show');
    }

    function downloadWindowsVersion() {
        triggerDownload('https://github.com/jiyuli666/lxhpy/releases/download/lxh/LuoXiaoHeiChecker-1.5.2-win64.exe', 'LuoXiaoHeiChecker-1.5.2-win64.exe');
        hideDownloadModal();
    }

    function downloadAndroidVersion() {
        triggerDownload('https://github.com/jiyuli666/lxhpy/releases/download/lxh/lxhpy.apk', 'lxhpy.apk');
        hideDownloadModal();
    }

    function downloadIOSVersion() {
        triggerDownload('https://github.com/jiyuli666/lxhpy/releases/download/lxh/LuoXiaoHei.ipa', 'LuoXiaoHei.ipa');
        hideDownloadModal();
    }

    function triggerDownload(url, filename) {
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
    }

    // ==================== Toast ====================
    let toastTimer = null;
    function showToast(message) {
        els.toast.textContent = message;
        els.toast.classList.add('show');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(() => els.toast.classList.remove('show'), 2500);
    }

    // ==================== 返回顶部 ====================
    function updateBackToTop() {
        const scrolled = els.contentArea.scrollTop > 300;
        els.backToTop.classList.toggle('visible', scrolled);
    }

    // ==================== 事件监听 ====================
    function initEventListeners() {
        els.darkModeBtn.addEventListener('click', toggleDarkMode);
        els.categoryBtn.addEventListener('click', () => toggleSidebar());
        els.closeSidebar.addEventListener('click', () => toggleSidebar(false));
        els.overlay.addEventListener('click', () => toggleSidebar(false));
        els.backHomeBtn.addEventListener('click', showHome);

        els.languageSelect.addEventListener('change', (e) => {
            if (typeof i18n !== 'undefined') i18n.setLanguage(e.target.value);
        });

        els.downloadBtn.addEventListener('click', showDownloadModal);
        els.closeModal.addEventListener('click', hideDownloadModal);
        els.downloadWindows.addEventListener('click', downloadWindowsVersion);
        els.downloadAndroid.addEventListener('click', downloadAndroidVersion);
        els.addIOS.addEventListener('click', downloadIOSVersion);

        els.searchBtn.addEventListener('click', performSearch);
        els.searchInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                hideSearchHistory();
                performSearch();
            }
        });
        els.searchInput.addEventListener('input', () => {
            updateSearchClear();
            if (els.searchInput.value.trim()) showSearchHistory();
            else hideSearchHistory();
        });
        els.searchInput.addEventListener('focus', () => {
            if (els.searchInput.value.trim()) showSearchHistory();
        });
        els.searchInput.addEventListener('blur', () => {
            setTimeout(hideSearchHistory, 200);
        });
        els.searchClear.addEventListener('click', clearSearchInput);

        els.prevBtn.addEventListener('click', showPrevImage);
        els.nextBtn.addEventListener('click', showNextImage);
        els.closeViewerBtn.addEventListener('click', closeImageViewer);
        els.imageViewer.addEventListener('click', (e) => {
            if (e.target === els.imageViewer || e.target.classList.contains('image-viewer-backdrop')) {
                closeImageViewer();
            }
        });
        els.viewerImage.addEventListener('load', () => els.viewerImage.classList.add('loaded'));

        els.backToTop.addEventListener('click', () => {
            els.contentArea.scrollTo({ top: 0, behavior: 'smooth' });
        });

        els.contentArea.addEventListener('scroll', updateBackToTop, { passive: true });

        // 点击侧边栏外部关闭侧边栏（overlay 已设为 pointer-events:none）
        document.addEventListener('click', (e) => {
            if (!els.sidebar.classList.contains('visible')) return;
            if (els.sidebar.contains(e.target)) return;
            if (els.categoryBtn.contains(e.target)) return;
            toggleSidebar(false);
        });

        document.addEventListener('keydown', (e) => {
            if (els.imageViewer.classList.contains('visible')) {
                if (e.key === 'ArrowLeft') showPrevImage();
                else if (e.key === 'ArrowRight') showNextImage();
                else if (e.key === 'Escape') closeImageViewer();
            } else if (e.key === 'Escape') {
                if (els.downloadModal.classList.contains('show')) hideDownloadModal();
                else if (els.sidebar.classList.contains('visible')) toggleSidebar(false);
                else showHome();
            }
        });

        // 全局点击涟漪
        document.addEventListener('click', (e) => {
            const btn = e.target.closest('.toolbar-btn, .btn, .list-item, .subcategory-item');
            if (!btn) return;
            createRipple(e, btn);
        });
    }

    function createRipple(e, el) {
        const rect = el.getBoundingClientRect();
        const ripple = document.createElement('span');
        const size = Math.max(rect.width, rect.height);
        ripple.style.cssText = `
            position: absolute;
            left: ${e.clientX - rect.left - size / 2}px;
            top: ${e.clientY - rect.top - size / 2}px;
            width: ${size}px;
            height: ${size}px;
            border-radius: 50%;
            background: rgba(33, 150, 243, 0.18);
            transform: scale(0);
            animation: rippleEffect 0.55s ease-out;
            pointer-events: none;
        `;
        el.appendChild(ripple);
        setTimeout(() => ripple.remove(), 600);
    }

    // 注入涟漪动画关键帧
    const style = document.createElement('style');
    style.textContent = `
        @keyframes rippleEffect {
            to { transform: scale(2.5); opacity: 0; }
        }
    `;
    document.head.appendChild(style);

    // ==================== Canvas 粒子背景 ====================
    function initCanvasBackground() {
        const canvas = els.bgCanvas;
        const ctx = canvas.getContext('2d');
        let width, height;
        let particles = [];
        let animationId;
        let isActive = true;

        function resize() {
            width = window.innerWidth;
            height = window.innerHeight;
            canvas.width = width * window.devicePixelRatio;
            canvas.height = height * window.devicePixelRatio;
            ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
            createParticles();
        }

        function createParticles() {
            const isMobile = width < 768;
            const density = isMobile ? 32000 : 18000;
            const maxCount = isMobile ? 30 : 70;
            const count = Math.min(Math.floor((width * height) / density), maxCount);
            particles = [];
            for (let i = 0; i < count; i++) {
                particles.push({
                    x: Math.random() * width,
                    y: Math.random() * height,
                    vx: (Math.random() - 0.5) * 0.6,
                    vy: (Math.random() - 0.5) * 0.6,
                    radius: Math.random() * 2.5 + 1,
                    alpha: Math.random() * 0.4 + 0.2
                });
            }
        }

        function draw() {
            if (!isActive) return;
            ctx.clearRect(0, 0, width, height);
            const isDark = state.darkMode;
            const colorBase = isDark ? '160, 180, 220' : '33, 150, 243';

            for (let i = 0; i < particles.length; i++) {
                const p = particles[i];
                p.x += p.vx;
                p.y += p.vy;

                if (p.x < 0 || p.x > width) p.vx *= -1;
                if (p.y < 0 || p.y > height) p.vy *= -1;

                ctx.beginPath();
                ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
                ctx.fillStyle = `rgba(${colorBase}, ${p.alpha})`;
                ctx.fill();

                for (let j = i + 1; j < particles.length; j++) {
                    const q = particles[j];
                    const dx = p.x - q.x;
                    const dy = p.y - q.y;
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist < 130) {
                        ctx.beginPath();
                        ctx.moveTo(p.x, p.y);
                        ctx.lineTo(q.x, q.y);
                        ctx.strokeStyle = `rgba(${colorBase}, ${0.12 * (1 - dist / 130)})`;
                        ctx.lineWidth = 0.8;
                        ctx.stroke();
                    }
                }
            }
            animationId = requestAnimationFrame(draw);
        }

        window.addEventListener('resize', resize, { passive: true });
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                isActive = false;
                cancelAnimationFrame(animationId);
            } else {
                isActive = true;
                draw();
            }
        });

        resize();
        draw();
    }

    // ==================== 启动 ====================
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
