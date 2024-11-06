gstreamer-based rtsp stream recorder and uploader

**!!!Only RTSP and h264/h265 are supported!!!**

# Usage

- Install and configure [rclone](https://rclone.org/downloads/)
- Check that gst-launch-1.0 is available. If not, [install it](https://gstreamer.freedesktop.org/documentation/installing/on-linux.html?gi-language=c#install-gstreamer-on-ubuntu-or-debian)
- start the recording by calling rec_start
```
./rec_start.sh rtsp://url1 camera1 rtsp://url2 camera2 ...
```
- - press Ctl+C if you see some output in the console, this is ok
- - this will start recording from rtsp://url1 to camera1_00.mp4, from rtsp://url2 to camera2_00.mp4 and so on. The files will be approx 10 min long
- start rec_move_rclone.sh
```
./rec_move_rclone.sh "camera*.mp4" some_rclone_remote:
```
- - this will continuously move the recorded videos to your some_rclone_remote:
- - when done, call `./rec_stop.sh`.
- - Check that all gst-launch-1.0 processes are finished
```
ps -aux | grep -v grep | grep "gst-launch-1.0"
```
- When all files are moved to rclone remote, finish the rec_move_rclone.sh process
```
ps -aux | grep -v grep | grep "move_to_cloud.sh" | awk '{print $2}' | xargs sudo kill -9
```



