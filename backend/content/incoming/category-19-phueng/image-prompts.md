# หมวด ผ — prompt สร้างภาพ (10 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-19-phueng/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (2 รายการ) ห้ามมีเลขในภาพ
- ฟ้าผ่าตน / เผาศพ เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีคนบาดเจ็บหรือศพให้เห็น; ผีให้ดูเป็นมิตร ไม่น่ากลัว
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ผด | `phueng-heat-rash.jpg` | 11, 12, 811, 812 |
| 2 | ผม | `phueng-hair.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ผลไม้ | `phueng-fruit.jpg` | 10, 20, 310, 320 |
| 4 | ผา | `phueng-cliff.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 5 | ผ่า (ฟ้า) | `phueng-lightning.jpg` | 91, 92, 911, 922 |
| 6 | ผ่า (ฟ้าผ่าตน) | `phueng-struck-by-lightning.jpg` | 92, 94, 922, 944 |
| 7 | ผ้า | `phueng-fine-clothes.jpg` | 58, 59, 158, 259 |
| 8 | ผี | `phueng-ghost.jpg` | 76, 86, 706, 806 |
| 9 | ผึ้ง | `phueng-bees.jpg` | 03, 05, 705, 803 |
| 10 | เผาศพ | `phueng-cremation.jpg` | 04, 06, 301, 304 |

### 1. ผด — `phueng-heat-rash`

- ไฟล์ที่ต้องได้: `images/phueng-heat-rash.jpg`
- เลข: 11, 12, 811, 812
- คำทำนาย (ต้นฉบับ): ฝันว่ามีผดขึ้นตามตัวจะได้ของกำนัล หรือมีโชคลาภ ได้ทรัพย์สินเงินทอง สิ่งของอันมีค่า

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person scratching small prickly-heat spots on their arm, then receiving a wrapped gift box and a pile of coins. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 11; top-right: 12; bottom-left: 811; bottom-right: 812. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 2. ผม — `phueng-hair`

- ไฟล์ที่ต้องได้: `images/phueng-hair.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าผมร่วงจากศีรษะ จะเกิดทุกข์โศกเดือดร้อน เสียเงินทองสิ่งของอันมีค่า เกิดการทะเลาะวิวาท ถ้าฝันว่าตัดผมใหม่ จะมีเรื่องขัดใจกับผู้ใหญ่ ให้ระวังการทำงานผิดพลาดนอกหน้าที่ และปากของตนให้มาก อย่าพูดพล่อย ๆ ไปนัก ("พูดไปสองไพเบี้ย นิ่งเสียตำลึงทอง")

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: hair strands falling from a worried person's head onto the floor, a barber giving a fresh haircut while an elder frowns nearby. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ผลไม้ — `phueng-fruit`

- ไฟล์ที่ต้องได้: `images/phueng-fruit.jpg`
- เลข: 10, 20, 310, 320
- คำทำนาย (ต้นฉบับ): ฝันว่าได้กินผลไม้ หรือได้เห็นผลไม้ จะหมดเคราะห์หมดโศกโรคภัย จะมีความสุขกายสบายใจ คิดทำสิ่งใดจะสำเร็จผลสมความปรารถนา

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a happy, relaxed person eating mangoes, bananas and rambutans from a big fruit basket. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 10; top-right: 20; bottom-left: 310; bottom-right: 320. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 4. ผา — `phueng-cliff`

- ไฟล์ที่ต้องได้: `images/phueng-cliff.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นผาสูงหรือตกจากผาสูง ท่านจะประสบความล้มเหลวในกิจการงาน จะได้รับความเดือดร้อน เศร้าโศกเสียใจ จะถูกทำโทษใส่ร้าย ให้ระวังตนและการงานให้จงหนัก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a worried person standing at the edge of a tall rocky cliff looking down into a deep valley. Do not draw any numbers, words or letters anywhere in the picture.
```

### 5. ผ่า (ฟ้า) — `phueng-lightning`

- ไฟล์ที่ต้องได้: `images/phueng-lightning.jpg`
- เลข: 91, 92, 911, 922
- คำทำนาย (ต้นฉบับ): ฝันว่าฟ้าผ่าจะได้ลาภโดยบังเอิญ หรือถูกลอตเตอรี่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a lightning bolt striking a tall tree far away during a storm, a surprised person holding a lottery ticket and smiling. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 91; top-right: 92; bottom-left: 911; bottom-right: 922. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. ผ่า (ฟ้าผ่าตน) — `phueng-struck-by-lightning`

- ไฟล์ที่ต้องได้: `images/phueng-struck-by-lightning.jpg`
- เลข: 92, 94, 922, 944
- คำทำนาย (ต้นฉบับ): ถ้าฝันว่าฟ้าผ่าตน ให้บูชาด้วยผ้าแดง หรือน้ำเต้า แล้วจะทำให้มีสิริมงคล ได้โชคลาภใหญ่หลวงอย่างประหลาด

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no injury: a lightning flash coming down beside a calm person who offers a red cloth and a bottle gourd at a small shrine, soft rays of good fortune around them. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 92; top-right: 94; bottom-left: 922; bottom-right: 944. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 7. ผ้า — `phueng-fine-clothes`

- ไฟล์ที่ต้องได้: `images/phueng-fine-clothes.jpg`
- เลข: 58, 59, 158, 259
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ใส่เสื้อผ้าแพรพรรณ เครื่องแต่งกายอย่างสง่างาม ความฝันมีความหมายว่าท่านจะได้ดีมีความสุขสมบูรณ์ คิดทำสิ่งใดจะได้รับผลสมความปรารถนาทุกประการ แต่ถ้าฝันว่าได้นุ่งผ้าขาด ท่านจะเสียของรักและเดือดร้อน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person dressed elegantly in fine silk Thai clothes, and a torn old sarong hanging on a washing line beside them. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 58; top-right: 59; bottom-left: 158; bottom-right: 259. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 8. ผี — `phueng-ghost`

- ไฟล์ที่ต้องได้: `images/phueng-ghost.jpg`
- เลข: 76, 86, 706, 806
- คำทำนาย (ต้นฉบับ): ฝันว่าจับผีหรือเห็นผี ฝันนี้มีความหมายบอกให้ท่านรู้ว่า จะประสบโชคลาภอย่างใหญ่หลวง หรือได้เงินทองที่ตนได้มุ่งมาดปรารถนาไว้ สิ่งที่ตั้งใจทำอยู่จะประสบผลดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a friendly, not scary, Thai ghost in a white sheet being caught with a net by a person, gold coins spilling around. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 76; top-right: 86; bottom-left: 706; bottom-right: 806. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 9. ผึ้ง — `phueng-bees`

- ไฟล์ที่ต้องได้: `images/phueng-bees.jpg`
- เลข: 03, 05, 705, 803
- คำทำนาย (ต้นฉบับ): ฝันว่าผึ้งไล่ตอม-ต่อย ให้ระวังจะมีคนคอยปองร้าย ให้ระวังตัวจะเสียทีแก่คนพาล จะเดือดร้อนเสียเงินทองสิ่งของอันมีค่า หรือของที่รักจะเสียไป แต่ถ้าฝันว่าได้กินรวงผึ้ง น้ำผึ้ง ความฝันนี้บอกให้ท่านรู้ว่า จะหมดเคราะห์โศกโรคภัย และจะประสบความสุข สมดังความประสงค์

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: bees buzzing around a person covering their head on one side, and on the other side a person happily eating honeycomb with honey dripping. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 03; top-right: 05; bottom-left: 705; bottom-right: 803. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 10. เผาศพ — `phueng-cremation`

- ไฟล์ที่ต้องได้: `images/phueng-cremation.jpg`
- เลข: 04, 06, 301, 304
- คำทำนาย (ต้นฉบับ): ฝันว่าเผาศพ ได้ไปในงานเผาศพ หรือเห็นเขาเผาศพ จะประสบความสุขและได้โชคลาภมาก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no body shown: a Thai temple cremation ceremony with a decorated funeral pyre and gentle smoke, people in black and white paying respects calmly. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 04; top-right: 06; bottom-left: 301; bottom-right: 304. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```
