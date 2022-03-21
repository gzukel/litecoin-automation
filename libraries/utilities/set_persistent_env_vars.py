import os
import json
vars_file=open(os.environ["vars_file_location"], "r").read()
json_var_object = json.loads(vars_file)
append_github_file = open(os.environ["GITHUB_ENV"], "a")
for key in json_var_object:
    value = json_var_object[key]
    key_value_string = key + "=" + value + "\n"
    append_github_file.write(key_value_string)
append_github_file.close()
