# หมวด ซ — prompt สร้างภาพ (2 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-09-s/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (2 รายการ) ห้ามมีเลขในภาพ
- โซ่ เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีภาพรุนแรง
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ซื้อ | `s-buying.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | โซ่ | `s-chain.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ซื้อ — `s-buying`

- ไฟล์ที่ต้องได้: `images/s-buying.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าไปซื้อหาสิ่งที่ต้องใจ หรือคิดอยากจะได้มานานแล้ว ความฝันนี้ท่านจะพบข่าวดีจากญาติมิตรสหายที่อยู่ห่างไกล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person happily buying a long-wished-for item at a market stall, a letter from a faraway friend in their other hand. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. โซ่ — `s-chain`

- ไฟล์ที่ต้องได้: `images/s-chain.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าถูกฉุดลากด้วยโซ่ ความฝันนี้ระวังตัวของท่านจะมีศัตรูคอยลอบทำร้าย หรือมีผู้นำความไม่ดีมาใส่ให้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no violence: a heavy iron chain pulled taut along the ground towards a frightened person, a shadowy figure in the distance. Do not draw any numbers, words or letters anywhere in the picture.
```
