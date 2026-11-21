"""Draw the wallpaper: utility poles and humming wires against a black sky.

Output is deterministic. Only pure-white aliased strokes and an ordered-dither
horizon are used, so it keeps the look of a 1-bit display from the late 90s.
"""
import math
import sys

from PIL import Image, ImageDraw, ImageFont

W, H = 1920, 1080
out, font_path = sys.argv[1], sys.argv[2]

img = Image.new("L", (W, H), 0)
px = img.load()
draw = ImageDraw.Draw(img)

BAYER = [
    [0, 8, 2, 10],
    [12, 4, 14, 6],
    [3, 11, 1, 9],
    [15, 7, 13, 5],
]

# A faint dithered glow rising from the horizon.
horizon = 905
for y in range(horizon - 210, horizon):
    strength = ((y - (horizon - 210)) / 210) ** 3 * 0.62
    for x in range(W):
        if strength * 16 > BAYER[y % 4][x % 4] + 0.5:
            px[x, y] = 92

draw.rectangle([0, horizon, W, H], fill=0)
draw.line([0, horizon, W, horizon], fill=120, width=1)

# (x, top y, scale), receding from near-right to far-left.
poles = [
    (2240, -120, 2.1),
    (1510, 150, 1.0),
    (1130, 372, 0.56),
    (880, 520, 0.33),
    (720, 618, 0.2),
    (620, 682, 0.12),
    (556, 725, 0.07),
    (-300, 840, 0.04),
]


def arm_points(x, top, s):
    """Attachment points on the two crossarms of a pole."""
    pts = []
    for row, (dy, half) in enumerate([(70, 112), (150, 86)]):
        y = top + dy * s
        for off in ([-1, -0.34, 0.34, 1] if row == 0 else [-1, 1]):
            pts.append((x + off * half * s, y))
    return pts


def wire(a, b, sag):
    steps = max(24, int(abs(a[0] - b[0]) / 4))
    points = []
    for i in range(steps + 1):
        t = i / steps
        x = a[0] + (b[0] - a[0]) * t
        y = a[1] + (b[1] - a[1]) * t + sag * (1 - (2 * t - 1) ** 2)
        points.append((x, y))
    return points


for near, far in zip(poles, poles[1:]):
    a_pts, b_pts = arm_points(*near), arm_points(*far)
    span = math.hypot(near[0] - far[0], near[1] - far[1])
    for a, b in zip(a_pts, b_pts):
        draw.line(wire(a, b, span * 0.055), fill=225, width=1)

for x, top, s in poles:
    if not 0 < x < W:
        continue
    width = max(1, round(9 * s))
    draw.line([x, top, x, horizon], fill=255, width=width)
    for dy, half in [(70, 122), (150, 96)]:
        y = top + dy * s
        draw.line(
            [x - half * s, y, x + half * s, y],
            fill=255,
            width=max(1, round(6 * s)),
        )

# A transformer on the second pole, the only filled-in mass in the frame.
tx, ty, s = poles[1]
draw.rectangle([tx + 12, ty + 205, tx + 66, ty + 318], outline=255, width=2)
for y in range(int(ty + 215), int(ty + 310), 12):
    draw.line([tx + 20, y, tx + 58, y], fill=150)
draw.line([tx, ty + 230, tx + 12, ty + 230], fill=255, width=2)
draw.line([tx, ty + 300, tx + 12, ty + 300], fill=255, width=2)

font = ImageFont.truetype(font_path, 11)
left = 44
draw.text((left, 958), "present day", font=font, fill=205)
draw.text((left, 974), "present time", font=font, fill=205)
draw.text((left, 1006), "layer:01 / navi", font=font, fill=110)

img.convert("RGB").save(out, "PNG", optimize=True)
