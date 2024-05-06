import random
import argparse
import json
import os
from pathlib import Path
from datetime import datetime

now = datetime.now()
minutes = now.hour*60+now.minute
id = minutes//2
id = 720 if id == 0 else id
# print(minutes)

parser = argparse.ArgumentParser()
parser.add_argument('pokesprite', type=str)
parser.add_argument('-f', action='store_true')
parser.add_argument('-s', action='store_true')
args = parser.parse_args()

f = Path(args.pokesprite)/'data/pokemon.json'
if not f.exists:
    os.exit(1)
index = json.load(f.open())
# print(index[f'{id:03}'])


f = Path(args.pokesprite)/'pokemon-gen8'
f = f/'shiny' if args.s or minutes % 2 == 1 else f/'regular'
f = f/'female' if args.f else f

select = list(f.glob(index[f'{id:03}']['slug']['eng']+'*'))
if args.f and len(select) == 0:
    select = list((f/'..').glob(index[f'{id:03}']['slug']['eng']+'*'))
select = random.choice(select)
# print(select)

img = Path(os.environ['XDG_RUNTIME_DIR'])/'pokemon.png'
name = Path(os.environ['XDG_RUNTIME_DIR'])/'pokemon'
cnname = index[f'{id:03}']['name']['chs']

os.system(f'convert -trim {select.as_posix()} {img.as_posix()}')
os.system(f'catimg {img.as_posix()}')
os.system(f'echo "{cnname}" > {name.as_posix()}')
