import random
import argparse
import json
import os
from pathlib import Path
from datetime import datetime

now = datetime.now()
minutes = now.hour * 60 + now.minute
id = (minutes // 2) % 720
# print(minutes)

parser = argparse.ArgumentParser()
parser.add_argument("pokesprite", type=str)
parser.add_argument("-f", action="store_true")
parser.add_argument("-s", action="store_true")
args = parser.parse_args()

f = Path(args.pokesprite) / "data" / "pokemon.json"
assert f.exists()

index = json.load(f.open())
# print(index[f'{id:03}'])

f = (
    Path(args.pokesprite)
    / "pokemon-gen8"
    / ("shiny" if args.s or minutes % 2 == 1 else "regular")
    / ("female" if args.f else "")
)

select = list(f.glob(index[f"{id:03}"]["slug"]["eng"] + "*"))
if args.f and len(select) == 0:
    select = list((f / "..").glob(index[f"{id:03}"]["slug"]["eng"] + "*"))
select = random.choice(select)
# print(select)

base = Path(os.environ["XDG_RUNTIME_DIR"])
img = base / "pokemon.png"
name = base / "pokemon"

chsname = index[f"{id:03}"]["name"]["chs"]
name.write_text(chsname)

os.system(f"magick {select.as_posix()} -trim {img.as_posix()}")
if os.environ.get("WSL_DISTRO_NAME") is None:
    os.system(f"catimg {img.as_posix()}")
