#/bin/sh

input_video=$1
aspect_ratio=$2

ffmpeg -y -i input/${input_video} -vf "scale=-2:480,fps=10" input/input_low.mp4

bazel-bin/mediapipe/examples/desktop/autoflip/run_autoflip \
        --calculator_graph_config_file=input/autoflip_graph.pbtxt \
        --input_side_packets=input_video_path=input/input_low.mp4,aspect_ratio=${aspect_ratio}