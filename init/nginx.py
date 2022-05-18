
from jinja2 import Template
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-msg', '--message', required=True)
    args = parser.parse_args()

    msg = args.message

    with open('index.jinja') as file_:
        spine_template = Template(file_.read())

    with open(f"index.html", "w") as fh:
            fh.write(spine_template.render(message=msg))