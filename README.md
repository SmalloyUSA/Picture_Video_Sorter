# Picture_Video_Sorter

The Python script is designed to organize files within a selected directory, particularly focusing on image files. Here's a summary of its key functionalities:

WARNING!!! The Powershell script will delete sub-dictories after removing pictures videos and files from them and sorting them by month and year into new sub directoires during testing. The Python script from testing leaves the old subdierctoires. Use catuion when using this script "ONLY USE ON BACKED UP FILES" If you use PS Script and want to keep your Directory sturcutre you will need to use the GUI to drill down into your Picture/Video sub-dictories and sort each indiviual sub directory. This script is intended to help sort directoies with no structure. Olny supports MP4 Videos but can be easyliy modified to allow more formats. This script may or may not DELETE DATA, Testing shows index.bin files and subdiecrtories do get deleted when PS script runs. Both Scripts delete the index bin file.

There is also a PowerShell Version of this Script available.

1. Directory Selection: When executed, the script opens a file dialog window allowing the user to select a directory. This directory is assumed to contain various files, including images, that the user wishes to organize.
2. Review Directory Creation: The script creates a subdirectory named "Pictures and Files Review" within the selected directory. This subdirectory is intended to hold any files that require further review or manual sorting, particularly in cases where the automatic sorting process encounters issues.
3. File Sorting and Organization: The script processes all files within the selected directory and its subdirectories. The primary focus is on image files, identified by their extensions (e.g., jpg, jpeg, png, gif). For each image file, the script compares the file's creation and last modified dates and uses the older of the two as the reference date for sorting.
4. Dynamic Folder Creation Based on Dates: Based on the reference date determined for each image file, the script creates new folders within the selected directory, named according to the year and month of the reference date (in the "YYYY-MM" format). This organization scheme groups images by the month and year of their reference dates, making it easier to locate and review images based on when they were created or last modified.
5. File Renaming and Conflict Handling: To avoid overwriting files with the same name, the script renames each image file using the reference date in the "YYYYMMDD" format, adding a numerical suffix if necessary (e.g., when multiple images have the same reference date). If the script encounters files with the name including "copy" or if there's a potential overwrite situation, it employs a counter to append a unique suffix, ensuring each file has a distinct name.
6. Review Directory for Unsorted Files: Any files that cannot be sorted automatically due to errors or exceptions are moved to the "Pictures and Files Review" directory. This ensures that the user can manually review and sort these files later, maintaining the integrity of the automated sorting process.
7. Completion Message: After processing all files, the script prints a message indicating that the operation is completed, signaling to the user that the sorting and organization task has been finished.
Overall, the script automates the organization of image files within a selected directory, creating a structured and date-based filing system that facilitates easier management and retrieval of images.

Desktop Launcher
• For Linux: Create a .desktop file with the following content, adjusting paths as necessary:
[Desktop Entry]
Type=Application
Name=My Script
Exec=/path/to/your/executable
Icon=/path/to/your/icon.png
Terminal=false


To create a desktop launcher for a Windows application, particularly for the executable Python script we discussed earlier, you can follow these steps:
1. Locate the Executable: Ensure your Python script has been converted to an executable using a tool like PyInstaller, and note the path where the executable is stored.
2. Create Shortcut:
	• Navigate to the executable file in Windows Explorer.
	• Right-click on the executable file.
	• Choose Send to > Desktop (create shortcut).
3. Customize Shortcut (Optional):
	• Right-click on the newly created shortcut on your desktop.
	• Select Properties.
	• In the Shortcut tab, you can modify:
		○ Start in: The default working directory for the application (usually the directory of the executable).
		○ Shortcut key: A keyboard shortcut to launch the application.
		○ Run: Whether the application runs in a normal window, minimized, or maximized.
	• In the General tab, you can rename the shortcut to whatever you prefer.
	• To change the icon:
		○ In the Shortcut tab of the properties window, click on Change Icon.
		○ Choose an icon from the list or browse to a custom .ico file.
		○ Click OK to apply the changes.
4. Test the Shortcut: Double-click the shortcut to ensure it launches your Python application as expected.
By following these steps, you will have created a desktop launcher for your Python executable on Windows, allowing for easy access and execution of your application.

---------------------------------------------------------------------------------------------------------------

Let's break down the Python script into its individual lines and provide a summary for each, explaining their purpose and functionality:

1. import tkinter as tk: Imports the tkinter module, which is used for creating GUI elements, such as dialog windows in Python applications.
2. from tkinter import filedialog: Imports the filedialog submodule from tkinter, specifically for opening file dialog windows that allow users to select files or directories.
3. import os: Imports the os module, which provides functions to interact with the operating system, including file and directory operations.
4. import shutil: Imports the shutil module, which offers high-level file operations, such as copying and moving files.
5. from datetime import datetime: Imports the datetime class from the datetime module, used for handling date and time information.
6. def get_older_date(date1, date2):: Defines a function get_older_date that takes two dates as arguments.
7. return min(date1, date2): Returns the older (earlier) of the two dates by using the min function.
8. def create_review_directory(base_path):: Defines a function to create a "Pictures and Files Review" directory within the given base path.
9. review_directory = os.path.join(base_path, "Pictures and Files Review"): Constructs the full path for the review directory by joining the base path with the directory name.
10. if not os.path.exists(review_directory):: Checks if the review directory does not already exist.
11. os.makedirs(review_directory): Creates the review directory along with any necessary parent directories.
12. return review_directory: Returns the path of the review directory.
13. def move_files_to_review(file_path, review_directory):: Defines a function to move files to the review directory.
14. shutil.move(file_path, review_directory): Moves the specified file to the review directory.
15. def sort_files_into_folders(selected_directory, review_directory):: Defines a function for sorting files into folders based on their dates.
16. for root, dirs, files in os.walk(selected_directory, topdown=False):: Iterates over the files in the selected directory, including its subdirectories.
17. for name in files:: Loops through each file in the current directory.
18. try:: Starts a try block to catch any exceptions that might occur during file processing.
19. file_path = os.path.join(root, name): Constructs the full path of the current file.
20. creation_date = datetime.fromtimestamp(os.path.getctime(file_path)): Gets the creation date of the file.
21. modified_date = datetime.fromtimestamp(os.path.getmtime(file_path)): Gets the last modified date of the file.
22. older_date = get_older_date(creation_date, modified_date): Determines the older date between creation and modified dates.
23. target_folder_name = older_date.strftime('%Y-%m'): Formats the older date to create a folder name in the "YYYY-MM" format.
24. target_folder = os.path.join(selected_directory, target_folder_name): Constructs the full path for the target folder.
25. if not os.path.exists(target_folder):: Checks if the target folder does not exist.
26. os.makedirs(target_folder): Creates the target folder.
27. base_name = older_date.strftime('%Y%m%d'): Formats the older date to create a base name for the file.
28. extension = os.path.splitext(name)[1]: Extracts the file extension.
29. new_file_name = base_name + extension: Constructs the new file name using the base name and extension.
30. new_file_path = os.path.join(target_folder, new_file_name): Constructs the full path for the new file.
31. counter = 1: Initializes a counter for file naming conflicts.
32. while os.path.exists(new_file_path) or "copy" in name:: Checks for file name conflicts or if "copy" is in the original file name.
33. new_file_name = f"{base_name}_{counter}{extension}": Creates a new file name with a counter to avoid conflicts.
34. new_file_path = os.path.join(target_folder, new_file_name): Updates the full path for the new file.
35. counter += 1: Increments the counter for the next iteration, if needed.
36. shutil.move(file_path, new_file_path): Moves the original file to the new location with the new name.
37. except Exception as e:: Catches any exceptions that occurred during file processing.
` move_files_to_review(file_path, review_directory)
