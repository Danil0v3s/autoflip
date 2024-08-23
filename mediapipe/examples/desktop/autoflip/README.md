### Steps to run the AutoFlip video cropping graph

1.  Checkout the repository and follow
    [the installation instructions](https://github.com/google/mediapipe/blob/master/mediapipe/docs/install.md)
    to set up MediaPipe.

    ```bash
    git clone https://github.com/google/mediapipe.git
    cd mediapipe
    ```

2.  Build and run the run_autoflip binary to process a local video.

Note: AutoFlip currently only works with OpenCV 3 . Please verify your OpenCV version beforehand.

    ```bash
    # no gpu
    bazel build -c opt --define MEDIAPIPE_DISABLE_GPU=1 --define xnn_enable_avx512fp16=false --define xnn_enable_avxvnni=false --define xnn_enable_avx512amx=false mediapipe/examples/desktop/autoflip:run_autoflip

    # gpu
    bazel build -c opt --config=cuda --spawn_strategy=local --define no_aws_support=true --copt -DMESA_EGL_NO_X11_HEADERS --define xnn_enable_avx512fp16=false --define xnn_enable_avxvnni=false --define xnn_enable_avx512amx=false mediapipe/examples/desktop/autoflip:run_autoflip

    GLOG_logtostderr=1 bazel-bin/mediapipe/examples/desktop/autoflip/run_autoflip -DMESA_EGL_NO_X11_HEADERS --copt -DEGL_NO_X11 --calculator_graph_config_file=mediapipe/examples/desktop/autoflip/autoflip_graph.pbtxt --input_side_packets=input_video_path=input/test.mp4,output_video_path=output/test.mp4,aspect_ratio=3:4
    ```

3.  View the cropped video.
