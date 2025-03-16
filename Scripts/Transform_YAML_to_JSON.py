# NOTE: Ensure you have PyYAML installed
# python3 -m pip install PyYAML

import os
import sys
import yaml
import json

def main(source_dir, output_dir):
    for filename in os.listdir(source_dir):
        if filename.endswith('.yaml') or filename.endswith('.yml'):
            yaml_path = os.path.join(source_dir, filename)
            json_filename = os.path.splitext(filename)[0] + '.json'
            json_path = os.path.join(output_dir, json_filename)

            try:
                with open(yaml_path, 'r') as yaml_file:
                    content = yaml_file.read()
                    content = content.replace('%YAML:1.0', '%YAML 1.0') # Address OpenCV's YAML format incompatibility
                    yaml_data = yaml.safe_load(content)

                with open(json_path, 'w') as json_file:
                    # json.dump(yaml_data, json_file) # minify # NOTE: file size is not hugely different.
                    json.dump(yaml_data, json_file, indent=2)

                print(f"Converted {filename} to {json_filename}")
            except Exception as e:
                print(f"Error converting {filename}: {e}")
                sys.exit(1)

if __name__ == "__main__":
    source_dir = 'data/aruco_dicts'
    output_dir = 'data/aruco_dicts'

    main(source_dir, output_dir)
