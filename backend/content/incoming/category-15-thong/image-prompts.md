# หมวด ธ — prompt สร้างภาพ (3 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-15-thong/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (2 รายการ) ห้ามมีเลขในภาพ
- ธนู เขียนให้ไม่มีคนถูกยิงหรือบาดเจ็บ
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ธง | `thong-flag.jpg` | 41, 42, 141, 142 |
| 2 | ธนบัตร | `thong-banknotes.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ธนู | `thong-bow.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ธง — `thong-flag`

- ไฟล์ที่ต้องได้: `images/thong-flag.jpg`
- เลข: 41, 42, 141, 142
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าได้ถือธงต่าง ๆ ความฝันนี้ท่านจะประสบกับเกียรติยศชื่อเสียง จะได้เลื่อนตำแหน่งดี ๆ ถ้าเป็นเด็กนักเรียนก็จะสอบไล่ได้ การแข่งขันต่าง ๆ ก็จะหมายถึงการชนะด้วย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a student proudly holding a waving flag at a school sports day, a trophy on a table. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 41; top-right: 42; bottom-left: 141; bottom-right: 142. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 2. ธนบัตร — `thong-banknotes`

- ไฟล์ที่ต้องได้: `images/thong-banknotes.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้เห็นหรือมีธนบัตรจำนวนมาก ความฝันนี้ท่านจะต้องยุ่งยากใจเกี่ยวกับการเงินเป็นส่วนมาก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a worried person sitting in front of large piles of banknotes, scratching their head over accounts. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ธนู — `thong-bow`

- ไฟล์ที่ต้องได้: `images/thong-bow.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่ายิงธนูเล่น ความฝันนี้ท่านจะเกิดความสำเร็จผลในด้านการงาน แต่ถ้าท่านฝันว่าถูกเขายิง จงระวังการหักหลังกัน ระวังอุบัติเหตุ และศัตรูคิดปองร้าย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person shooting an arrow at a straw target in a field, the arrow hitting the centre. Do not draw any numbers, words or letters anywhere in the picture.
```
