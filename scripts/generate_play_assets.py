from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageDraw, ImageFilter, ImageFont, ImageOps


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = Path(r"C:\Users\ransk\Downloads\Phone Link")
OUTPUT_DIR = ROOT / "docs" / "release" / "assets" / "google_play"
ICON_PATH = ROOT / "android" / "app" / "src" / "main" / "res" / "mipmap-xxxhdpi" / "ic_launcher.png"
FONT_REGULAR = Path(r"C:\Windows\Fonts\segoeui.ttf")
FONT_SEMIBOLD = Path(r"C:\Windows\Fonts\seguisb.ttf")
FONT_BOLD = Path(r"C:\Windows\Fonts\segoeuib.ttf")

PHONE_CANVAS = (1242, 2208)
FEATURE_CANVAS = (1024, 500)

BG_TOP = "#0F1E16"
BG_BOTTOM = "#143327"
ACCENT = "#B7D5B7"
TEXT = "#F3F6F2"
TEXT_MUTED = "#C6D7CA"
PILL = "#E3F0DE"
PILL_TEXT = "#1F3A29"


@dataclass(frozen=True)
class ShotSpec:
    file_name: str
    output_name: str
    title: str
    subtitle: str
    pill: str
    presentation: str = "phone"
    top_crop: float = 0.0
    bottom_crop: float = 0.0


SHOT_SPECS: tuple[ShotSpec, ...] = (
    ShotSpec(
        file_name="Screenshot_2026-03-29-16-25-18-558_com.aloe.wellness.aloe_wellness_coach-edit.jpg",
        output_name="phone_01_dashboard_focus_1242x2208.png",
        title="Щоденний\nwellness-ритм",
        subtitle="Тримайте воду, сон і м’який денний темп у одному premium dashboard.",
        pill="Сьогодні • Гідратація • Ритм",
        presentation="card",
    ),
    ShotSpec(
        file_name="Screenshot_2026-03-29-16-07-06-461_com.aloe.wellness.aloe_wellness_coach-edit.jpg",
        output_name="phone_02_plan_structure_1242x2208.png",
        title="Плани на\n7 / 14 / 21 днів",
        subtitle="М’яка структура дня з прогресом, checklist і wellness-safe підказками.",
        pill="Плани • Послідовність • Self-care",
        presentation="card",
    ),
    ShotSpec(
        file_name="Screenshot_2026-03-29-15-53-29-111_com.aloe.wellness.aloe_wellness_coach.jpg",
        output_name="phone_03_catalog_1242x2208.png",
        title="Каталог і\nproduct guidance",
        subtitle="Переглядайте Aloe Hub напрямки та отримуйте general wellness support без медичних claim-ів.",
        pill="Каталог • Українська • Aloe Hub",
        presentation="phone",
        top_crop=0.02,
        bottom_crop=0.02,
    ),
    ShotSpec(
        file_name="Screenshot_2026-03-29-15-53-29-111_com.aloe.wellness.aloe_wellness_coach.jpg",
        output_name="phone_04_shop_links_1242x2208.png",
        title="Shop links\nбез складного checkout",
        subtitle="Відкривайте Aloe Hub прямо в застосунку або безпечно переходьте у зовнішній браузер.",
        pill="Aloe Hub • In-app • Browser",
        presentation="phone",
        top_crop=0.28,
        bottom_crop=0.18,
    ),
)


def load_font(path: Path, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(path), size=size)


def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, size[0], size[1]), radius=radius, fill=255)
    return mask


def vertical_gradient(size: tuple[int, int], top_hex: str, bottom_hex: str) -> Image.Image:
    top = tuple(int(top_hex[i : i + 2], 16) for i in (1, 3, 5))
    bottom = tuple(int(bottom_hex[i : i + 2], 16) for i in (1, 3, 5))
    image = Image.new("RGB", size)
    draw = ImageDraw.Draw(image)
    height = max(size[1] - 1, 1)
    for y in range(size[1]):
        blend = y / height
        color = tuple(int(top[i] + (bottom[i] - top[i]) * blend) for i in range(3))
        draw.line((0, y, size[0], y), fill=color)
    return image


def add_soft_glows(image: Image.Image, centers: Iterable[tuple[int, int, int, str]]) -> None:
    overlay = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    for x, y, radius, color in centers:
        rgb = tuple(int(color[i : i + 2], 16) for i in (1, 3, 5))
        draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=(*rgb, 90))
    overlay = overlay.filter(ImageFilter.GaussianBlur(64))
    image.alpha_composite(overlay)


def draw_multiline(draw: ImageDraw.ImageDraw, text: str, font: ImageFont.FreeTypeFont, fill: str, box_width: int, xy: tuple[int, int], spacing: int = 6) -> int:
    lines: list[str] = []
    for paragraph in text.split("\n"):
        current = ""
        for word in paragraph.split():
            attempt = word if not current else f"{current} {word}"
            bbox = draw.multiline_textbbox((0, 0), attempt, font=font, spacing=spacing)
            if bbox[2] <= box_width:
                current = attempt
            else:
                if current:
                    lines.append(current)
                current = word
        if current:
            lines.append(current)
    text_value = "\n".join(lines)
    draw.multiline_text(xy, text_value, font=font, fill=fill, spacing=spacing)
    bbox = draw.multiline_textbbox(xy, text_value, font=font, spacing=spacing)
    return bbox[3]


def crop_source(image: Image.Image, top_crop: float, bottom_crop: float) -> Image.Image:
    top = int(image.height * top_crop)
    bottom = image.height - int(image.height * bottom_crop)
    return image.crop((0, top, image.width, bottom))


def make_phone_mock(image: Image.Image, size: tuple[int, int]) -> Image.Image:
    phone_w, phone_h = size
    outer = Image.new("RGBA", (phone_w, phone_h), (0, 0, 0, 0))
    shadow = Image.new("RGBA", (phone_w + 40, phone_h + 40), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle((20, 20, phone_w + 20, phone_h + 20), radius=86, fill=(0, 0, 0, 180))
    shadow = shadow.filter(ImageFilter.GaussianBlur(24))
    outer.alpha_composite(shadow.crop((20, 20, phone_w + 20, phone_h + 20)), dest=(0, 18))

    body = Image.new("RGBA", (phone_w, phone_h), (0, 0, 0, 0))
    body_draw = ImageDraw.Draw(body)
    body_draw.rounded_rectangle((0, 0, phone_w, phone_h), radius=84, fill="#0B120F")
    body_draw.rounded_rectangle((18, 18, phone_w - 18, phone_h - 18), radius=68, fill="#101714")
    body_draw.rounded_rectangle((phone_w // 2 - 110, 20, phone_w // 2 + 110, 54), radius=17, fill="#08100D")

    screen_area = (34, 58, phone_w - 34, phone_h - 34)
    screen_size = (screen_area[2] - screen_area[0], screen_area[3] - screen_area[1])
    fitted = ImageOps.fit(image, screen_size, method=Image.Resampling.LANCZOS)
    mask = rounded_mask(screen_size, radius=50)
    body.paste(fitted, screen_area[:2], mask)

    outer.alpha_composite(body)
    return outer


def make_content_card(image: Image.Image, size: tuple[int, int]) -> Image.Image:
    card_w, card_h = size
    outer = Image.new("RGBA", (card_w, card_h), (0, 0, 0, 0))
    shadow = Image.new("RGBA", (card_w + 40, card_h + 40), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle((20, 20, card_w + 20, card_h + 20), radius=58, fill=(0, 0, 0, 180))
    shadow = shadow.filter(ImageFilter.GaussianBlur(26))
    outer.alpha_composite(shadow.crop((20, 20, card_w + 20, card_h + 20)), dest=(0, 16))

    body = Image.new("RGBA", (card_w, card_h), (0, 0, 0, 0))
    body_draw = ImageDraw.Draw(body)
    body_draw.rounded_rectangle((0, 0, card_w, card_h), radius=54, fill="#13251C", outline=(255, 255, 255, 28), width=2)
    screen_area = (22, 22, card_w - 22, card_h - 22)
    screen_size = (screen_area[2] - screen_area[0], screen_area[3] - screen_area[1])
    fitted = ImageOps.fit(image, screen_size, method=Image.Resampling.LANCZOS)
    mask = rounded_mask(screen_size, radius=42)
    body.paste(fitted, screen_area[:2], mask)
    outer.alpha_composite(body)
    return outer


def create_phone_canvas(spec: ShotSpec, icon: Image.Image) -> None:
    source = Image.open(SOURCE_DIR / spec.file_name).convert("RGB")
    source = crop_source(source, spec.top_crop, spec.bottom_crop)

    canvas = vertical_gradient(PHONE_CANVAS, BG_TOP, BG_BOTTOM).convert("RGBA")
    add_soft_glows(
        canvas,
        (
            (180, 220, 180, "#2F8F60"),
            (1020, 420, 220, "#365F48"),
            (920, 1820, 260, "#173A2B"),
        ),
    )

    draw = ImageDraw.Draw(canvas)
    icon_size = 84
    icon_render = ImageOps.contain(icon.copy(), (icon_size, icon_size))
    icon_wrap = Image.new("RGBA", (120, 120), (0, 0, 0, 0))
    ImageDraw.Draw(icon_wrap).rounded_rectangle((0, 0, 120, 120), radius=34, fill=(227, 240, 222, 34), outline=(255, 255, 255, 28), width=2)
    icon_wrap.alpha_composite(icon_render, dest=((120 - icon_render.width) // 2, (120 - icon_render.height) // 2))
    canvas.alpha_composite(icon_wrap, dest=(92, 86))

    font_brand = load_font(FONT_SEMIBOLD, 32)
    font_title = load_font(FONT_BOLD, 96)
    font_subtitle = load_font(FONT_REGULAR, 42)
    font_pill = load_font(FONT_BOLD, 28)

    draw.text((228, 108), "Aloe Wellness Coach", font=font_brand, fill=TEXT)
    pill_bbox = (92, 230, 650, 300)
    draw.rounded_rectangle(pill_bbox, radius=32, fill=PILL)
    draw.text((122, 248), spec.pill, font=font_pill, fill=PILL_TEXT)

    text_bottom = draw_multiline(draw, spec.title, font_title, TEXT, 540, (92, 344), spacing=10)
    draw_multiline(draw, spec.subtitle, font_subtitle, TEXT_MUTED, 540, (92, text_bottom + 34), spacing=12)

    if spec.presentation == "card":
        card = make_content_card(source, (820, 760))
        canvas.alpha_composite(card, dest=(362, 1008))
    else:
        phone = make_phone_mock(source, (640, 1420))
        canvas.alpha_composite(phone, dest=(540, 620))

    footer_font = load_font(FONT_SEMIBOLD, 26)
    footer_box = (92, 2056, 534, 2126)
    draw.rounded_rectangle(footer_box, radius=28, fill=(255, 255, 255, 18))
    draw.text((122, 2075), "Українська • Wellness support only", font=footer_font, fill=TEXT)

    canvas.save(OUTPUT_DIR / spec.output_name)


def create_feature_graphic(icon: Image.Image) -> None:
    canvas = vertical_gradient(FEATURE_CANVAS, BG_TOP, BG_BOTTOM).convert("RGBA")
    add_soft_glows(
        canvas,
        (
            (100, 120, 120, "#2F8F60"),
            (910, 120, 140, "#365F48"),
            (760, 420, 180, "#214432"),
        ),
    )
    draw = ImageDraw.Draw(canvas)

    title_font = load_font(FONT_BOLD, 58)
    sub_font = load_font(FONT_REGULAR, 26)
    brand_font = load_font(FONT_SEMIBOLD, 20)
    pill_font = load_font(FONT_BOLD, 20)

    icon_render = ImageOps.contain(icon.copy(), (72, 72))
    icon_wrap = Image.new("RGBA", (94, 94), (0, 0, 0, 0))
    ImageDraw.Draw(icon_wrap).rounded_rectangle((0, 0, 94, 94), radius=28, fill=(227, 240, 222, 34), outline=(255, 255, 255, 25), width=2)
    icon_wrap.alpha_composite(icon_render, dest=((94 - icon_render.width) // 2, (94 - icon_render.height) // 2))
    canvas.alpha_composite(icon_wrap, dest=(56, 44))

    draw.text((166, 54), "Aloe Wellness Coach", font=brand_font, fill=ACCENT)
    draw.multiline_text((56, 132), "Wellness-ритм\nі Aloe Hub", font=title_font, fill=TEXT, spacing=4)
    draw.multiline_text((56, 278), "Гідратація, трекери, плани 7 / 14 / 21 днів\nі product guidance без медичних claim-ів.", font=sub_font, fill=TEXT_MUTED, spacing=6)

    pill_x = 56
    for label in ("Українська", "Wellness support", "Google Play ready"):
        bbox = draw.textbbox((0, 0), label, font=pill_font)
        width = bbox[2] - bbox[0] + 34
        draw.rounded_rectangle((pill_x, 392, pill_x + width, 432), radius=20, fill=PILL)
        draw.text((pill_x + 17, 402), label, font=pill_font, fill=PILL_TEXT)
        pill_x += width + 12

    previews = [
        ("Screenshot_2026-03-29-16-25-18-558_com.aloe.wellness.aloe_wellness_coach-edit.jpg", (718, 72), (150, 280), -8),
        ("Screenshot_2026-03-29-15-53-29-111_com.aloe.wellness.aloe_wellness_coach.jpg", (836, 104), (160, 300), 7),
        ("Screenshot_2026-03-29-16-07-06-461_com.aloe.wellness.aloe_wellness_coach-edit.jpg", (914, 158), (134, 248), 12),
    ]
    for file_name, position, size, angle in previews:
        source = Image.open(SOURCE_DIR / file_name).convert("RGB")
        frame = make_phone_mock(source, size)
        frame = frame.rotate(angle, resample=Image.Resampling.BICUBIC, expand=True)
        canvas.alpha_composite(frame, dest=position)

    canvas.save(OUTPUT_DIR / "feature_graphic_1024x500.png")


def write_manifest() -> None:
    manifest = OUTPUT_DIR / "manifest.md"
    manifest.write_text(
        "\n".join(
            [
                "# Google Play Assets",
                "",
                "- Feature graphic: `feature_graphic_1024x500.png` (1024x500)",
                "- Phone screenshot: `phone_01_dashboard_focus_1242x2208.png` (1242x2208)",
                "- Phone screenshot: `phone_02_plan_structure_1242x2208.png` (1242x2208)",
                "- Phone screenshot: `phone_03_catalog_1242x2208.png` (1242x2208)",
                "- Phone screenshot: `phone_04_shop_links_1242x2208.png` (1242x2208)",
                "",
                "These files were generated from real Aloe Wellness Coach phone screenshots and composed into Google Play friendly marketing canvases.",
            ],
        ),
        encoding="utf-8",
    )


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    icon = Image.open(ICON_PATH).convert("RGBA")
    create_feature_graphic(icon)
    for spec in SHOT_SPECS:
        create_phone_canvas(spec, icon)
    write_manifest()


if __name__ == "__main__":
    main()

