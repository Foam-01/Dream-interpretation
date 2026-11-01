# หมวด อ — prompt สร้างภาพ (5 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-32-ang/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (4 รายการ) ห้ามมีเลขในภาพ
- อสรพิษ / อินทรี เขียนให้ไม่มีบาดแผลหรือเลือด
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | อสรพิษ | `ang-venomous.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | อาทิตย์ | `ang-sun.jpg` | 00, 01, 000, 301 |
| 3 | อาบน้ำ | `ang-bathing.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 4 | อินทรี | `ang-eagle.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 5 | อุโมงค์ | `ang-tunnel.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. อสรพิษ — `ang-venomous`

- ไฟล์ที่ต้องได้: `images/ang-venomous.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าถูกอสรพิษ เช่น งูหรือแมลงกัดต่อย ได้รับความเจ็บปวด ความฝันนี้ ถ้าท่านกำลังเจ็บป่วยหรือมีทุกข์เดือดร้อน จะคลายหายหรือผ่อนหนักลงเป็นเบาได้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no wound: a snake and a wasp near a person resting in bed, the person feeling relieved. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. อาทิตย์ — `ang-sun`

- ไฟล์ที่ต้องได้: `images/ang-sun.jpg`
- เลข: 00, 01, 000, 301
- คำทำนาย (ต้นฉบับ): ฝันเห็นดวงอาทิตย์ ทายว่า ผู้ใหญ่จะให้ลาภ จะได้ยศศักดิ์อำนาจหน้าที่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a big radiant sun over the horizon, an elder handing a person a rank sash. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 00; top-right: 01; bottom-left: 000; bottom-right: 301. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 3. อาบน้ำ — `ang-bathing`

- ไฟล์ที่ต้องได้: `images/ang-bathing.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าอาบน้ำ ทายว่า จะประสบโชค หมดเคราะห์ หมดโศก หมดโรค หมดภัย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person bathing with a bowl of water by a clay water jar, looking refreshed and happy. Do not draw any numbers, words or letters anywhere in the picture.
```

### 4. อินทรี — `ang-eagle`

- ไฟล์ที่ต้องได้: `images/ang-eagle.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นนกอินทรี หรือนกยักษ์ขนาดใหญ่บินอยู่เหนือศีรษะ หรือถูกไล่จิกทำร้าย ความฝันนี้ท่านจะต้องหาทางทำบุญสะเดาะเคราะห์เสีย เพราะท่านกำลังจะได้รับเคราะห์จากผู้มีอำนาจสูงกว่า

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a huge eagle flying over a frightened person, the person offering food to monks. Do not draw any numbers, words or letters anywhere in the picture.
```

### 5. อุโมงค์ — `ang-tunnel`

- ไฟล์ที่ต้องได้: `images/ang-tunnel.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้เดินลอดเข้าไปในอุโมงค์ แล้วพบทางตันไม่มีทางออก ทายว่า สิ่งที่คิดไว้หรือโครงการต่าง ๆ ที่สร้างขึ้นจะล้มเหลว จะมีอุปสรรคหรือศัตรูอิจฉาริษยารอบด้าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking inside a dark tunnel that ends in a solid wall, jealous faces peering in from the entrance. Do not draw any numbers, words or letters anywhere in the picture.
```
