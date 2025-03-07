def extract_features(image):
    edges = cv2.Canny(image, 100, 200)
    return edges
