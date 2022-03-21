import json
import os

input_template_file_contents=open(os.environ["INPUT_FILE"], "r").read()
output_template_file=open(os.environ["OUTPUT_FILE"], "w")

for key in os.environ.keys():
    if str(key) in str(input_template_file_contents):
        print("Found {key} in file {input_file} contents replacing with value".format(key=key, input_file=os.environ["INPUT_FILE"]))
        input_template_file_contents=input_template_file_contents.replace("-={key}=-".format(key=key), os.environ[key])

print("Write Replaced File Contents..")
output_template_file.write(input_template_file_contents)
output_template_file.close()
print("Remove Input File..")
os.remove(os.environ["INPUT_FILE"])