# หมวด ญ — prompt สร้างภาพ (8 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-10-y/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (6 รายการ) ห้ามมีเลขในภาพ
- หญิงแก้ผ้า เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีภาพโป๊
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ญาติมิตร | `y-relatives.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | หญิงชุดดำ | `y-woman-in-black.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | หญิงแปลกหน้า | `y-stranger-woman.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 4 | หญิงแก้ผ้า | `y-unclothed-woman.jpg` | 56, 58, 156, 258 |
| 5 | หญิงแก่ | `y-old-woman.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 6 | หญิงนุ่งขาว | `y-woman-in-white.jpg` | 51, 52, 151, 252 |
| 7 | หญิงนุ่งแดง | `y-woman-in-red.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 8 | หญิงสาว | `y-young-woman.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ญาติมิตร — `y-relatives`

- ไฟล์ที่ต้องได้: `images/y-relatives.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้อยู่พร้อมหน้าญาติหรือมิตรสนิท ทายว่าท่านจะประสบกับความเจ็บป่วยหรือเสียของรัก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a family gathering of relatives and close friends sitting together on a veranda, one person looking pale and unwell. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. หญิงชุดดำ — `y-woman-in-black`

- ไฟล์ที่ต้องได้: `images/y-woman-in-black.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นผู้หญิงแต่งตัวไว้ทุกข์สีดำมาหา ความฝันนี้ท่านจะประสบกับปัญหายุ่งยากหลายประการ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a woman dressed in black mourning clothes arriving at the door, a worried person inside. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. หญิงแปลกหน้า — `y-stranger-woman`

- ไฟล์ที่ต้องได้: `images/y-stranger-woman.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นผู้หญิงแปลกหน้ามาหา ความฝันนี้ทำนายว่า ถ้าท่านติดต่อการงานเกี่ยวกับทางด้านค้าขาย หรือการเงิน ให้มีผู้หญิงร่วมมือด้วยจึงจะสำเร็จ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an unfamiliar woman visiting a shop, shaking hands with the merchant over a ledger and coins. Do not draw any numbers, words or letters anywhere in the picture.
```

### 4. หญิงแก้ผ้า — `y-unclothed-woman`

- ไฟล์ที่ต้องได้: `images/y-unclothed-woman.jpg`
- เลข: 56, 58, 156, 258
- คำทำนาย (ต้นฉบับ): ฝันเห็นผู้หญิงแก้ผ้า ความฝันนี้ท่านจะประสบกับโชคลาภทางการพนันหรือลาภลอย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no nudity: a folded dress and a shawl lying on a bench behind a screen, playing cards and a pouch of coins on a table nearby. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 56; top-right: 58; bottom-left: 156; bottom-right: 258. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 5. หญิงแก่ — `y-old-woman`

- ไฟล์ที่ต้องได้: `images/y-old-woman.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นผู้หญิงแก่เก็บดอกไม้มาฝาก ความฝันนี้ทายว่าจะมีญาติผู้ใหญ่ส่งสิ่งของมากำนัลท่าน แต่ถ้าเป็นดอกไม้สีแดงท่านจะได้รับเรื่องราวทางไม่ดีจากผู้ใหญ่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an elderly woman bringing a bunch of flowers as a gift to a younger person at the door. Do not draw any numbers, words or letters anywhere in the picture.
```

### 6. หญิงนุ่งขาว — `y-woman-in-white`

- ไฟล์ที่ต้องได้: `images/y-woman-in-white.jpg`
- เลข: 51, 52, 151, 252
- คำทำนาย (ต้นฉบับ): ฝันเห็นผู้หญิงนุ่งขาวห่มขาว หรือเป็นแม่ชีมาหา ความฝันนี้ทำนายว่า ท่านจะได้พบกับความร่มเย็นเป็นสุขในครอบครัว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a woman dressed all in white like a Buddhist nun visiting a calm, happy family at home. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 51; top-right: 52; bottom-left: 151; bottom-right: 252. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 7. หญิงนุ่งแดง — `y-woman-in-red`

- ไฟล์ที่ต้องได้: `images/y-woman-in-red.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นผู้หญิงนุ่งแดงทั้งชุด ความฝันนี้ทายว่าท่านจะเดือดร้อนเกี่ยวกับการเงิน หรือมีความยุ่งยากใจในเรื่องหนี้สินต่าง ๆ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a woman dressed all in red standing in a room, a worried person holding unpaid bills. Do not draw any numbers, words or letters anywhere in the picture.
```

### 8. หญิงสาว — `y-young-woman`

- ไฟล์ที่ต้องได้: `images/y-young-woman.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้กอดผู้หญิงสาว ความฝันนี้ทายว่า ท่านจะประสบผลสำเร็จในด้านความรัก จะมีผู้ใหญ่อุปการะให้ความร่วมมือ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a young couple embracing warmly, an elder smiling and giving a blessing behind them. Do not draw any numbers, words or letters anywhere in the picture.
```
