import os
import sys
from urllib.parse import quote

input_dir = sys.argv[1]

for filename in os.listdir(input_dir):
    old_path = os.path.join(input_dir, filename)
    
    encoded_name = quote(filename)
    new_path = os.path.join(input_dir, encoded_name)
    
    os.rename(old_path, new_path)