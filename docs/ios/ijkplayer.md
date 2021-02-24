# ijkplayer

1. [fork - ijkplayer](https://github.com/AllenSWB/ijkplayer#build-ios)
2. 编译 ijkplayer 时候遇到错误 `./libavutil/arm/asm.S:50:9: error: unknown directive`
解决方法：在compile-ffmpeg.sh脚本中删除armv7, 修改如下：`FF_ALL_ARCHS_IOS8_SDK="arm64 i386 x86_64"`