import cv2
import numpy as np
import matplotlib.pyplot as plt

# params
aruco_dict_types = [cv2.aruco.DICT_4X4_100,
                    cv2.aruco.DICT_5X5_100,
                    cv2.aruco.DICT_6X6_100,
                    cv2.aruco.DICT_7X7_100]

names = ["4x4_100", "5x5_100", "6x6_100", "7x7_100"]

# functions
def get_binary_array_from_dict(dictionary, marker_id: int) -> np.ndarray:
    """
    Extracts a binary array from a dictionary based on the marker ID.
    """

    # Get the marker size
    marker_size = dictionary.markerSize
    # print(f"Marker size: {marker_size}x{marker_size}")

    # Get the raw byte list (binary representation)
    bytes_list = dictionary.bytesList  # Shape: (num_markers, marker_size**2 // 8, 1)

    # Inspect the specified marker ID
    binary_data = np.unpackbits(bytes_list[marker_id])[:marker_size**2].reshape(marker_size, marker_size)

    return binary_data


def plot_aruco_from_array(marker_array: np.ndarray, border_size: int = 1):
    """
    Visualizes an ArUco marker from a binary array with a black border.

    Parameters:
        marker_array (np.ndarray): A binary array representing the marker.
        border_size (int): The width of the black border (default: 1 cell wide).
    """
    marker_size = int(np.sqrt(len(marker_array)))
    if len(marker_array) != marker_size * marker_size:
        raise ValueError("Input must be a square binary array.")

    # Reshape to square grid
    marker_matrix = np.array(marker_array).reshape(marker_size, marker_size)

    # Add a black border (pad with zeros)
    marker_with_border = np.pad(marker_matrix, pad_width=border_size, mode='constant', constant_values=0)

    # Plot the marker with border
    plt.figure(figsize=(3, 3))
    plt.imshow(marker_with_border, cmap="gray", interpolation="nearest")
    plt.axis("off")
    plt.title("ArUco Marker with Border")
    plt.show()


def save_aruco_dict_to_file(aruco_dict, filename: str) -> None:
    fs = cv2.FileStorage(filename, cv2.FILE_STORAGE_WRITE)
    aruco_dict.writeDictionary(fs)
    fs.release()  # Ensure the file is closed


def main():
    for aruco_dict_type, name in zip(aruco_dict_types, names):
        # Load an ArUco dictionary
        dictionary = cv2.aruco.getPredefinedDictionary(aruco_dict_type)

        save_aruco_dict_to_file(dictionary, f"./data/aruco_dicts/aruco_dict_{name}.yaml")
        # save_aruco_dict_to_file(dictionary, f"aruco_dict_{name}.yaml")

if __name__ == "__main__":
    main()
