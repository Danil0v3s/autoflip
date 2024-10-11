# Google's MediaPipe Autoflip fork

Changes made to this fork:
- It will generate a `csv` file containing the calculated crop points of each frames at the output folder
- I changed a pointer to a vector at `TfLiteTensorsToDetectionsCalculator` because it was throwing a segmentation fault intermittently
- I also downscale and change the video frame rate prior to executing autoflip so it consumes less RAM and doesn't kill my machine. It uses ffmpeg which is a requirement for autoflip to downscale to 480w (preserve aspect ratio) and change the fps to 24. See more [here](/entrypoint.sh)

## Usage

- Linux

  Either compile it yourself by installing the dependencies declared at the [Dockerfile](/src/Dockerfile) or pull the docker container from `daniloleemes/autoflip:latest` and run it:

  - Automatic (sends in a file, receives output file)

    ```bash
    docker run --rm -v ./input:/workspace/input -v ./output:/workspace/output -e INPUT_VIDEO=theoffice_parkour.mp4 -e ASPECT_RATIO=3:4 daniloleemes/autoflip
    ```

  - Manual (log into the container and run commands manually)
    ```
    docker run --rm -v $(pwd)/input:/workspace/input -v $(pwd)/output:/workspace/output -e INPUT_VIDEO=love_island_2.mp4 -e ASPECT_RATIO=3:4 --entrypoint "" -it daniloleemes/autoflip /bin/bash
    ```
    Then after inside the container, run `./entrypoint-manual.sh <filename.mp4> <aspect eg 3:4>`


## Customization

It's all within the [autoflip_graph.pbtxt](/input/autoflip_graph.pbtxt). That file contains the specification for each node and each of the parameters can be found at the Node's calulator `.proto` file. For instance, this node:

```
# VIDEO_PREP: Scale the input video before feature extraction.
node {
  calculator: "ScaleImageCalculator"
  input_stream: "FRAMES:video_raw"
  input_stream: "VIDEO_HEADER:video_header"
  output_stream: "FRAMES:video_frames_scaled"
  options: {
    [mediapipe.ScaleImageCalculatorOptions.ext]: {
      preserve_aspect_ratio: true
      output_format: SRGB
      target_width: 480
      algorithm: DEFAULT_WITHOUT_UPSCALE
    }
  }
}
```

Its API is declared at [scale_image_calculator.proto](/src/mediapipe/calculators/image/scale_image_calculator.proto)

For reference, these are the protos for each calculator used on Autoflip's graph

- [ScaleImageCalculator](/src/mediapipe/calculators/image/scale_image_calculator.proto)
- [PacketThinnerCalculator](/src/mediapipe/calculators/core/packet_thinner_calculator.proto)
- [BorderDetectionCalculator](/src/mediapipe/examples/desktop/autoflip/calculators/border_detection_calculator.proto)
- [ShotBoundaryCalculator](/src/mediapipe/examples/desktop/autoflip/calculators/shot_boundary_calculator.proto)
- [FaceToRegionCalculator](/src/mediapipe/examples/desktop/autoflip/calculators/face_to_region_calculator.proto)
- [LocalizationToRegionCalculator](/src/mediapipe/examples/desktop//autoflip/calculators/localization_to_region_calculator.proto)
- [SignalFusingCalculator](/src/mediapipe/examples/desktop/autoflip/calculators/signal_fusing_calculator.proto)
- [SceneCroppingCalculator](/src/mediapipe/examples/desktop/autoflip/calculators/scene_cropping_calculator.proto)
- [VideoPreStreamCalculator](/src/mediapipe/calculators/video/video_pre_stream_calculator.proto)
- [OpenCvVideoEncoderCalculator](/src/mediapipe/calculators/video/opencv_video_encoder_calculator.proto.proto)

In case you do not want a video to be generated you can comment out the last two nodes
```
# ENCODING(required): encode the video stream for the final cropped output.
node {
  calculator: "VideoPreStreamCalculator"
  # Fetch frame format and dimension from input frames.
  input_stream: "FRAME:cropped_frames"
  # Copying frame rate and duration from original video.
  input_stream: "VIDEO_PRESTREAM:video_header"
  output_stream: "output_frames_video_header"
}

node {
  calculator: "OpenCvVideoEncoderCalculator"
  input_stream: "VIDEO:cropped_frames"
  input_stream: "VIDEO_PRESTREAM:output_frames_video_header"
  input_side_packet: "OUTPUT_FILE_PATH:output_video_path"
  input_side_packet: "AUDIO_FILE_PATH:audio_path"
  options: {
    [mediapipe.OpenCvVideoEncoderCalculatorOptions.ext]: {
      codec: "avc1"
      video_format: "mp4"
    }
  }
}
```

## Debugging generated csv

Run the python script located at the debugger folder:

Assuming you have an input video called theoffice.mp4 and the output was theoffice_3:4.csv

```
python3 debugger/main.py theoffice 3:4
```