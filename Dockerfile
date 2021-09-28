# Copyright (C) 2021, Raffaello Bonghi <raffaello@rnext.it>
# All rights reserved
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# https://hub.docker.com/_/ros
FROM ros:foxy-ros-base

# https://github.com/dheera/rosboard
RUN apt-get update && \
    apt-get install -y python3-pip && \
    pip3 install tornado simplejpeg && \
    pip3 install psutil && \
    rm -rf /var/lib/apt/lists/*

# Download web services
ENV ROS_WS /opt/ros_ws
RUN mkdir -p $ROS_WS/src
WORKDIR $ROS_WS

# Copy wstool webgui.rosinstall
# to skip rosdep install --from-paths src --ignore-src -r -y
COPY rosinstall/webgui.rosinstall webgui.rosinstall
# Initialize ROS2 workspace
RUN mkdir -p $ROS_WS/src && \
    pip3 install wheel && \
    pip3 install -U wstool && \
    wstool init $ROS_WS/src && \
    wstool merge -t $ROS_WS/src webgui.rosinstall && \
    wstool update -t $ROS_WS/src

RUN cd $ROS_WS && \
    . /opt/ros/$ROS_DISTRO/setup.sh && \
    colcon build --symlink-install --packages-select rosboard nanosaur_msgs isaac_ros_apriltag_interfaces jetson_stats_msgs \
    --cmake-args \
    -DCMAKE_BUILD_TYPE=Release

# source ros package from entrypoint
RUN sed --in-place --expression \
      '$isource "$ROS_WS/install/setup.bash"' \
      /ros_entrypoint.sh

# run ros package launch file
# Connect to localhost:8888 page
CMD ["ros2", "run", "rosboard", "rosboard_node"]