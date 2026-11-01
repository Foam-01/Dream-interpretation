# หมวด ถ — prompt สร้างภาพ (3 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-13-thung/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (2 รายการ) ห้ามมีเลขในภาพ
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ถ้วยชาม | `thung-dishes.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | ถาด | `thung-tray.jpg` | 09, 19, 509, 519 |
| 3 | ถ้ำ | `thung-cave.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ถ้วยชาม — `thung-dishes`

- ไฟล์ที่ต้องได้: `images/thung-dishes.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ล้างถ้วยโถโอชามจนสะอาด ทายว่าท่านจะได้รับข่าวดีในทางธุรกิจ หรืองานในหน้าที่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person washing bowls and dishes until they shine at a water jar, a messenger bringing good business news. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. ถาด — `thung-tray`

- ไฟล์ที่ต้องได้: `images/thung-tray.jpg`
- เลข: 09, 19, 509, 519
- คำทำนาย (ต้นฉบับ): ฝันว่าได้เอาถาดต่าง ๆ ไปหล่อพระทำบุญ ความฝันนี้ท่านจะถูกลอตเตอรี่ หรือได้รับการแต่งตั้งให้เป็นใหญ่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: people donating brass trays at a temple to be melted for casting a Buddha image, a lottery ticket in a hand. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 09; top-right: 19; bottom-left: 509; bottom-right: 519. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 3. ถ้ำ — `thung-cave`

- ไฟล์ที่ต้องได้: `images/thung-cave.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเดินไปในถ้ำใหญ่มืดมิด ความฝันนี้ คนสนิทชิดเชื้อคนรักชอบพอกันจะมีปากเสียงกับท่าน หรือครอบครัวของท่านจะเกิดการทะเลาะวิวาทถึงทุบตีกัน หรือคนใกล้ชิดนำเรื่องเดือดร้อนมาสู่ท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking into a large dark cave holding a lamp, two family members quarrelling at the entrance. Do not draw any numbers, words or letters anywhere in the picture.
```
