#!/bin/bash

# Kiểm tra quyền root
if [ "$EUID" -ne 0 ]
  then echo "Vui lòng chạy script với quyền sudo (VD: sudo ./install.sh)"
  exit
fi

echo "=== Bắt đầu cài đặt MediaMTX Zero-Copy Streaming ==="

# Cài đặt wget và tar nếu chưa có
apt-get update && apt-get install -y wget tar

# Tải xuống MediaMTX (v1.19.1)
echo "Đang tải MediaMTX..."
wget -qO /tmp/mediamtx.tar.gz https://github.com/bluenviron/mediamtx/releases/download/v1.19.1/mediamtx_v1.19.1_linux_amd64.tar.gz

# Giải nén
echo "Giải nén phần mềm..."
tar -xzf /tmp/mediamtx.tar.gz -C /tmp

# Di chuyển file thực thi
mkdir -p /usr/local/bin
mv /tmp/mediamtx /usr/local/bin/
chmod +x /usr/local/bin/mediamtx

# Sao chép file cấu hình
echo "Cài đặt cấu hình tối ưu..."
mkdir -p /usr/local/etc
cp configs/mediamtx.yml /usr/local/etc/mediamtx.yml

# Sao chép và kích hoạt Systemd Service
echo "Kích hoạt dịch vụ chạy ngầm..."
cp configs/mediamtx.service /etc/systemd/system/mediamtx.service
systemctl daemon-reload
systemctl enable --now mediamtx

echo "=== HOÀN TẤT CÀI ĐẶT ==="
echo "Dịch vụ đã chạy. Bạn có thể kiểm tra bằng lệnh: systemctl status mediamtx"
