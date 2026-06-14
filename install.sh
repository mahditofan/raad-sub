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

# بررسی دسترسی روت
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}خطا: لطفا اسکریپت را با دسترسی root (sudo) اجرا کنید.${NC}"
  exit 1
fi

TARGET_DIR="/etc/x-ui/sub"
TARGET_FILE="$TARGET_DIR/sub.html"

# بررسی وجود پوشه مقصد
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}خطا: پوشه مقصد /etc/x-ui/sub پیدا نشد! مطمئن شوید پنل ثنایی نصب است.${NC}"
    exit 1
fi

# ایجاد نسخه پشتیبان از قالب قدیمی در صورت وجود
if [ -f "$TARGET_FILE" ]; then
    echo -e "${GREEN}در حال پشتیبان‌گیری از قالب قدیمی...${NC}"
    cp "$TARGET_FILE" "$TARGET_DIR/sub.html.bak"
fi

echo -e "${GREEN}در حال دانلود و جایگذاری قالب جدید VeloX...${NC}"

# دانلود مستقیم کد HTML از مخزن شما (لینک فرضی گیت‌هاب)
# نکته: بعد از آپلود کدهاتون در گیت‌هاب، لینک خام (raw) فایل sub.html رو اینجا بزارید
# در حال حاضر اسکریپت فایل رو از همین سورس می‌سازه:

cat << 'EOF' > "$TARGET_FILE"
EOF

# بررسی موفقیت‌آمیز بودن عملیات
if [ $? -eq 0 ]; then
    echo -e "${PURPLE}===============================================${NC}"
    echo -e "${GREEN}✔ قالب VeloX با موفقیت نصب شد!${NC}"
    echo -e "${NC_BOLD}مسیر فایل:${NC} $TARGET_FILE"
    echo -e "${NC_BOLD}نکته:${NC} نیازی به ریستارت پنل نیست، صفحه سابسکریپشن را رفرش کنید."
    echo -e "${PURPLE}===============================================${NC}"
else
    echo -e "${RED}خطایی در هنگام نوشتن فایل رخ داد!${NC}"
fi
