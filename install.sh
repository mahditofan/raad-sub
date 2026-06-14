#!/bin/bash

# ۱. پیدا کردن مسیر فایل سابسکریپشن روی سرور به صورت خودکار
TARGET_FILE=$(find / -name "sub.html" 2>/dev/null | head -n 1)

if [ -z "$TARGET_FILE" ]; then
    echo "پوشه پیدا نشد، در حال ساخت مسیر پیش‌فرض..."
    mkdir -p "/etc/x-ui/sub"
    TARGET_FILE="/etc/x-ui/sub/sub.html"
fi

# ۲. لینک دانلود فایل HTML خام از گیت‌هاب شما
# آدرس زیر را دقیقا با یوزرنیم و اسم ریپازیتوری خودت جایگزین کن
RAW_HTML_URL="https://raw.githubusercontent.com/mahditofan/raad-sub/main/sub.html"

echo "در حال دانلود قالب VeloX از گیت‌هاب و نصب در مسیر: $TARGET_FILE"

# دانلود مستقیم فایل بدون آسیب زدن به کاراکترهای {{ }}
curl -fsSL "$RAW_HTML_URL" -o "$TARGET_FILE"

if [ $? -eq 0 ]; then
    echo "========================================"
    echo "✔ قالب VeloX با موفقیت از گیت‌هاب دانلود و نصب شد!"
    echo "========================================"
else
    echo "❌ خطایی در دانلود رخ داد. مطمئن شوید لینک گیت‌هاب درست است."
fi
