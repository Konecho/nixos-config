from os import environ
from subprocess import run
from . import WallpaperProvider as _WProv
from shutil import which


class SwwwProvider(_WProv):
    def change_wallpaper(path: str):
        run(["swww", "img", f"{path}"], env=environ, check=True)

    def is_compatible() -> bool:
        return which("swww") is not None

    def __str__():
        return "swww"
