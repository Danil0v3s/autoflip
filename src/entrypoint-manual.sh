#/bin/sh

input_video=$1
aspect_ratio=$2
video_filename=${input_video%.*}

echo "Downscaling video to 480w..."
ffmpeg -hide_banner -loglevel error -y -i input/${input_video} -vf "scale=-2:480,fps=24" input/input_low.mp4

bazel-bin/mediapipe/examples/desktop/autoflip/run_autoflip \
        --calculator_graph_config_file=./input/autoflip_graph.pbtxt \
        --input_side_packets=input_video_path=./input/input_low.mp4,output_video_path=./output/"${video_filename}"_"${aspect_ratio}".mp4,aspect_ratio="${aspect_ratio}",csv_path=./output/"${video_filename}"_"${aspect_ratio}".csv

rm input/input_low.mp4