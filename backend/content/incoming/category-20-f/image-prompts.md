# หมวด ฝ — prompt สร้างภาพ (4 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-20-f/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (1 รายการ) ห้ามมีเลขในภาพ
- ฝังทั้งเป็น / ฝังศพ / ฝี เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่น่ากลัว ไม่มีศพหรือแผลให้เห็น
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ฝน | `f-rain.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | ฝัง | `f-buried-alive.jpg` | 50, 60, 250, 260 |
| 3 | ฝังศพ | `f-burial.jpg` | 04, 14, 104, 144 |
| 4 | ฝี | `f-boil.jpg` | 36, 37, 136, 237 |

### 1. ฝน — `f-rain`

- ไฟล์ที่ต้องได้: `images/f-rain.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นฝนตก ทายว่าจะได้รับอันตรายเดือดร้อน เสียเงินทอง เศร้าโศกเสียใจเพราะญาติมิตรนำมาสู่ แต่ถ้าฝันว่าฝนตกต้องถูกร่างกายเปะแปะ ไม่ถึงกับเปียกโชกนัก จะได้ลาภจากทางไกล หรือผู้ใหญ่จะให้ลาภ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: heavy rain falling over a Thai village, a sad person under an umbrella; on the other side a few light raindrops on a smiling person receiving a gift from an elder. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. ฝัง — `f-buried-alive`

- ไฟล์ที่ต้องได้: `images/f-buried-alive.jpg`
- เลข: 50, 60, 250, 260
- คำทำนาย (ต้นฉบับ): ฝันว่าถูกฝังทั้งเป็น ทายว่าจะได้เลื่อนฐานะสูงขึ้น จะประสบโชคลาภอย่างใหญ่หลวง หรือได้เลื่อนฐานะยศฐาบรรดาศักดิ์ในหน้าที่การงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, not scary: a smiling person standing waist-deep in a mound of soil, an official handing them a rank sash. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 50; top-right: 60; bottom-left: 250; bottom-right: 260. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 3. ฝังศพ — `f-burial`

- ไฟล์ที่ต้องได้: `images/f-burial.jpg`
- เลข: 04, 14, 104, 144
- คำทำนาย (ต้นฉบับ): ถ้าฝันว่าเห็นเขาฝังศพ หรือได้ไปในงานฝังศพ ท่านจะได้ลาภหรือข่าวจากทางไกล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no body shown: a calm burial ceremony at a cemetery with people paying respects, a messenger arriving with a letter from far away. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 04; top-right: 14; bottom-left: 104; bottom-right: 144. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 4. ฝี — `f-boil`

- ไฟล์ที่ต้องได้: `images/f-boil.jpg`
- เลข: 36, 37, 136, 237
- คำทำนาย (ต้นฉบับ): ฝันว่าเป็นฝีที่ร่างกายส่วนใดส่วนหนึ่ง ทายว่าจะได้ลาภจรกับการเสี่ยงโชค

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no wound shown: a person with a small bandage on their arm happily holding a lottery ticket. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 36; top-right: 37; bottom-left: 136; bottom-right: 237. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```
