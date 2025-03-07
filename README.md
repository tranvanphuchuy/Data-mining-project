# Colloid Pattern Detection Project

## Project Overview
This project aims to detect and classify patterns in colloidal dispersions using image processing and machine learning techniques. It automates the identification of various colloid shapes, such as squares, rectangles, and triangles, and possibly other shapes based on visual data.

## Features
- **Image Preprocessing**: Convert images to grayscale, apply Gaussian blurring, and perform adaptive thresholding to enhance image features.
- **Feature Extraction**: Implement edge detection and morphological transformations to prepare data for model training.
- **Pattern Recognition**: Use machine learning algorithms to classify the shapes of colloids.

## Getting Started

### Prerequisites
- Python 3.8 or higher
- OpenCV
- NumPy
- Optional: TensorFlow or PyTorch for more advanced machine learning models

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/colloid-pattern-detection.git
2. Navigate to the project directory:
cd colloid-pattern-detection
3. Install required Python libraries:
pip install -r requirements.txt

4. Running the Project
python src/preprocessing.py
