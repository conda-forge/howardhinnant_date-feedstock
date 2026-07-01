#!/usr/bin/env bash
set -euxo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}"

python check_package_libs.py static

howardhinnant_date_sh_pkg="$(ls "$(dirname "$(dirname "${PREFIX}")")/linux-64"/howardhinnant_date-*.conda | grep -v static | head -1)"
test -n "${howardhinnant_date_sh_pkg}"
conda install --no-deps -y -p "${PREFIX}" "${howardhinnant_date_sh_pkg}"

test -d "${PREFIX}/include/date"
test -f "${PREFIX}/include/date/date.h"
test -f "${PREFIX}/lib/cmake/date/dateConfig.cmake"

cmake . -GNinja -DCMAKE_BUILD_TYPE=Release -DUSE_STATIC_TZ=ON
cmake --build . --config Release
ln -sf "${PREFIX}/share/zoneinfo/UTC" "${PREFIX}/share/zoneinfo/CondaTest"
./program
