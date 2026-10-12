#!/usr/bin/env python3
"""Render the HANARI launcher artwork to opaque and Android adaptive PNGs."""

from math import cos, pi, sin
from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parent
SIZE = 1024
SCALE = 3
INK = "#342B32"
ROSE = "#D96B86"


def cubic(start, control1, control2, end, steps=40):
    points = []
    for index in range(steps + 1):
        t = index / steps
        u = 1 - t
        points.append(
            (
                (u**3 * start[0] + 3 * u**2 * t * control1[0]
                 + 3 * u * t**2 * control2[0] + t**3 * end[0]) * SCALE,
                (u**3 * start[1] + 3 * u**2 * t * control1[1]
                 + 3 * u * t**2 * control2[1] + t**3 * end[1]) * SCALE,
            )
        )
    return points


def draw_icon_art(draw):
    # A clear hanok front, with its lifted tiled roof as the central silhouette.
    facade = [(245, 470), (512, 350), (779, 470), (779, 846), (245, 846)]
    draw.polygon([(x * SCALE, y * SCALE) for x, y in facade], fill="#FFF8ED")
    draw.line([(270 * SCALE, 498 * SCALE), (754 * SCALE, 498 * SCALE)],
              fill=ROSE, width=26 * SCALE)
    draw.line([(286 * SCALE, 500 * SCALE), (286 * SCALE, 836 * SCALE)],
              fill=INK, width=23 * SCALE)
    draw.line([(738 * SCALE, 500 * SCALE), (738 * SCALE, 836 * SCALE)],
              fill=INK, width=23 * SCALE)

    draw.rectangle((386 * SCALE, 561 * SCALE, 638 * SCALE, 848 * SCALE),
                   fill="#417C72", outline=INK, width=20 * SCALE)
    draw.line([(512 * SCALE, 571 * SCALE), (512 * SCALE, 838 * SCALE)],
              fill="#F8D376", width=13 * SCALE)
    draw.line([(403 * SCALE, 632 * SCALE), (621 * SCALE, 632 * SCALE)],
              fill="#F8D376", width=13 * SCALE)
    draw.polygon([(370 * SCALE, 846 * SCALE), (654 * SCALE, 846 * SCALE),
                  (688 * SCALE, 888 * SCALE), (336 * SCALE, 888 * SCALE)], fill=INK)

    roof = []
    roof += cubic((92, 424), (183, 413), (253, 385), (322, 321))
    roof += cubic((322, 321), (395, 253), (454, 197), (512, 162))[1:]
    roof += cubic((512, 162), (571, 197), (630, 253), (703, 321))[1:]
    roof += cubic((703, 321), (771, 384), (841, 413), (932, 424))[1:]
    roof += cubic((932, 424), (907, 452), (874, 474), (843, 485))[1:]
    roof += cubic((843, 485), (766, 470), (701, 435), (648, 420))[1:]
    roof += cubic((648, 420), (596, 395), (553, 375), (512, 372))[1:]
    roof += cubic((512, 372), (471, 375), (428, 395), (374, 420))[1:]
    roof += cubic((374, 420), (321, 435), (257, 470), (181, 485))[1:]
    roof += cubic((181, 485), (149, 474), (117, 452), (92, 424))[1:]
    draw.polygon(roof, fill=INK)

    edge = cubic((175, 455), (291, 396), (385, 330), (454, 321))
    edge += cubic((454, 321), (475, 317), (493, 315), (512, 315))[1:]
    edge += cubic((512, 315), (531, 315), (549, 317), (570, 321))[1:]
    edge += cubic((570, 321), (647, 330), (733, 396), (849, 455))[1:]
    draw.line(edge, fill=ROSE, width=17 * SCALE, joint="curve")


def draw_blossom(draw, cx, cy, radius, petal_fill, center_radius):
    for index in range(5):
        angle = -pi / 2 + index * 2 * pi / 5
        px = cx + cos(angle) * radius * 0.67
        py = cy + sin(angle) * radius * 0.67
        box = ((px - radius * 0.42) * SCALE, (py - radius * 0.68) * SCALE,
               (px + radius * 0.42) * SCALE, (py + radius * 0.68) * SCALE)
        draw.ellipse(box, fill=petal_fill)
    draw.ellipse(((cx - center_radius) * SCALE, (cy - center_radius) * SCALE,
                  (cx + center_radius) * SCALE, (cy + center_radius) * SCALE),
                 fill=ROSE)


def render_layers():
    px_size = SIZE * SCALE
    background = Image.new("RGBA", (px_size, px_size))
    pixels = background.load()
    top = (247, 184, 194)
    bottom = (255, 226, 170)
    for y in range(px_size):
        t = y / (px_size - 1)
        color = tuple(round(a * (1 - t) + b * t) for a, b in zip(top, bottom))
        for x in range(px_size):
            pixels[x, y] = (*color, 255)

    art = Image.new("RGBA", (px_size, px_size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(art)
    sun_box = (516 * SCALE, 118 * SCALE, 884 * SCALE, 486 * SCALE)
    draw.ellipse(sun_box, fill="#FFB85E")
    draw.ellipse((544 * SCALE, 146 * SCALE, 856 * SCALE, 458 * SCALE),
                fill="#FFC762")
    draw_blossom(draw, 218, 236, 48, "#FFF2EB", 17)
    draw_blossom(draw, 843, 220, 31, "#FCE9E4", 11)
    draw_icon_art(draw)
    background.alpha_composite(art)

    opaque = background.convert("RGB").resize((SIZE, SIZE), Image.Resampling.LANCZOS)
    opaque.save(ROOT / "hanari_app_icon.png", format="PNG", optimize=True)

    # Keep all important artwork inside the Android adaptive-icon safe area.
    foreground = Image.new("RGBA", (px_size, px_size), (0, 0, 0, 0))
    foreground.alpha_composite(art)
    foreground = foreground.resize((round(px_size * 0.78), round(px_size * 0.78)),
                                   Image.Resampling.LANCZOS)
    adaptive = Image.new("RGBA", (px_size, px_size), (0, 0, 0, 0))
    adaptive.alpha_composite(foreground, ((px_size - foreground.width) // 2,
                                          (px_size - foreground.height) // 2))
    adaptive.resize((SIZE, SIZE), Image.Resampling.LANCZOS).save(
        ROOT / "hanari_adaptive_foreground.png", format="PNG", optimize=True
    )


if __name__ == "__main__":
    render_layers()
