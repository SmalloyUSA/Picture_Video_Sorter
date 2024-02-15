#!/usr/bin/env python

import tkinter as tk
from tkinter import filedialog
import os
import shutil
from datetime import datetime

def get_older_date(date1, date2):
    return min(date1, date2)

def create_review_directory(base_path):
    review_directory = os.path.join(base_path, "Pictures and Files Review")
    if not os.path.exists(review_directory):
        os.makedirs(review_directory)
    return review_directory

def move_files_to_review(file_path, review_directory):
    shutil.move(file_path, review_directory)

def sort_files_into_folders(selected_directory, review_directory):
    for root, dirs, files in os.walk(selected_directory, topdown=False):
        for name in files:
            try:
                file_path = os.path.join(root, name)
                creation_date = datetime.fromtimestamp(os.path.getctime(file_path))
                modified_date = datetime.fromtimestamp(os.path.getmtime(file_path))
                older_date = get_older_date(creation_date, modified_date)

                target_folder_name = older_date.strftime('%Y-%m')
                target_folder = os.path.join(selected_directory, target_folder_name)
                if not os.path.exists(target_folder):
                    os.makedirs(target_folder)

                base_name = older_date.strftime('%Y%m%d')
                extension = os.path.splitext(name)[1]
                new_file_name = base_name + extension
                new_file_path = os.path.join(target_folder, new_file_name)

                counter = 1
                while os.path.exists(new_file_path) or "copy" in name:
                    new_file_name = f"{base_name}_{counter}{extension}"
                    new_file_path = os.path.join(target_folder, new_file_name)
                    counter += 1

                shutil.move(file_path, new_file_path)
            except Exception as e:
                move_files_to_review(file_path, review_directory)

def main():
    root = tk.Tk()
    root.withdraw()  # Hide the main window
    selected_directory = filedialog.askdirectory(title="Select the directory that contains the images and files")

    if not selected_directory:
        print("No folder was selected.")
        return

    review_directory = create_review_directory(selected_directory)

    # Process files
    sort_files_into_folders(selected_directory, review_directory)

    print("Operation completed.")

if __name__ == "__main__":
    main()
