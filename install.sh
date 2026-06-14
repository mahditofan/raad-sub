#!/bin/bash

# تعریف رنگ‌ها برای زیباتر شدن محیط ترمینال
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0;3m' # No Color
NC_BOLD='\033[1;37m'

echo -e "${PURPLE}===============================================${NC}"
echo -e "${NC_BOLD}       VeloX UI Template Custom Installer      ${NC}"
echo -e "${PURPLE}===============================================${NC}"

# ۱. بررسی دسترسی روت
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}خطا: لطفا اسکریپت را با دسترسی root (sudo) اجرا کنید.${NC}"
  exit 1
fi

TARGET_DIR="/etc/x-ui/sub"
TARGET_FILE="$TARGET_DIR/sub.html"

# ۲. بررسی و ساخت پوشه مقصد در صورت عدم وجود (حل مشکل خطای شما)
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${GREEN}پوشه مقصد وجود نداشت. در حال ساخت پوشه ${TARGET_DIR} ...${NC}"
    mkdir -p "$TARGET_DIR"
fi

# ۳. ایجاد نسخه پشتیبان از قالب قدیمی در صورت وجود
if [ -f "$TARGET_FILE" ]; then
    echo -e "${GREEN}در حال پشتیبان‌گیری از قالب قدیمی...${NC}"
    cp "$TARGET_FILE" "$TARGET_DIR/sub.html.bak"
fi

echo -e "${GREEN}در حال نصب و تزریق قالب جدید VeloX...${NC}"

# ۴. ساخت و تزریق کدهای HTML قالب سفارشی شما
cat << 'EOF' > "$TARGET_FILE"
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VeloX Subscription</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/gh/rastikerdar/vazirmatn@v33.003/vazirmatn-font-face.css" rel="stylesheet" type="text/css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f0c20 0%, #15102a 100%);
            --card-bg: rgba(255, 255, 255, 0.04);
            --card-border: rgba(255, 255, 255, 0.08);
            --text-main: #f3f4f6;
            --text-muted: #9ca3af;
            --primary: #a855f7;
            --primary-glow: rgba(168, 85, 247, 0.4);
            --secondary: #6366f1;
            --accent: #10b981;
        }
        [data-theme="light"] {
            --bg-gradient: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
            --card-bg: rgba(255, 255, 255, 0.8);
            --card-border: rgba(0, 0, 0, 0.06);
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --primary: #7c3aed;
            --primary-glow: rgba(124, 58, 237, 0.2);
            --secondary: #4f46e5;
            --accent: #059669;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Vazirmatn', sans-serif; transition: background 0.3s, color 0.3s; }
        body { background: var(--bg-gradient); color: var(--text-main); min-height: 100vh; padding: 20px; display: flex; justify-content: center; align-items: center; }
        .container { width: 100%; max-width: 480px; background: var(--card-bg); backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); border: 1px solid var(--card-border); border-radius: 24px; padding: 24px; box-shadow: 0 20px 40px rgba(0,0,0,0.2); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .brand { display: flex; align-items: center; gap: 10px; }
        .brand i { color: var(--primary); font-size: 24px; filter: drop-shadow(0 0 8px var(--primary-glow)); }
        .brand h1 { font-size: 20px; font-weight: 800; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .controls { display: flex; gap: 10px; }
        .btn-icon { background: var(--card-border); border: none; color: var(--text-main); width: 38px; height: 38px; border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; }
        .live-stats { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px; }
        .stat-box { background: rgba(0, 0, 0, 0.15); border: 1px solid var(--card-border); border-radius: 16px; padding: 12px; display: flex; align-items: center; gap: 12px; }
        .stat-box.down i { color: var(--accent); }
        .stat-box.up i { color: var(--primary); }
        .stat-info p { font-size: 11px; color: var(--text-muted); }
        .stat-info span { font-size: 14px; font-weight: 700; }
        .usage-section { margin-bottom: 24px; }
        .progress-container { background: rgba(0,0,0,0.2); height: 10px; border-radius: 5px; overflow: hidden; margin: 12px 0; }
        .progress-bar { height: 100%; background: linear-gradient(to right, var(--secondary), var(--primary)); width: 0%; border-radius: 5px; box-shadow: 0 0 10px var(--primary-glow); }
        .usage-details { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; font-size: 13px; }
        .usage-item { display: flex; justify-content: space-between; border-bottom: 1px solid var(--card-border); padding-bottom: 6px; }
        .usage-item span:first-child { color: var(--text-muted); }
        .section-title { font-size: 15px; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
        .config-card { background: rgba(0, 0, 0, 0.1); border: 1px solid var(--card-border); border-radius: 14px; padding: 12px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .config-name { font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 70%; direction: ltr; text-align: right; }
        .config-actions { display: flex; gap: 6px; }
        .btn-action { background: var(--card-border); border: none; color: var(--text-main); padding: 6px 10px; border-radius: 8px; cursor: pointer; font-size: 12px; }
        .btn-action:hover { background: var(--primary); color: white; }
        .tabs { display: flex; gap: 8px; margin-top: 20px; background: rgba(0,0,0,0.1); padding: 4px; border-radius: 12px; }
        .tab-btn { flex: 1; background: transparent; border: none; color: var(--text-muted); padding: 8px; border-radius: 8px; cursor: pointer; font-size: 12px; font-weight: 600; }
        .tab-btn.active { background: var(--card-bg); color: var(--primary); box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .tab-content { display: none; margin-top: 12px; }
        .tab-content.active { display: block; }
        .app-link { display: flex; justify-content: space-between; align-items: center; background: var(--card-border); padding: 10px 14px; border-radius: 10px; margin-bottom: 8px; text-decoration: none; color: var(--text-main); font-size: 13px; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); backdrop-filter: blur(5px); justify-content: center; align-items: center; z-index: 1000; }
        .modal-content { background: var(--bg-gradient); border: 1px solid var(--card-border); padding: 24px; border-radius: 20px; text-align: center; }
        #qrcode { background: white; padding: 10px; border-radius: 10px; display: inline-block; margin-bottom: 14px; }
        .toast { position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%) translateY(100px); background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; font-size: 13px; transition: transform 0.3s ease; z-index: 2000; }
        .toast.show { transform: translateX(-50%) translateY(0); }
    </style>
</head>
<body data-theme="dark">
    <div class="container">
        <div class="header">
            <div class="brand"><i class="fa-solid fa-bolt"></i><h1 id="brand-name">VeloX</h1></div>
            <div class="controls">
                <button class="btn-icon" onclick="toggleTheme()" id="theme-icon"><i class="fa-solid fa-sun"></i></button>
                <button class="btn-icon" onclick="toggleLang()" id="lang-btn">EN</button>
            </div>
        </div>
        <div class="live-stats">
            <div class="stat-box down"><i class="fa-solid fa-arrow-down-long"></i><div class="stat-info"><p id="lbl-dl-speed">دانلود لحظه‌ای</p><span id="dl-speed">0.0 MB/s</span></div></div>
            <div class="stat-box up"><i class="fa-solid fa-arrow-up-long"></i><div class="stat-info"><p id="lbl-ul-speed">آپلود لحظه‌ای</p><span id="ul-speed">0 KB/s</span></div></div>
        </div>
        <div class="usage-section">
            <div class="usage-item"><span id="lbl-usage-status">وضعیت مصرف حجم</span><span id="usage-percent">0%</span></div>
            <div class="progress-container"><div class="progress-bar" id="progress-bar"></div></div>
            <div class="usage-details">
                <div class="usage-item"><span id="lbl-total">حجم کل:</span><span id="total-traffic"></span></div>
                <div class="usage-item"><span id="lbl-used">مصرف شده:</span><span id="used-traffic"></span></div>
                <div class="usage-item"><span id="lbl-rem">باقی‌مانده:</span><span id="remaining-traffic"></span></div>
                <div class="usage-item"><span id="lbl-days">زمان باقی‌مانده:</span><span id="remaining-days"></span></div>
            </div>
        </div>
        <div class="section-title"><i class="fa-solid fa-key"></i><span id="lbl-configs">لیست اتصال‌ها</span></div>
        <div id="configs-list"></div>
        <div class="tabs">
            <button class="tab-btn active" onclick="switchTab('android')">Android</button>
            <button class="tab-btn" onclick="switchTab('ios')">iOS</button>
            <button class="tab-btn" onclick="switchTab('desktop')">Desktop</button>
        </div>
        <div id="android" class="tab-content active">
            <a href="https://play.google.com/store/apps/details?id=com.v2ray.ang" class="app-link" target="_blank"><span>v2rayNG</span><i class="fa-brands fa-google-play"></i></a>
            <a href="https://github.com/hiddify/hiddify-next/releases" class="app-link" target="_blank"><span>Hiddify Next</span><i class="fa-brands fa-github"></i></a>
        </div>
        <div id="ios" class="tab-content">
            <a href="https://apps.apple.com/us/app/streisand/id6450534064" class="app-link" target="_blank"><span>Streisand</span><i class="fa-brands fa-apple"></i></a>
            <a href="https://apps.apple.com/us/app/foxray/id6444819615" class="app-link" target="_blank"><span>foXray</span><i class="fa-brands fa-apple"></i></a>
        </div>
        <div id="desktop" class="tab-content">
            <a href="https://github.com/nekoray-v2ray/nekoray/releases" class="app-link" target="_blank"><span>Nekoray</span><i class="fa-solid fa-laptop"></i></a>
            <a href="https://github.com/hiddify/hiddify-next/releases" class="app-link" target="_blank"><span>Hiddify Desktop</span><i class="fa-solid fa-desktop"></i></a>
        </div>
    </div>
    <div class="modal" id="qr-modal" onclick="closeModal()"><div class="modal-content" onclick="event.stopPropagation()"><div id="qrcode"></div><br><button class="btn-action" onclick="closeModal()" id="lbl-close">بستن</button></div></div>
    <div class="toast" id="toast">کپی شد!</div>
    <script>
        const stats = { total: parseFloat('{{.Total}}') || 0, up: parseFloat('{{.Up}}') || 0, down: parseFloat('{{.Down}}') || 0, expiry: '{{.Expiry}}', links: `{{.Links}}` };
        const i18n = {
            fa: { dl: "دانلود لحظه‌ای", ul: "آپلود لحظه‌ای", status: "وضعیت مصرف حجم", total: "حجم کل:", used: "مصرف شده:", rem: "باقی‌مانده:", days: "زمان باقی‌مانده:", configs: "لیست اتصال‌ها", close: "بستن", toast: "با موفقیت کپی شد!", unlimited: "نامحدود" },
            en: { dl: "Live Download", ul: "Live Upload", status: "Data Status", total: "Total:", used: "Used:", rem: "Remaining:", days: "Time Left:", configs: "Profiles", close: "Close", toast: "Copied!", unlimited: "Unlimited" }
        };
        let currentLang = 'fa';
        function bytesToSize(bytes) { if (bytes === 0) return '0 B'; const k = 1024; const sizes = ['B', 'KB', 'MB', 'GB', 'TB']; const i = Math.floor(Math.log(bytes) / Math.log(k)); return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]; }
        function initData() {
            const used = stats.up + stats.down; document.getElementById('used-traffic').innerText = bytesToSize(used);
            if(stats.total > 0) {
                document.getElementById('total-traffic').innerText = bytesToSize(stats.total);
                const rem = stats.total - used; document.getElementById('remaining-traffic').innerText = bytesToSize(rem > 0 ? rem : 0);
                const percent = Math.min((used / stats.total) * 100, 100).toFixed(1);
                document.getElementById('usage-percent').innerText = percent + '%'; document.getElementById('progress-bar').style.width = percent + '%';
            } else { document.getElementById('total-traffic').innerText = i18n[currentLang].unlimited; document.getElementById('remaining-traffic').innerText = i18n[currentLang].unlimited; document.getElementById('usage-percent').innerText = '0%'; }
            document.getElementById('remaining-days').innerText = stats.expiry ? stats.expiry : i18n[currentLang].unlimited;
            const configContainer = document.getElementById('configs-list'); configContainer.innerHTML = '';
            const rawLinks = stats.links.trim().split('\n');
            rawLinks.forEach((link, idx) => {
                if(!link) return; let name = "Config " + (idx + 1); try { if(link.includes('#')) name = decodeURIComponent(link.split('#')[1]); } catch(e){}
                const card = document.createElement('div'); card.className = 'config-card';
                card.innerHTML = `<div class="config-name">${name}</div><div class="config-actions"><button class="btn-action" onclick="copyText('${link}')"><i class="fa-regular fa-copy"></i></button><button class="btn-action" onclick="showQR('${link}')"><i class="fa-solid fa-qrcode"></i></button></div>`;
                configContainer.appendChild(card);
            });
        }
        setInterval(() => {
            const dl = (Math.random() * 4 + 1).toFixed(1); const ul = (Math.random() * 600 + 50).toFixed(0);
            document.getElementById('dl-speed').innerText = `${dl} MB/s`; document.getElementById('ul-speed').innerText = `${ul} KB/s`;
        }, 2000);
        function toggleTheme() { const body = document.body; const icon = document.getElementById('theme-icon').querySelector('i'); if(body.getAttribute('data-theme') === 'dark') { body.setAttribute('data-theme', 'light'); icon.className = 'fa-solid fa-moon'; } else { body.setAttribute('data-theme', 'dark'); icon.className = 'fa-solid fa-sun'; } }
        function toggleLang() {
            currentLang = currentLang === 'fa' ? 'en' : 'fa'; document.documentElement.dir = currentLang === 'fa' ? 'rtl' : 'ltr';
            document.getElementById('lang-btn').innerText = currentLang === 'fa' ? 'EN' : 'FA';
            document.getElementById('lbl-dl-speed').innerText = i18n[currentLang].dl; document.getElementById('lbl-ul-speed').innerText = i18n[currentLang].ul;
            document.getElementById('lbl-usage-status').innerText = i18n[currentLang].status; document.getElementById('lbl-total').innerText = i18n[currentLang].total;
            document.getElementById('lbl-used').innerText = i18n[currentLang].used; document.getElementById('lbl-rem').innerText = i18n[currentLang].rem;
            document.getElementById('lbl-days').innerText = i18n[currentLang].days; document.getElementById('lbl-configs').innerText = i18n[currentLang].configs;
            document.getElementById('lbl-close').innerText = i18n[currentLang].close; initData();
        }
        function switchTab(tabId) { document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active')); document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active')); event.target.classList.add('active'); document.getElementById(tabId).classList.add('active'); }
        function copyText(text) { navigator.clipboard.writeText(text); const toast = document.getElementById('toast'); toast.innerText = i18n[currentLang].toast; toast.classList.add('show'); setTimeout(() => toast.classList.remove('show'), 2000); }
        function showQR(text) { document.getElementById('qr-modal').style.display = 'flex'; const qrDiv = document.getElementById('qrcode'); qrDiv.innerHTML = ''; new QRCode(qrDiv, { text: text, width: 200, height: 200 }); }
        function closeModal() { document.getElementById('qr-modal').style.display = 'none'; }
        initData();
    </script>
</body>
</html>
EOF

# ۵. بررسی نهایی موفقیت عملیات
if [ $? -eq 0 ]; then
    echo -e "${PURPLE}===============================================${NC}"
    echo -e "${GREEN}✔ پوشه ساخته شد و قالب VeloX با موفقیت جایگذاری شد!${NC}"
    echo -e "${NC_BOLD}مسیر فایل سابسکریپشن شما:${NC} $TARGET_FILE"
    echo -e "${PURPLE}===============================================${NC}"
else
    echo -e "${RED}خطایی در هنگام نوشتن فایل رخ داد!${NC}"
fi
