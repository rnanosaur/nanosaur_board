# 🎒 nanosaur_board
Access to work with nanosaur

NanoSaur is a little tracked robot ROS2 enabled, made for an NVIDIA Jetson Nano

* :sauropod: Website: [nanosaur.ai](https://nanosaur.ai)
* :unicorn: Do you need an help? [Discord](https://discord.gg/NSrC52P5mw)
* :toolbox: For technical details follow [wiki](https://github.com/rnanosaur/nanosaur/wiki)
* :whale2: Nanosaur [Docker hub](https://hub.docker.com/u/nanosaur)
* :interrobang: Something wrong? Open an [issue](https://github.com/rnanosaur/nanosaur/issues)

# Build

```
docker build -f Dockerfile -t nanosaur/webgui:latest .
```

## Run

Run docker
```
docker run --rm -it --network host dustynv/ros:foxy-ros-base-l4t-r32.6.1 bash
```
