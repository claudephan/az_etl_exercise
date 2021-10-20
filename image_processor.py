import numpy as np
import pandas as pd
import PIL
from PIL import Image
from PIL import ImageFilter
import pathlib
import os
import cv2
import matplotlib.pyplot as plt
from dotenv import load_dotenv

def CheckDir(path):
    isExist = os.path.exists(path)

    if not isExist:
    # Create a new directory because it does not exist 
        os.makedirs(path)

def FlipHorizontally(base_path, img_path):
    outPath = base_path + "/images_flip_horizontal"
    CheckDir(outPath)
    
    for imagePath in os.listdir(img_path):
        # imagePath contains name of the image 
        inputPath = os.path.join(img_path, imagePath)
  
        # inputPath contains the full directory name
        img = Image.open(inputPath)
  
        fullOutPath = os.path.join(outPath, 'flip_horizontal_'+imagePath)
        # fullOutPath contains the path of the output
        # image that needs to be generated
        img.transpose(PIL.Image.FLIP_TOP_BOTTOM).save(fullOutPath)
    print("Completed Horizontal Flip")

def FlipVertically(base_path, img_path):
    outPath = base_path + "/images_flip_vertical"
    CheckDir(outPath)

    for imagePath in os.listdir(img_path):
        # imagePath contains name of the image 
        inputPath = os.path.join(img_path, imagePath)
  
        # inputPath contains the full directory name
        img = Image.open(inputPath)
  
        fullOutPath = os.path.join(outPath, 'flip_vertical_'+imagePath)
        # fullOutPath contains the path of the output
        # image that needs to be generated
        img.transpose(PIL.Image.FLIP_LEFT_RIGHT).save(fullOutPath)
    print("Completed Vertical Flip")

def RotateImage(base_path, img_path):
    outPath = base_path + "/images_rotated_30"
    CheckDir(outPath)

    for imagePath in os.listdir(img_path):
        # imagePath contains name of the image 
        inputPath = os.path.join(img_path, imagePath)
  
        # inputPath contains the full directory name
        img = Image.open(inputPath)
  
        fullOutPath = os.path.join(outPath, 'rotate_30_'+imagePath)
        # fullOutPath contains the path of the output
        # image that needs to be generated
        img.rotate(30).save(fullOutPath)
    print("Completed Image Rotation")

def BlurImage(base_path, img_path, filterSize):
    outPath = base_path + "/images_blur_filter" + str(filterSize)
    CheckDir(outPath)

    for imagePath in os.listdir(img_path):
        # imagePath contains name of the image 
        inputPath = os.path.join(img_path, imagePath)
  
        # inputPath contains the full directory name
        img = Image.open(inputPath)
  
        fullOutPath = os.path.join(outPath, 'blur_' + str(filterSize) + '_'+imagePath)
        # fullOutPath contains the path of the output
        # image that needs to be generated
        # img.rotate(30).save(fullOutPath)
        dst = cv2.GaussianBlur(np.asarray(img),(filterSize,filterSize),cv2.BORDER_DEFAULT)
        im = Image.fromarray(dst)
        im.save(fullOutPath)
    print("Completed Image Gaussian Blur with Filter size " + str(filterSize))

if __name__ == "__main__":
    #Load variables from .env
    load_dotenv()
    base_path = os.getenv('BASE_PATH')
    
    #Verify images can be found
    img_path = pathlib.Path(base_path + '/train')
    image_count = len(list(img_path.glob('*.jpg')))
    print("Total Images: " + str(image_count))

    FlipHorizontally(base_path, img_path)
    FlipVertically(base_path, img_path)
    RotateImage(base_path, img_path)
    BlurImage(base_path, img_path, 3)
    BlurImage(base_path, img_path, 7)


