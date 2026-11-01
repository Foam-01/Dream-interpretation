# หมวด ศ — prompt สร้างภาพ (3 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-29-sala/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (0 รายการ) ห้ามมีเลขในภาพ
- ศพ เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีศพให้เห็น (เช่น โลงศพประดับดอกไม้)
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ศพ | `sala-corpse.jpg` | 44, 47, 474, 744 |
| 2 | ศาลา | `sala-pavilion.jpg` | 46, 49, 346, 349 |
| 3 | ศิลา | `sala-stone.jpg` | 48, 49, 148, 149 |

### 1. ศพ — `sala-corpse`

- ไฟล์ที่ต้องได้: `images/sala-corpse.jpg`
- เลข: 44, 47, 474, 744
- คำทำนาย (ต้นฉบับ): ฝันเห็นศพ จับศพ เผาศพ จะมีโชคลาภหรือมีผู้นำของกำนัลมาให้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no body shown: a decorated coffin with flowers at a temple, a person receiving a gift box. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 44; top-right: 47; bottom-left: 474; bottom-right: 744. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 2. ศาลา — `sala-pavilion`

- ไฟล์ที่ต้องได้: `images/sala-pavilion.jpg`
- เลข: 46, 49, 346, 349
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นหรือได้ไปนั่งเล่นบนศาลา ทายว่าท่านจะมีความสุขมีผู้ให้ความเมตตา หรือได้พบกับผู้อุปการะช่วยเหลือ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person relaxing in a traditional Thai roadside sala pavilion, a kind elder offering help. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 46; top-right: 49; bottom-left: 346; bottom-right: 349. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 3. ศิลา — `sala-stone`

- ไฟล์ที่ต้องได้: `images/sala-stone.jpg`
- เลข: 48, 49, 148, 149
- คำทำนาย (ต้นฉบับ): ฝันว่าได้จับต้องแท่งศิลา หรือได้นั่งบนศิลาก้อนใหญ่ ทายว่า สิ่งที่คิดไว้จะเป็นผลสำเร็จทุกประการ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person sitting on a big smooth boulder, holding a stone slab, looking satisfied. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 48; top-right: 49; bottom-left: 148; bottom-right: 149. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```
