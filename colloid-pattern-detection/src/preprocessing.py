import cv2
import os
import numpy as np

#image_path ..
# Function to read an image from a file
def load_image(image_path):
    # Load an image in grayscale directly
    return cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)

# Function to preprocess an image
def preprocess_image(image):
    # Apply Gaussian Blurring
    blurred = cv2.GaussianBlur(image, (5, 5), 0)

    # Thresholding can also be added here if needed
    _, thresh = cv2.threshold(blurred, 127, 255, cv2.THRESH_BINARY)
    
    return thresh

# Function to save a processed image
def save_image(image, path, filename):
    # Check if the directory exists, if not, create it
    if not os.path.exists(path):
        os.makedirs(path)
    # Save the image to the specified path
    cv2.imwrite(os.path.join(path, filename), image)

# Main function to load, process, and save images
def process_images_from_folder(input_folder, output_folder):
    # Iterate over all files in the input folder
    for filename in os.listdir(input_folder):
        if filename.endswith(".jpg") or filename.endswith(".png"):  # Check for image files
            file_path = os.path.join(input_folder, filename)
            image = load_image(file_path)
            processed_image = preprocess_image(image)
            save_image(processed_image, output_folder, filename)

if __name__ == "__main__":
    input_folder = 'data/raw'
    output_folder = 'data/processed'
    process_images_from_folder(input_folder, output_folder)
