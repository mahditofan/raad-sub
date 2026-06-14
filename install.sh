#!/bin/bash

# مسیر یابی خودکار بر اساس خروجی دستور فیندی که زدی
TARGET_FILE=$(find / -name "sub.html" 2>/dev/null | head -n 1)

# اگر به هر دلیلی پیدا نشد، از مسیر پیش‌فرض استفاده کند
if [ -z "$TARGET_FILE" ]; then
    TARGET_FILE="/etc/x-ui/sub/sub.html"
    mkdir -p "/etc/x-ui/sub"
fi

# دانلود فایل HTML از گیت‌هاب شما (به جای تزریق مستقیم متنی برای جلوگیری از باگ کاراکترها)
# لطفا آدرس زیر را با لینک raw فایل sub.html خودت در گیت‌هاب جایگزین کن:
RAW_HTML_URL="https://raw.githubusercontent.com/monhacer/mahditofan/raad-sub/main/sub.html"

echo "در حال نصب قالب جدید در مسیر: $TARGET_FILE"

curl -fsSL "$RAW_HTML_URL" -o "$TARGET_FILE"

if [ $? -eq 0 ]; then
    echo "✔ قالب بدون باگ VeloX با موفقیت نصب شد."
else
    echo "❌ خطایی در دانلود فایل رخ داد."
fi
