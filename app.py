from flask import Flask, render_template, Response
import cv2 as cv
import mediapipe as mp
import copy
from collections import deque, Counter
import csv
from model import KeyPointClassifier, PointHistoryClassifier
from handg import calc_bounding_rect, calc_landmark_list, pre_process_landmark, pre_process_point_history, draw_bounding_rect, draw_landmarks, draw_point_history, draw_info_text

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import threading

cred = credentials.Certificate("Account.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

def log_sos_event():
    doc_ref = db.collection('sos_events').document()
    doc_ref.set({
        'gesture': 'SOS detected',
        'Capture_Time': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    })

def log_sos_event_async():
    log_thread = threading.Thread(target=log_sos_event)
    log_thread.start()

app = Flask(__name__)

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=False, max_num_hands=20, min_detection_confidence=0.5, min_tracking_confidence=0.5)

keypoint_classifier = KeyPointClassifier()
point_history_classifier = PointHistoryClassifier()

with open('model/keypoint_classifier/keypoint_classifier_label.csv', encoding='utf-8-sig') as f:
    keypoint_classifier_labels = [row[0] for row in csv.reader(f)]

with open('model/point_history_classifier/point_history_classifier_label.csv', encoding='utf-8-sig') as f:
    point_history_classifier_labels = [row[0] for row in csv.reader(f)]

history_length = 16
point_history = deque(maxlen=history_length)
finger_gesture_history = deque(maxlen=history_length)

def detect_hand_gestures(image):
    debug_image = copy.deepcopy(image)
    image = cv.cvtColor(image, cv.COLOR_BGR2RGB)
    results = hands.process(image)

    if results.multi_hand_landmarks is not None:
        for hand_landmarks, handedness in zip(results.multi_hand_landmarks, results.multi_handedness):
            brect = calc_bounding_rect(debug_image, hand_landmarks)
            landmark_list = calc_landmark_list(debug_image, hand_landmarks)

            pre_processed_landmark_list = pre_process_landmark(landmark_list)
            pre_processed_point_history_list = pre_process_point_history(debug_image, point_history)

            hand_sign_id = keypoint_classifier(pre_processed_landmark_list)
            finger_gesture_id = 0
            point_history_len = len(pre_processed_point_history_list)

            if point_history_len == (history_length * 2):
                finger_gesture_id = point_history_classifier(pre_processed_point_history_list)

            finger_gesture_history.append(finger_gesture_id)
            most_common_fg_id = Counter(finger_gesture_history).most_common()

            if keypoint_classifier_labels[hand_sign_id].lower() == 'sos detected':
                log_sos_event_async()

            debug_image = draw_bounding_rect(True, debug_image, brect)
            debug_image = draw_landmarks(debug_image, landmark_list)
            debug_image = draw_info_text(
                debug_image,
                brect,
                handedness,
                keypoint_classifier_labels[hand_sign_id],
                point_history_classifier_labels[most_common_fg_id[0][0]],
            )

    debug_image = draw_point_history(debug_image, point_history)
    return debug_image

def generate_frames():
    cap = cv.VideoCapture(0)
    cap.set(cv.CAP_PROP_FRAME_WIDTH, 640)
    cap.set(cv.CAP_PROP_FRAME_HEIGHT, 480)

    while True:
        success, frame = cap.read()
        if not success:
            break

        frame = detect_hand_gestures(frame)
        ret, buffer = cv.imencode('.jpg', frame)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

    cap.release()

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
