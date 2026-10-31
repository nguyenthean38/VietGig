"""Gộp các file ngôn ngữ con (lib/l10n/parts/<nhóm>_vi.arb, <nhóm>_en.arb)
thành lib/l10n/app_vi.arb + app_en.arb rồi chạy `flutter gen-l10n`.

Mỗi nhóm màn hình có file riêng để nhiều người sửa song song không đụng nhau.
Khoá phải có tiền tố theo nhóm (VD: orders..., inbox...) để không trùng.

Chạy:  python tool/l10n_merge.py           (gộp + sinh code)
       python tool/l10n_merge.py --check   (chỉ kiểm tra)
"""

import json
import os
import subprocess
import sys
from collections import OrderedDict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
L10N = os.path.join(ROOT, "lib", "l10n")
PARTS = os.path.join(L10N, "parts")
LOCALES = ("vi", "en")


def load(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f, object_pairs_hook=OrderedDict)


def main():
    # In tiếng Việt được trên console Windows.
    sys.stdout.reconfigure(encoding="utf-8")
    check_only = "--check" in sys.argv
    groups = sorted({f.rsplit("_", 1)[0] for f in os.listdir(PARTS) if f.endswith(".arb")})
    merged = {loc: OrderedDict([("@@locale", loc)]) for loc in LOCALES}
    owner = {}
    errors = []

    for g in groups:
        data = {}
        for loc in LOCALES:
            p = os.path.join(PARTS, f"{g}_{loc}.arb")
            if not os.path.exists(p):
                errors.append(f"Thiếu file {g}_{loc}.arb")
                data[loc] = OrderedDict()
                continue
            try:
                data[loc] = load(p)
            except json.JSONDecodeError as e:
                errors.append(f"{g}_{loc}.arb không phải JSON hợp lệ: {e}")
                data[loc] = OrderedDict()

        vi_keys = [k for k in data["vi"] if not k.startswith("@")]
        en_keys = {k for k in data["en"] if not k.startswith("@")}
        for k in vi_keys:
            if k not in en_keys:
                errors.append(f"[{g}] '{k}' thiếu bản tiếng Anh")
            if k in owner:
                errors.append(f"[{g}] khoá '{k}' trùng với nhóm '{owner[k]}'")
            owner[k] = g
        for k in en_keys - set(vi_keys):
            errors.append(f"[{g}] '{k}' có trong en nhưng không có trong vi")

        for k, v in data["vi"].items():
            if k.startswith("@@"):
                continue
            merged["vi"][k] = v
        for k, v in data["en"].items():
            if k.startswith("@"):
                continue  # metadata lấy từ bản vi
            merged["en"][k] = v

    if errors:
        print("LỖI l10n:")
        for e in errors:
            print("  -", e)
        sys.exit(1)

    total = sum(1 for k in merged["vi"] if not k.startswith("@"))
    print(f"OK: {len(groups)} nhóm, {total} chuỗi")
    if check_only:
        return

    for loc in LOCALES:
        with open(os.path.join(L10N, f"app_{loc}.arb"), "w", encoding="utf-8", newline="\n") as f:
            json.dump(merged[loc], f, ensure_ascii=False, indent=2)
            f.write("\n")

    r = subprocess.run("flutter gen-l10n", cwd=ROOT, shell=True, capture_output=True, text=True, encoding="utf-8")
    out = (r.stdout or "") + (r.stderr or "")
    # Bỏ các dòng thông báo mirror của Flutter.
    out = "\n".join(l for l in out.splitlines() if "storage.flutter-io.cn" not in l)
    if out.strip():
        print(out)
    sys.exit(r.returncode)


if __name__ == "__main__":
    main()
