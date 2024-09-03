import cv2, csv, sys

file_name = sys.argv[1]
aspect_ratio = sys.argv[2]

video = cv2.VideoCapture(f"input/{file_name}.mp4")
width = int(video.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))

frame_number = 0
with open(f"output/{file_name}_{aspect_ratio}.csv", "r") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=",")
    csv_lines = []
    for row in csv_reader:
        csv_lines.append(row)
    
    while video.isOpened():
        frame_exists, frame = video.read()

        if frame_exists:
            millis = int(video.get(cv2.CAP_PROP_POS_MSEC) * 1000)
            if frame_number >= len(csv_lines):
                break

            coordinate = csv_lines[frame_number]

            position = float(coordinate[4])

            middle_point = position * width
            crop_width = int(height / 4 * 3)
            left = int(middle_point - crop_width / 2)

            crop = frame[0:height, left:left+crop_width]

            if millis >= int(coordinate[0]):
                frame_number += 1

            cv2.imshow("crop", crop)
            key = cv2.waitKey(1)
            if key == ord("q"):
                break

video.release()
cv2.destroyAllWindows()