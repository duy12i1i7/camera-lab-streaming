# Camera Lab Streaming (Zero-Copy WebRTC)

Hệ thống phân phối luồng Camera giám sát nội bộ với kiến trúc **Zero-Copy** siêu nhẹ, sử dụng **MediaMTX** làm lõi xử lý. Đảm bảo 100-300 người xem cùng lúc luồng WebRTC với độ trễ (latency) gần như 0 giây, mà không làm quá tải CPU máy chủ hay Camera.

## Kiến trúc Hệ thống

```mermaid
graph TD
    C1[Imou Cam 1 <br> 192.168.100.4] -->|RTSP H.264| M(MediaMTX Proxy <br> Ubuntu VM)
    C2[Imou Cam 2 <br> 192.168.100.5] -->|RTSP H.264| M
    C3[Imou Cam 3 <br> 192.168.100.6] -->|RTSP H.264| M
    M -->|WebRTC TCP/UDP| U1(User 1 Browser)
    M -->|WebRTC TCP/UDP| U2(User 2 Browser)
    M -->|WebRTC TCP/UDP| U3(User 100 Browser)
```

**Tính năng nổi bật:**
- **Zero-Copy Routing:** MediaMTX đóng vai trò như một Router mạng, đẩy nguyên gói tin H.264 từ Camera sang WebRTC mà không tốn 1% CPU nào để giải mã/mã hóa (transcoding).
- **Audio Codec Tolerance:** Tự động loại bỏ luồng âm thanh AAC lỗi chuẩn (Dahua/Imou) để giữ cho kết nối WebRTC trên Chrome/Safari ổn định tuyệt đối, không bị chớp giật hay crash luồng.
- **Tối ưu Bảo mật (Minimal Surface):** Tắt hoàn toàn các giao thức thừa (HLS, RTMP, SRT) để tối ưu hóa RAM và bảo mật.

## Hướng dẫn Triển khai Tự động

Bạn không cần phải thao tác thủ công. Chỉ cần chạy script `install.sh` trên một máy chủ Ubuntu trắng (Ubuntu 22.04 / 24.04).

1. Clone thư mục dự án này về máy chủ Ubuntu:
   ```bash
   git clone https://github.com/duy12i1i7/camera-lab-streaming.git
   cd camera-lab-streaming
   ```
2. Chạy tệp cài đặt (yêu cầu quyền root/sudo):
   ```bash
   chmod +x install.sh
   sudo ./install.sh
   ```
3. Script sẽ tự động:
   - Tải `mediamtx` (v1.19.1) từ GitHub.
   - Sao chép file cấu hình `mediamtx.yml` vào đúng vị trí.
   - Thiết lập `mediamtx.service` để tự động khởi chạy cùng hệ thống (Auto-start on boot & Auto-restart on crash).

## Tùy chỉnh Cấu hình Camera

Mở tệp `configs/mediamtx.yml` để chỉnh sửa IP hoặc luồng của Camera:
```yaml
paths:
  cam1:
    source: rtsp://user:pass@192.168.1.10:554/cam/realmonitor?channel=1&subtype=0
```
Sau khi sửa, nhớ khởi động lại dịch vụ: `sudo systemctl restart mediamtx`

## Hướng dẫn Xem Camera

Mở file `web/Xem_Camera.html` trên trình duyệt web bất kỳ. File HTML này đã được thiết kế layout chuẩn mực để theo dõi toàn bộ các luồng cùng lúc. Bạn có thể copy file HTML này chia sẻ cho bất kỳ ai hoặc nhúng vào trang web nội bộ công ty.
