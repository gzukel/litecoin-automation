import json
import os
mapping_file_path=os.environ["mapping_file_path"]
load_mapping_contents=open(mapping_file_path, "r").read()
json_object=json.loads(load_mapping_contents)
open_github_file=open(os.environ["GITHUB_ENV"], "a")
source_github_file=open("tmp_source", "w")
for key in json_object:
    open_github_file.write("{key}='{value}'".format(key=key, value=json_object[key]))
    source_github_file.write("export {key}='{value}' \n echo \"::add-mask::${key}\"".format(key=key, value=json_object[key]))
open_github_file.close()
source_github_file.close()