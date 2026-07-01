#!/usr/bin/env python3
import glob
import json
import os
import sys

PREFIX = os.environ["PREFIX"]
LIBRARY_PREFIX = os.environ.get("LIBRARY_PREFIX", os.path.join(PREFIX, "Library"))
LIBRARY_LIB = os.environ.get("LIBRARY_LIB", os.path.join(LIBRARY_PREFIX, "lib"))


def package_files(package: str) -> list[str]:
    if package == "shared":
        metas = [
            m
            for m in glob.glob(os.path.join(PREFIX, "conda-meta", "howardhinnant_date-*.json"))
            if "static" not in os.path.basename(m)
        ]
    elif package == "static":
        metas = glob.glob(os.path.join(PREFIX, "conda-meta", "howardhinnant_date-static-*.json"))
    else:
        raise SystemExit(f"unknown package kind: {package}")

    if not metas:
        raise SystemExit(f"no conda-meta entry for {package}")

    files: list[str] = []
    for meta in metas:
        with open(meta, encoding="utf-8") as f:
            files.extend(json.load(f).get("files", []))
    return [f.replace("\\", "/") for f in files]


def is_static_artifact(path: str) -> bool:
    return path.endswith("lib/libdate-tz.a") or path.endswith("Library/lib/date-tz_static.lib")


def is_shared_artifact(path: str) -> bool:
    return (
        "/lib/libdate-tz.so" in path
        or path.endswith("/lib/libdate-tz.dylib")
        or "libdate-tz.so." in path
        or path.endswith("/bin/date-tz.dll")
        or path.endswith("/lib/date-tz.lib")
    )


def check_prefix_shared_present() -> None:
    if sys.platform == "win32":
        dll = os.path.join(LIBRARY_PREFIX, "bin", "date-tz.dll")
        implib = os.path.join(LIBRARY_LIB, "date-tz.lib")
        if not os.path.isfile(dll):
            raise SystemExit(f"missing shared library: {dll}")
        if not os.path.isfile(implib):
            raise SystemExit(f"missing import library: {implib}")
        return

    libdir = os.path.join(PREFIX, "lib")
    shared_libs = glob.glob(os.path.join(libdir, "libdate-tz.so")) + glob.glob(
        os.path.join(libdir, "libdate-tz.so.*")
    ) + glob.glob(os.path.join(libdir, "libdate-tz.dylib")) + glob.glob(
        os.path.join(libdir, "libdate-tz.*.dylib")
    )
    if not shared_libs:
        raise SystemExit(f"missing shared library in {libdir}")


def check_prefix_static_absent() -> None:
    if sys.platform == "win32":
        static_lib = os.path.join(LIBRARY_LIB, "date-tz_static.lib")
        if os.path.isfile(static_lib):
            raise SystemExit(f"static library must not be present: {static_lib}")
        return

    static_lib = os.path.join(PREFIX, "lib", "libdate-tz.a")
    if os.path.isfile(static_lib):
        raise SystemExit(f"static library must not be present: {static_lib}")


def check_prefix_static_present() -> None:
    if sys.platform == "win32":
        static_lib = os.path.join(LIBRARY_LIB, "date-tz_static.lib")
        if not os.path.isfile(static_lib):
            raise SystemExit(f"missing static library: {static_lib}")
        return

    static_lib = os.path.join(PREFIX, "lib", "libdate-tz.a")
    if not os.path.isfile(static_lib):
        raise SystemExit(f"missing static library: {static_lib}")


def check_prefix_shared_absent() -> None:
    if sys.platform == "win32":
        dll = os.path.join(LIBRARY_PREFIX, "bin", "date-tz.dll")
        implib = os.path.join(LIBRARY_LIB, "date-tz.lib")
        if os.path.isfile(dll):
            raise SystemExit(f"shared library must not be present: {dll}")
        if os.path.isfile(implib):
            raise SystemExit(f"import library must not be present: {implib}")
        return

    libdir = os.path.join(PREFIX, "lib")
    shared_libs = glob.glob(os.path.join(libdir, "libdate-tz.so")) + glob.glob(
        os.path.join(libdir, "libdate-tz.so.*")
    ) + glob.glob(os.path.join(libdir, "libdate-tz.dylib")) + glob.glob(
        os.path.join(libdir, "libdate-tz.*.dylib")
    )
    if shared_libs:
        raise SystemExit(f"shared library must not be present: {shared_libs}")


def check_manifest(package: str) -> None:
    files = package_files(package)

    if package == "shared":
        if not any(is_shared_artifact(f) for f in files):
            raise SystemExit(f"shared package missing shared library, files={files!r}")
        if any(is_static_artifact(f) for f in files):
            raise SystemExit(f"shared package must not ship static library, files={files!r}")
    else:
        if not any(is_static_artifact(f) for f in files):
            raise SystemExit(f"static package missing static library, files={files!r}")
        if any(is_shared_artifact(f) for f in files):
            raise SystemExit(f"static package must not ship shared library, files={files!r}")


def main() -> None:
    package = sys.argv[1]

    if package == "shared":
        check_prefix_shared_present()
        check_prefix_static_absent()
    elif package == "static":
        check_prefix_static_present()
        check_prefix_shared_absent()
    else:
        raise SystemExit(f"unknown package kind: {package}")

    check_manifest(package)


if __name__ == "__main__":
    main()
