import 'design_data.dart';
import 'dream_images_kh.dart';

/// Bundled illustrations of หมวด ก dreams, by stable dream id. Resized from the owner-supplied images in
/// backend/content/incoming/category-01-k/images (the originals are unchanged).
/// - From the first set (k-01 … k-10): matched by the lucky numbers drawn in each picture; pictures showing
///   two dreams were split left/right. Not used (owner decision): k-06 (shows 157, not in the source) and
///   the left half of k-10.
/// - Generated from image-prompts.md (`images/<id>.jpg`, round 2 `images/<id>-v2.png`), each checked against
///   the source numbers; round-1 pictures with a wrong or missing number were replaced by round 2 (REVIEW.md).
const dreamImagesK = <String, DreamImage>{
  'k-chicken': DreamImage.asset('assets/dreams/k-chicken.jpg', alt: 'ภาพประกอบ: ไก่'),
  'k-taking-medicine': DreamImage.asset('assets/dreams/k-taking-medicine.jpg', alt: 'ภาพประกอบ: กินยา'),
  'k-key': DreamImage.asset('assets/dreams/k-key.jpg', alt: 'ภาพประกอบ: กุญแจ'),
  'k-eating-rice': DreamImage.asset('assets/dreams/k-eating-rice.jpg', alt: 'ภาพประกอบ: กินข้าว'),
  'k-rabbit': DreamImage.asset('assets/dreams/k-rabbit.jpg', alt: 'ภาพประกอบ: กระต่าย'),
  'k-drum': DreamImage.asset('assets/dreams/k-drum.jpg', alt: 'ภาพประกอบ: กลอง'),
  'k-cart-riding': DreamImage.asset('assets/dreams/k-cart-riding.jpg', alt: 'ภาพประกอบ: เกวียน'),
  'k-frog': DreamImage.asset('assets/dreams/k-frog.jpg', alt: 'ภาพประกอบ: กบ'),
  'k-bird-cage': DreamImage.asset('assets/dreams/k-bird-cage.jpg', alt: 'ภาพประกอบ: กรงนก'),
  'k-eating-lotus': DreamImage.asset('assets/dreams/k-eating-lotus.jpg', alt: 'ภาพประกอบ: กินบัว'),
  'k-eating-bees': DreamImage.asset('assets/dreams/k-eating-bees.jpg', alt: 'ภาพประกอบ: กินผึ้ง'),
  'k-glass-vessel': DreamImage.asset('assets/dreams/k-glass-vessel.jpg', alt: 'ภาพประกอบ: แก้ว (ภาชนะ)'),
  'k-jaw': DreamImage.asset('assets/dreams/k-jaw.jpg', alt: 'ภาพประกอบ: กราม'),
  'k-kris': DreamImage.asset('assets/dreams/k-kris.jpg', alt: 'ภาพประกอบ: กฤช (กริช)'),
  'k-wishing-tree': DreamImage.asset('assets/dreams/k-wishing-tree.jpg', alt: 'ภาพประกอบ: กัลปพฤกษ์'),
  'k-klot-parasol': DreamImage.asset('assets/dreams/k-klot-parasol.jpg', alt: 'ภาพประกอบ: กางกลด'),
  'k-umbrella': DreamImage.asset('assets/dreams/k-umbrella.jpg', alt: 'ภาพประกอบ: กางร่ม'),
  'k-eating-person': DreamImage.asset('assets/dreams/k-eating-person.jpg', alt: 'ภาพประกอบ: กินคน'),
  'k-eating-earth': DreamImage.asset('assets/dreams/k-eating-earth.jpg', alt: 'ภาพประกอบ: กินดิน'),
  'k-eating-bird': DreamImage.asset('assets/dreams/k-eating-bird.jpg', alt: 'ภาพประกอบ: กินนก'),
  'k-eating-moon': DreamImage.asset('assets/dreams/k-eating-moon.jpg', alt: 'ภาพประกอบ: กินพระจันทร์'),
  'k-eating-food': DreamImage.asset('assets/dreams/k-eating-food.jpg', alt: 'ภาพประกอบ: กินอาหาร'),
  'k-eating-food-with-relatives': DreamImage.asset('assets/dreams/k-eating-food-with-relatives.jpg', alt: 'ภาพประกอบ: กินอาหาร'),
  'k-lost-key': DreamImage.asset('assets/dreams/k-lost-key.jpg', alt: 'ภาพประกอบ: กุญแจหาย'),
  'k-cart-passing': DreamImage.asset('assets/dreams/k-cart-passing.jpg', alt: 'ภาพประกอบ: เกวียน'),
  'k-growing-old': DreamImage.asset('assets/dreams/k-growing-old.jpg', alt: 'ภาพประกอบ: แก่'),
  'k-shaving': DreamImage.asset('assets/dreams/k-shaving.jpg', alt: 'ภาพประกอบ: โกน'),
  'k-anger': DreamImage.asset('assets/dreams/k-anger.jpg', alt: 'ภาพประกอบ: โกรธ'),
  'k-king': DreamImage.asset('assets/dreams/k-king.jpg', alt: 'ภาพประกอบ: กษัตริย์'),
  'k-hug': DreamImage.asset('assets/dreams/k-hug.jpg', alt: 'ภาพประกอบ: กอด'),
  'k-eating-human-flesh': DreamImage.asset('assets/dreams/k-eating-human-flesh.jpg', alt: 'ภาพประกอบ: กินเนื้อคน'),
  'k-sandalwood': DreamImage.asset('assets/dreams/k-sandalwood.jpg', alt: 'ภาพประกอบ: แก่นจันทน์'),
  'k-crystal-orb': DreamImage.asset('assets/dreams/k-crystal-orb.jpg', alt: 'ภาพประกอบ: แก้ว (ดวง)'),
};

/// The image to show for a dream: the API's image when it has one, else the bundled one, else null
/// (the placeholder). Works the same in offline and API mode.
DreamImage? dreamImageFor(String id, [DreamImage? remote]) => remote ?? dreamImagesK[id] ?? dreamImagesKh[id];
