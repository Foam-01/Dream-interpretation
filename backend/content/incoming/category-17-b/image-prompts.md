# หมวด บ — prompt สร้างภาพ (13 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-17-b/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (6 รายการ) ห้ามมีเลขในภาพ
- บ่อ / บันไดตก / บินตก เขียนให้ไม่มีภาพบาดเจ็บ
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | บวช | `b-ordination.jpg` | 08, 18, 108, 118 |
| 2 | บ่อ | `b-well.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | บันไดขึ้น | `b-climbing-stairs.jpg` | 05, 07, 305, 507 |
| 4 | บันไดตก | `b-falling-stairs.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 5 | บัว | `b-lotus.jpg` | 49, 59, 347, 359 |
| 6 | บ้า | `b-madness.jpg` | 11, 12, 112, 110 |
| 7 | บ้านพัง | `b-ruined-house.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 8 | บ้านร้าง | `b-abandoned-house.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 9 | บินเดินทาง | `b-flying.jpg` | 27, 29, 279, 396 |
| 10 | บินตก | `b-plane-crash.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 11 | บึง | `b-swamp.jpg` | 07, 08, 307, 308 |
| 12 | บุญ | `b-merit.jpg` | 38, 39, 238, 239 |
| 13 | แบกหาม | `b-carrying-load.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. บวช — `b-ordination`

- ไฟล์ที่ต้องได้: `images/b-ordination.jpg`
- เลข: 08, 18, 108, 118
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวเราบวชพระหรือบวชชี ความฝันนี้ทำให้เราหมดเคราะห์หมดโศก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person being ordained as a monk with shaved head and saffron robes, family smiling. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 08; top-right: 18; bottom-left: 108; bottom-right: 118. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 2. บ่อ — `b-well`

- ไฟล์ที่ต้องได้: `images/b-well.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวของเราตกไปในบ่อลึก ความฝันนี้ท่านจะบังเกิดความเสียหาย ล้มเหลว และความหายนะ ควรจะรอบคอบ ระวังทางการงานและเรื่องส่วนตัวให้จงหนัก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person falling into a deep well (no injury shown), papers and coins scattered at the edge. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. บันไดขึ้น — `b-climbing-stairs`

- ไฟล์ที่ต้องได้: `images/b-climbing-stairs.jpg`
- เลข: 05, 07, 305, 507
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ขึ้นบันไดบ้านของเราเอง ความฝันนี้ ท่านจะบังเกิดความสำเร็จทางการงาน กิจการงานจะรุ่งเรือง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person climbing the stairs up to their own house, a thriving shop sign beside it. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 05; top-right: 07; bottom-left: 305; bottom-right: 507. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 4. บันไดตก — `b-falling-stairs`

- ไฟล์ที่ต้องได้: `images/b-falling-stairs.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตกบันไดบ้านของเรา ความฝันนี้จะมีผู้จากไปไกล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person slipping on the stairs of their house (no injury), someone leaving with luggage in the distance. Do not draw any numbers, words or letters anywhere in the picture.
```

### 5. บัว — `b-lotus`

- ไฟล์ที่ต้องได้: `images/b-lotus.jpg`
- เลข: 49, 59, 347, 359
- คำทำนาย (ต้นฉบับ): ฝันว่าเก็บดอกบัว ความฝันนี้ ท่านจะได้สมรสกับคู่ที่มีรูปร่าง มีศักดิ์ ตระกูลดี เงินทองมั่งคั่ง เป็นที่พึ่งต่อไปข้างหน้าได้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person picking lotus flowers from a pond, a well-dressed suitor from a noble family on the bank. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 49; top-right: 59; bottom-left: 347; bottom-right: 359. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. บ้า — `b-madness`

- ไฟล์ที่ต้องได้: `images/b-madness.jpg`
- เลข: 11, 12, 112, 110
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวของเราเกิดการบ้าคลั่ง ความฝันนี้เป็นผลดีแก่ท่าน ทางด้านการงานจะราบรื่นเป็นปึกแผ่นดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person acting wildly and dancing in a field, a neat orderly office behind them. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 11; top-right: 12; bottom-left: 112; bottom-right: 110. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 7. บ้านพัง — `b-ruined-house`

- ไฟล์ที่ต้องได้: `images/b-ruined-house.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นบ้านที่อยู่เกิดชำรุดปรักหักพัง ความฝันนี้ท่านจะต้องเกิดการเสียใจเกี่ยวกับของรัก ความยุ่งยากภายในครอบครัว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a broken, collapsing old house with a sad family outside. Do not draw any numbers, words or letters anywhere in the picture.
```

### 8. บ้านร้าง — `b-abandoned-house`

- ไฟล์ที่ต้องได้: `images/b-abandoned-house.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเดินไปพบบ้านร้างโดดเดี่ยว ความฝันนี้ท่านจะต้องมีการเดินทางออกจากบ้านไปชั่วคราว ไม่เช่นนั้นก็จะมีคนที่อาศัยจากไป

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person finding a lonely abandoned house in a field, a packed travel bag beside them. Do not draw any numbers, words or letters anywhere in the picture.
```

### 9. บินเดินทาง — `b-flying`

- ไฟล์ที่ต้องได้: `images/b-flying.jpg`
- เลข: 27, 29, 279, 396
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ขึ้นเครื่องบิน เดินทางด้วยเครื่องบิน ความฝันนี้ท่านจะพบกับผู้อุปถัมภ์ กิจการงานเป็นผลดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person boarding a passenger plane, a supportive patron waving. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 27; top-right: 29; bottom-left: 279; bottom-right: 396. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 10. บินตก — `b-plane-crash`

- ไฟล์ที่ต้องได้: `images/b-plane-crash.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตกเครื่องบิน ความฝันนี้ ท่านจะยุ่งยากใจทางด้านการงาน อย่าเดินทางไกลอาจจะได้รับอันตรายต่าง ๆ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no wreck or injury: a small plane tilting down through clouds, a worried person at an airport window. Do not draw any numbers, words or letters anywhere in the picture.
```

### 11. บึง — `b-swamp`

- ไฟล์ที่ต้องได้: `images/b-swamp.jpg`
- เลข: 07, 08, 307, 308
- คำทำนาย (ต้นฉบับ): ฝันว่าไปจับปลาตามบึงบ่อ ความฝันนี้ท่านจะพบกับเนื้อคู่หรือได้รับลาภลอย ของที่พึงใจของท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person catching fish in a swamp with a basket, a smiling partner and a bag of coins. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 07; top-right: 08; bottom-left: 307; bottom-right: 308. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 12. บุญ — `b-merit`

- ไฟล์ที่ต้องได้: `images/b-merit.jpg`
- เลข: 38, 39, 238, 239
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ทำบุญเลี้ยงพระ ความฝันนี้ท่านจะมีสุขสบายตลอดทั้งครอบครัว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person offering food to monks at home, the whole family kneeling happily. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 38; top-right: 39; bottom-left: 238; bottom-right: 239. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 13. แบกหาม — `b-carrying-load`

- ไฟล์ที่ต้องได้: `images/b-carrying-load.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ออกแรงแบกหามสิ่งของหนัก ๆ ความฝันนี้ ท่านจะได้รับการสนับสนุน จะพบกับความสำเร็จสมความตั้งใจ โรคภัยไข้เจ็บบางเบาทุเลาหายไปจากตัว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person carrying a heavy load on a shoulder pole, friends helping push from behind. Do not draw any numbers, words or letters anywhere in the picture.
```
