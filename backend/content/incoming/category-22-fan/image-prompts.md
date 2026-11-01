# หมวด ฟ — prompt สร้างภาพ (9 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-22-fan/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (5 รายการ) ห้ามมีเลขในภาพ
- ฟันคลอน / ฟันหัก / ฟ้าผ่าตัว / ไฟไหม้บ้าน เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีเลือดหรือคนบาดเจ็บ
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ฟันคลอน | `fan-loose-tooth.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | ฟันหัก | `fan-broken-tooth.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ฟ้าผ่าตัว | `fan-lightning-self.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 4 | ฟ้าผ่าต้นไม้ | `fan-lightning-tree.jpg` | 46, 49, 146, 149 |
| 5 | ไฟบนภูเขา | `fan-fire-mountain.jpg` | 40, 44, 140, 144 |
| 6 | ไฟในเตา | `fan-fire-stove.jpg` | 44, 47, 244, 447 |
| 7 | ไฟไหม้บ้าน | `fan-house-fire.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 8 | ไฟโคมและเทียน | `fan-lamp.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 9 | ไฟไหม้ป่า | `fan-forest-fire.jpg` | 44, 84, 244, 284 |

### 1. ฟันคลอน — `fan-loose-tooth`

- ไฟล์ที่ต้องได้: `images/fan-loose-tooth.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าฟันคลอน ความฝันนี้ ท่านจะเจ็บไข้เสียเงินทองเพราะญาติมิตรเป็นต้นเหตุ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no blood: a worried person touching their cheek, a relative handing them a medical bill. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. ฟันหัก — `fan-broken-tooth`

- ไฟล์ที่ต้องได้: `images/fan-broken-tooth.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าฝันว่าฟันในปากของเราเองหักข้างบน ความฝันนี้จะต้องมีญาติมิตรฝ่ายผู้ชายเจ็บหนัก หรือตายจากไป แต่ถ้าฝันว่าฟันหักข้างล่าง แสดงว่าญาติมิตรฝ่ายหญิงจะเกิดการเจ็บป่วย หรืออาจจะได้รับข่าวร้าย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no blood: a person looking into a mirror at a small chipped tooth, worried relatives in the background. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ฟ้าผ่าตัว — `fan-lightning-self`

- ไฟล์ที่ต้องได้: `images/fan-lightning-self.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าฟ้าผ่าถูกตัวของเรา หรือบ้านเรือน ความฝันนี้ท่านต้องระวังตัวจะถูกคนปองร้าย ใส่ร้ายในเรื่องไม่ดี แต่จะได้ลาภภายหลัง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no injury: lightning flashing near a house, a person sheltering while gossiping figures whisper behind a fence. Do not draw any numbers, words or letters anywhere in the picture.
```

### 4. ฟ้าผ่าต้นไม้ — `fan-lightning-tree`

- ไฟล์ที่ต้องได้: `images/fan-lightning-tree.jpg`
- เลข: 46, 49, 146, 149
- คำทำนาย (ต้นฉบับ): ฝันเห็นฟ้าผ่าต้นไม้ใหญ่ ความฝันนี้ให้ท่านจัดแจงแต่งเครื่องบูชา ท่านจะประสบโชคลาภภายหลัง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a lightning bolt striking a big old tree, a person preparing an offering tray with flowers and candles. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 46; top-right: 49; bottom-left: 146; bottom-right: 149. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 5. ไฟบนภูเขา — `fan-fire-mountain`

- ไฟล์ที่ต้องได้: `images/fan-fire-mountain.jpg`
- เลข: 40, 44, 140, 144
- คำทำนาย (ต้นฉบับ): ฝันเห็นไฟลุกลามบนภูเขาใหญ่ ความฝันนี้จะมีผู้นำลาภข่าวดีมาสู่บ้านท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a fire spreading across a big mountain at night seen from far away, a messenger running towards a house with good news. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 40; top-right: 44; bottom-left: 140; bottom-right: 144. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. ไฟในเตา — `fan-fire-stove`

- ไฟล์ที่ต้องได้: `images/fan-fire-stove.jpg`
- เลข: 44, 47, 244, 447
- คำทำนาย (ต้นฉบับ): ฝันเห็นไฟในเตาดูแดงดี ความฝันนี้ท่านจะได้รับมรดก หรือลาภลอยมาจากทางไกล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a bright red glowing fire in a clay charcoal stove, a letter and an inheritance chest arriving from afar. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 44; top-right: 47; bottom-left: 244; bottom-right: 447. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 7. ไฟไหม้บ้าน — `fan-house-fire`

- ไฟล์ที่ต้องได้: `images/fan-house-fire.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าไฟไหม้บ้านเรือนของเรา ความฝันนี้จะได้รับความเดือดร้อนใจ ให้ไปแก้ฝันกับแม่น้ำหรือลำคลองเสียจะได้บรรเทาลง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no one hurt: smoke rising from a house roof, a worried person floating a small offering on a river. Do not draw any numbers, words or letters anywhere in the picture.
```

### 8. ไฟโคมและเทียน — `fan-lamp`

- ไฟล์ที่ต้องได้: `images/fan-lamp.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นโคมไฟหรือดวงเทียน ความฝันนี้ท่านจะพบกับมิตรที่ซื่อตรง เฉลียวฉลาด นิสัยดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a lantern and lit candles glowing warmly, two good friends shaking hands beside them. Do not draw any numbers, words or letters anywhere in the picture.
```

### 9. ไฟไหม้ป่า — `fan-forest-fire`

- ไฟล์ที่ต้องได้: `images/fan-forest-fire.jpg`
- เลข: 44, 84, 244, 284
- คำทำนาย (ต้นฉบับ): ฝันเห็นไฟไหม้ป่า ความฝันนี้ท่านจะได้ลาภมาจากเพศตรงข้าม

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a forest fire burning on a distant hillside, a person receiving a gift from someone of the opposite sex. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 44; top-right: 84; bottom-left: 244; bottom-right: 284. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```
