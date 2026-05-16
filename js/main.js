/**
 * 罗小黑战记辟谣查询工具 - JavaScript主文件
 * 版本: 1.0.2
 * 更新时间: 2026-05-17
 */

(function() {
    // 全局变量
    let RUMOR_DATA = null;
    let flatItems = [];
    let darkMode = false;
    let lastSearchResults = [];
    let lastKeyword = '';
    
    // 图片查看器相关变量
    let currentImageIndex = 0;
    let currentImages = [];
    
    // DOM元素缓存
    const elements = {};
    
    // ---------- 初始化 ----------
    async function init() {
        // 初始化DOM元素引用
        initElements();
        
        // 先等待i18n初始化完成，然后加载对应语言的数据
        if (typeof i18n !== 'undefined' && i18n.currentLang) {
            loadRumorData(i18n.currentLang);
        } else {
            loadRumorData('zh_cn');
        }
        
        // 加载用户设置
        loadUserSettings();
        
        // 初始化事件监听
        initEventListeners();
        
        // 构建侧边栏
        buildSidebar();
        
        // 语言改变时更新UI
        document.addEventListener('languageChanged', (e) => {
            const lang = e.detail.language;
            loadRumorData(lang);
            buildSidebar();
            showHome();
        });
        
        // 显示主页
        showHome();
    }
    
    // 初始化DOM元素引用
    function initElements() {
        elements.darkModeBtn = document.getElementById('darkModeBtn');
        elements.downloadBtn = document.getElementById('downloadBtn');
        elements.categoryBtn = document.getElementById('categoryBtn');
        elements.sidebar = document.getElementById('sidebar');
        elements.overlay = document.getElementById('overlay');
        elements.categoryContainer = document.getElementById('categoryContainer');
        elements.searchInput = document.getElementById('searchInput');
        elements.searchBtn = document.getElementById('searchBtn');
        elements.resultBox = document.getElementById('resultBox');
        elements.bigTitle = document.getElementById('bigTitle');
        elements.centerWrapper = document.getElementById('centerWrapper');
        elements.loading = document.getElementById('loading');
        elements.downloadModal = document.getElementById('downloadModal');
        elements.closeModal = document.getElementById('closeModal');
        elements.downloadWindows = document.getElementById('downloadWindows');
        elements.downloadAndroid = document.getElementById('downloadAndroid');
        elements.addIOS = document.getElementById('addIOS');
        
        // 图片查看器元素
        elements.imageViewer = document.getElementById('imageViewer');
        elements.viewerImage = document.getElementById('viewerImage');
        elements.prevBtn = document.getElementById('prevBtn');
        elements.nextBtn = document.getElementById('nextBtn');
        elements.closeViewerBtn = document.getElementById('closeViewerBtn');
        elements.imageCount = document.getElementById('imageCount');
        
        // 创建搜索历史容器
        createSearchHistoryContainer();
    }
    
    // 加载辟谣数据
    function loadRumorData(lang) {
        if (!lang) lang = 'zh_cn';
        if (typeof RUMOR_DATA_ALL !== 'undefined' && RUMOR_DATA_ALL[lang]) {
            RUMOR_DATA = RUMOR_DATA_ALL[lang];
        } else if (typeof RUMOR_DATA_ALL !== 'undefined' && RUMOR_DATA_ALL['zh_cn']) {
            // 回退到中文
            RUMOR_DATA = RUMOR_DATA_ALL['zh_cn'];
        } else {
            // 兜底的初始化数据
            RUMOR_DATA = {};
        }
        // 展平数据用于搜索
        flatItems = [];
        if (RUMOR_DATA) {
            for (const category in RUMOR_DATA) {
                for (const title in RUMOR_DATA[category]) {
                    flatItems.push({
                        category,
                        title,
                        content: RUMOR_DATA[category][title]
                    });
                }
            }
        }
        console.log('辟谣数据加载成功', lang);
    }
    
    // 图片映射数据 - 使用中文键名保持兼容性
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
        "粉丝网暴、开盒谣言": ["粉丝网暴、开盒谣言.jpg", "粉丝网暴、开盒谣言2.jpg"],
        "关于顾杰编剧分工和\"老登\"的谣言": ["关于顾杰编剧分工和\"老登\"的谣言.jpg"],
        "关于鹿野角色创作的谣言": ["关于鹿野角色创作的谣言.jpg"],
        "外网918更新谣言": ["外网918更新谣言.JPG"],
        "更新不认真、频繁请假谣言": ["更新不认真、频繁请假谣言.jpg"],
        "抄袭谣言（抄袭《酷猫小黑的生活日记》）": ["抄袭谣言.JPG"],
        "催更者死诅咒谣言": ["催更者死诅咒谣言.jpg"],
        "靠IP圈钱、不重视作品谣言": ["靠IP圈钱、不重视作品谣言.jpg"],
        "12人公司一年500场官司\"版权流氓\"谣言": ["12人公司1年500官司.jpg"],
        "更新慢谣言（\"公司忙着打官司不认真更新\"\"年更只为圈钱\"）": ["更新慢谣言.jpg", "更新慢谣言2.jpg"]
    };
    
    // 加载图片（直接加载非加密图片）
    async function loadEncryptedImage(imgName) {
        try {
            const imgPath = `images/${imgName}`;
            return imgPath;
        } catch (error) {
            console.error("Error loading image:", error);
            return null;
        }
    }
    
    // 显示图片查看器（使用自定义查看器）
    function showImageViewer(images) {
        if (!images || images.length === 0) {
            alert(typeof i18n !== 'undefined' ? i18n.t('no_images_found') : '没有找到相关图片');
            return;
        }
        
        currentImages = images;
        currentImageIndex = 0;
        elements.imageViewer.classList.add('visible');
        loadCurrentImage();
    }
    
    // 关闭图片查看器
    function closeImageViewer() {
        elements.imageViewer.classList.remove('visible');
        if (elements.viewerImage.src) {
            URL.revokeObjectURL(elements.viewerImage.src);
            elements.viewerImage.src = '';
        }
    }
    
    // 加载当前图片
    async function loadCurrentImage() {
        if (currentImageIndex >= 0 && currentImageIndex < currentImages.length) {
            const imageUrl = await loadEncryptedImage(currentImages[currentImageIndex]);
            if (imageUrl) {
                elements.viewerImage.src = imageUrl;
                if (typeof i18n !== 'undefined') {
                    elements.imageCount.textContent = i18n.t('image_count', {
                        current: currentImageIndex + 1,
                        total: currentImages.length
                    });
                } else {
                    elements.imageCount.textContent = `${currentImageIndex + 1}/${currentImages.length}`;
                }
            }
        }
    }
    
    // 显示上一张图片
    function showPrevImage() {
        if (currentImageIndex > 0) {
            currentImageIndex--;
            loadCurrentImage();
        }
    }
    
    // 显示下一张图片
    function showNextImage() {
        if (currentImageIndex < currentImages.length - 1) {
            currentImageIndex++;
            loadCurrentImage();
        }
    }
    
    // 加载用户设置
    function loadUserSettings() {
        const savedDarkMode = localStorage.getItem('darkMode') === 'true';
        if (savedDarkMode) {
            toggleDarkMode();
        }
        loadSearchHistory();
    }
    
    // 保存用户设置
    function saveUserSettings() {
        localStorage.setItem('darkMode', darkMode);
    }
    
    // ---------- 深色模式 ----------
    function toggleDarkMode() {
        darkMode = !darkMode;
        document.body.classList.toggle('dark-mode', darkMode);
        if (typeof i18n !== 'undefined') {
            elements.darkModeBtn.textContent = darkMode ? i18n.t('light_mode') : i18n.t('dark_mode');
        }
        saveUserSettings();
    }
    
    // ---------- 搜索历史记录 ----------
    function createSearchHistoryContainer() {
        const historyContainer = document.createElement('div');
        historyContainer.id = 'searchHistory';
        historyContainer.className = 'search-history';
        elements.searchInput.parentNode.appendChild(historyContainer);
        elements.searchHistory = historyContainer;
    }
    
    function loadSearchHistory() {
        return JSON.parse(localStorage.getItem('searchHistory') || '[]');
    }
    
    function saveSearchHistory(keyword) {
        const history = loadSearchHistory();
        const filteredHistory = history.filter(item => item !== keyword);
        filteredHistory.unshift(keyword);
        const trimmedHistory = filteredHistory.slice(0, 10);
        localStorage.setItem('searchHistory', JSON.stringify(trimmedHistory));
    }
    
    function showSearchHistory() {
        const history = loadSearchHistory();
        if (history.length === 0) {
            elements.searchHistory.style.display = 'none';
            return;
        }
        elements.searchHistory.innerHTML = '';
        history.forEach(item => {
            const div = document.createElement('div');
            div.className = 'history-item';
            div.textContent = item;
            div.addEventListener('click', () => {
                elements.searchInput.value = item;
                performSearch();
                elements.searchHistory.style.display = 'none';
            });
            elements.searchHistory.appendChild(div);
        });
        elements.searchHistory.style.display = 'block';
    }
    
    function hideSearchHistory() {
        elements.searchHistory.style.display = 'none';
    }
    
    // ---------- 侧边栏 ----------
    function toggleSidebar(show) {
        if (show === undefined) {
            elements.sidebar.classList.toggle('visible');
            elements.overlay.classList.toggle('visible');
        } else if (show) {
            elements.sidebar.classList.add('visible');
            elements.overlay.classList.add('visible');
        } else {
            elements.sidebar.classList.remove('visible');
            elements.overlay.classList.remove('visible');
        }
    }
    
    function buildSidebar() {
        elements.categoryContainer.innerHTML = '';
        if (!RUMOR_DATA) return;
        
        for (const cat in RUMOR_DATA) {
            const catDiv = document.createElement('div');
            catDiv.className = 'category-item';
            catDiv.textContent = cat;
            catDiv.addEventListener('click', (e) => {
                e.stopPropagation();
                catDiv.classList.toggle('open');
            });
            elements.categoryContainer.appendChild(catDiv);
            
            const subUl = document.createElement('ul');
            subUl.className = 'subcategory-list';
            for (const title in RUMOR_DATA[cat]) {
                const li = document.createElement('li');
                li.className = 'subcategory-item';
                li.textContent = title;
                li.addEventListener('click', (e) => {
                    e.stopPropagation();
                    showDetail(title, RUMOR_DATA[cat][title]);
                    toggleSidebar(false);
                });
                subUl.appendChild(li);
            }
            elements.categoryContainer.appendChild(subUl);
        }
    }
    
    // ---------- 主界面切换 ----------
    function showHome() {
        elements.bigTitle.style.display = 'block';
        elements.resultBox.style.display = 'none';
        elements.centerWrapper.style.flex = '1';
        lastSearchResults = [];
        lastKeyword = '';
    }
    
    function showSearchMode() {
        elements.bigTitle.style.display = 'none';
        elements.resultBox.style.display = 'block';
        elements.centerWrapper.style.flex = '0';
    }
    
    function clearResult() {
        elements.resultBox.innerHTML = '';
    }
    
    function showSearchResults(results, keyword) {
        lastSearchResults = results;
        lastKeyword = keyword;
        showSearchMode();
        clearResult();
        
        if (!results.length) {
            const msg = typeof i18n !== 'undefined' ? i18n.t('no_results').replace('{keyword}', keyword) : `未找到 \"${keyword}\" 相关的内容`;
            elements.resultBox.innerHTML = `<div class="empty-tip">${msg}</div>`;
            return;
        }
        
        const homeBtn = document.createElement('button');
        homeBtn.className = 'btn btn-home';
        homeBtn.textContent = typeof i18n !== 'undefined' ? i18n.t('back_to_home') : '返回主页';
        homeBtn.style.marginBottom = '10px';
        homeBtn.addEventListener('click', showHome);
        elements.resultBox.appendChild(homeBtn);
        
        results.forEach(item => {
            const div = document.createElement('div');
            div.className = 'list-item';
            div.textContent = item.title;
            div.addEventListener('click', () => showDetail(item.title, item.content));
            elements.resultBox.appendChild(div);
        });
    }
    
    function showDetail(title, content) {
        showSearchMode();
        clearResult();
        const detailDiv = document.createElement('div');
        
        // 检查是否有相关图片 - 通过查找匹配的键名
        let hasImages = false;
        let imageKey = title;
        for (const key in IMAGE_MAPPING) {
            if (title === key || key.includes(title) || title.includes(key)) {
                hasImages = true;
                imageKey = key;
                break;
            }
        }
        
        let actionBarHTML = `
            <div class="action-bar">
                <button class="btn btn-back" id="backFromDetail">${typeof i18n !== 'undefined' ? i18n.t('back_to_home') : '返回'}</button>
                <button class="btn btn-copy" id="copyDetail">${typeof i18n !== 'undefined' ? i18n.t('copy_text') : '复制文本'}</button>
        `;
        
        if (hasImages) {
            actionBarHTML += `
                <button class="btn btn-view-images" id="viewImagesBtn">${typeof i18n !== 'undefined' ? i18n.t('view_images') : '查看相关图片'}</button>
            `;
        }
        
        actionBarHTML += `
            </div>
        `;
        
        detailDiv.className = 'detail-page';
        detailDiv.innerHTML = `
            <div class="detail-title">${title}</div>
            <div class="detail-content">${content}</div>
            ${actionBarHTML}
        `;
        elements.resultBox.appendChild(detailDiv);
        
        document.getElementById('backFromDetail').addEventListener('click', () => {
            if (lastSearchResults.length) {
                showSearchResults(lastSearchResults, lastKeyword);
            } else {
                showHome();
            }
        });
        
        document.getElementById('copyDetail').addEventListener('click', () => {
            navigator.clipboard.writeText(content).then(() => {
                const btn = document.getElementById('copyDetail');
                btn.textContent = typeof i18n !== 'undefined' ? i18n.t('copied') : '已复制';
                setTimeout(() => btn.textContent = typeof i18n !== 'undefined' ? i18n.t('copy_text') : '复制文本', 1500);
            }).catch(err => {
                console.error('复制失败:', err);
            });
        });
        
        if (hasImages) {
            document.getElementById('viewImagesBtn').addEventListener('click', () => {
                showImageViewer(IMAGE_MAPPING[imageKey]);
            });
        }
    }
    
    function performSearch() {
        const keyword = elements.searchInput.value.trim();
        if (!keyword) {
            showHome();
            hideSearchHistory();
            return;
        }
        
        saveSearchHistory(keyword);
        hideSearchHistory();
        elements.loading.classList.add('show');
        
        setTimeout(() => {
            const kw = keyword.toLowerCase();
            const results = flatItems.filter(item =>
                item.title.toLowerCase().includes(kw) || 
                item.content.toLowerCase().includes(kw)
            );
            showSearchResults(results, keyword);
            elements.loading.classList.remove('show');
        }, 100);
    }
    
    function showDownloadModal() {
        elements.downloadModal.classList.add('show');
    }
    
    function hideDownloadModal() {
        elements.downloadModal.classList.remove('show');
    }
    
    function downloadWindowsVersion() {
        const link = document.createElement('a');
        link.href = 'https://github.com/jiyuli666/lxhpy/releases/download/lxh/LuoXiaoHeiChecker-1.3.3-win64.exe';
        link.download = 'LuoXiaoHeiChecker-1.3.3-win64.exe';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        hideDownloadModal();
    }
    
    function downloadAndroidVersion() {
        const link = document.createElement('a');
        link.href = 'https://raw.githubusercontent.com/jiyuli666/lxhpy/main/%E7%BD%97%E5%B0%8F%E9%BB%91%E8%BE%9F%E8%B0%A3%E6%9F%A5%E8%AF%A2.apk';
        link.download = '罗小黑辟谣查询.apk';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        hideDownloadModal();
    }
    
    function downloadIOSVersion() {
        alert(typeof i18n !== 'undefined' ? i18n.t('open_in_browser') : '请点击浏览器底部的分享按钮');
        hideDownloadModal();
    }
    
    function initEventListeners() {
        const languageSelect = document.getElementById('languageSelect');
        if (languageSelect) {
            if (typeof i18n !== 'undefined') {
                languageSelect.value = i18n.currentLang;
            }
            languageSelect.addEventListener('change', (e) => {
                if (typeof i18n !== 'undefined') {
                    i18n.setLanguage(e.target.value);
                }
            });
        }
        
        elements.darkModeBtn.addEventListener('click', toggleDarkMode);
        elements.categoryBtn.addEventListener('click', () => toggleSidebar());
        elements.overlay.addEventListener('click', () => toggleSidebar(false));
        elements.searchBtn.addEventListener('click', performSearch);
        elements.searchInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') performSearch();
        });
        elements.searchInput.addEventListener('input', () => {
            if (elements.searchInput.value.trim()) {
                showSearchHistory();
            } else {
                hideSearchHistory();
            }
        });
        elements.searchInput.addEventListener('focus', () => {
            if (elements.searchInput.value.trim()) showSearchHistory();
        });
        elements.searchInput.addEventListener('blur', () => {
            setTimeout(hideSearchHistory, 200);
        });
        elements.downloadBtn.addEventListener('click', showDownloadModal);
        elements.closeModal.addEventListener('click', hideDownloadModal);
        elements.downloadWindows.addEventListener('click', downloadWindowsVersion);
        elements.downloadAndroid.addEventListener('click', downloadAndroidVersion);
        elements.addIOS.addEventListener('click', downloadIOSVersion);
        elements.prevBtn.addEventListener('click', showPrevImage);
        elements.nextBtn.addEventListener('click', showNextImage);
        elements.closeViewerBtn.addEventListener('click', closeImageViewer);
        elements.imageViewer.addEventListener('click', (e) => {
            if (e.target === elements.imageViewer) closeImageViewer();
        });
        
        document.addEventListener('keydown', (e) => {
            if (elements.imageViewer.classList.contains('visible')) {
                if (e.key === 'ArrowLeft') showPrevImage();
                else if (e.key === 'ArrowRight') showNextImage();
                else if (e.key === 'Escape') closeImageViewer();
            } else if (e.key === 'Escape') {
                if (elements.downloadModal.classList.contains('show')) hideDownloadModal();
                else showHome();
            }
        });
    }
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
