 
ln -s /usr/include/opencv4/opencv2 /usr/include/opencv2
apt-get install ffmpeg x264 libx264-dev libopencv-contrib-dev
bazel build -c opt --define MEDIAPIPE_DISABLE_GPU=1 mediapipe/examples/desktop/autoflip:run_autoflip
python setup install
python setup.py install
ls
pwd
cd /root/mediapipe/
python setup.py install
ls
cd ..
ls
python setup.py build_py
apt install -y protobuf-compiler
python setup.py build_py
exit
