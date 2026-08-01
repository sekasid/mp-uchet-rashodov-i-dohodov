# -*- coding: utf-8 -*-
from pathlib import Path
import re

src = Path(r"E:\1C_projects\mapp_git_cursor\Категории.txt")
lines = src.read_text(encoding="utf-8", errors="replace").splitlines()
unique = sorted({l.strip() for l in lines if l.strip() and l.strip().lower() != "видплатежа"}, key=lambda s: s.casefold())
plain = [u for u in unique if not re.match(r"(?i)^разное\b", u)]
raznoe = [u for u in unique if re.match(r"(?i)^разное\b", u)]
inside = sorted({re.sub(r"(?i)^разное\s*\((.+)\)\s*$", r"\1", u).strip() for u in raznoe if "(" in u}, key=str.casefold)

out = Path(r"E:\1C_projects\mapp_git_cursor\МП_Учет_расходов_и_Доходов\docs\Категории_уникальные.txt")
parts = [
    f"Всего уникальных: {len(unique)}",
    f"Без «Разное»: {len(plain)}",
    f"С «Разное»: {len(raznoe)}",
    f"Уникальных уточнений в скобках: {len(inside)}",
    "",
    "=== БАЗОВЫЕ (без Разное) ===",
    *plain,
    "",
    "=== РАЗНОЕ (полные) ===",
    *raznoe,
    "",
    "=== УТОЧНЕНИЯ В СКОБКАХ ===",
    *inside,
]
out.write_text("\n".join(parts), encoding="utf-8")
print(f"written {out}")
print(f"unique={len(unique)} plain={len(plain)} raznoe={len(raznoe)} inside={len(inside)}")
