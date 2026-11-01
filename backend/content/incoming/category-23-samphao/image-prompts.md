# หมวด ภ — prompt สร้างภาพ (2 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-23-samphao/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (1 รายการ) ห้ามมีเลขในภาพ
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ภรรยา | `samphao-wife.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | ภูเขา | `samphao-mountain.jpg` | 39, 49, 639, 649 |

### 1. ภรรยา — `samphao-wife`

- ไฟล์ที่ต้องได้: `images/samphao-wife.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าภรรยาของเราหนีไป ความฝันนี้ภรรยาของท่านกำลังจะคิดนอกใจท่าน หรือมิฉะนั้นท่านก็จะต้องเสียของรักอย่างอื่นไป

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a wife walking away from home with a bundle, the husband watching sadly from the doorway. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. ภูเขา — `samphao-mountain`

- ไฟล์ที่ต้องได้: `images/samphao-mountain.jpg`
- เลข: 39, 49, 639, 649
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ไปเที่ยวเล่นบนภูเขาใหญ่ ความฝันนี้ท่านจะได้รับยศศักดิ์จากการแต่งตั้งของเจ้าหน้าที่ มิฉะนั้นก็จะได้ลาภลอย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person happily hiking on a big mountain top, an official handing them a rank sash. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 39; top-right: 49; bottom-left: 639; bottom-right: 649. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```
