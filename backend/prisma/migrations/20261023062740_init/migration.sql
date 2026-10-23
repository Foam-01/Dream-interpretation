-- CreateEnum
CREATE TYPE "ContentStatus" AS ENUM ('SAMPLE', 'VERIFIED');

-- CreateTable
CREATE TABLE "dream_category" (
    "id" VARCHAR(64) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "dream_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dream" (
    "id" VARCHAR(64) NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "category_id" VARCHAR(64) NOT NULL,
    "short" TEXT NOT NULL,
    "meaning" TEXT NOT NULL,
    "advice" TEXT NOT NULL,
    "is_good_omen" BOOLEAN NOT NULL,
    "digits" TEXT[],
    "two_digit" TEXT[],
    "three_digit" TEXT[],
    "luck_money" SMALLINT NOT NULL,
    "luck_love" SMALLINT NOT NULL,
    "luck_health" SMALLINT NOT NULL,
    "content_status" "ContentStatus" NOT NULL DEFAULT 'SAMPLE',
    "sort_order" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "dream_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "dream_category_name_key" ON "dream_category"("name");

-- CreateIndex
CREATE UNIQUE INDEX "dream_category_sort_order_key" ON "dream_category"("sort_order");

-- CreateIndex
CREATE UNIQUE INDEX "dream_sort_order_key" ON "dream"("sort_order");

-- CreateIndex
CREATE INDEX "dream_category_id_sort_order_idx" ON "dream"("category_id", "sort_order");

-- AddForeignKey
ALTER TABLE "dream" ADD CONSTRAINT "dream_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "dream_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- Hand-written constraints (not expressible in the Prisma schema).
-- Public ids are lowercase slugs.
ALTER TABLE "dream_category" ADD CONSTRAINT "dream_category_id_slug_chk" CHECK ("id" ~ '^[a-z0-9-]{1,64}$');
ALTER TABLE "dream" ADD CONSTRAINT "dream_id_slug_chk" CHECK ("id" ~ '^[a-z0-9-]{1,64}$');

-- Lucky numbers: non-empty arrays of digit strings with fixed width, no NULL elements
-- (text keeps leading zeros such as '08' and '098').
ALTER TABLE "dream" ALTER COLUMN "digits" SET NOT NULL;
ALTER TABLE "dream" ALTER COLUMN "two_digit" SET NOT NULL;
ALTER TABLE "dream" ALTER COLUMN "three_digit" SET NOT NULL;
ALTER TABLE "dream" ADD CONSTRAINT "dream_digits_chk"
  CHECK (cardinality("digits") > 0 AND array_position("digits", NULL) IS NULL
         AND array_to_string("digits", ',') ~ '^[0-9](,[0-9])*$');
ALTER TABLE "dream" ADD CONSTRAINT "dream_two_digit_chk"
  CHECK (cardinality("two_digit") > 0 AND array_position("two_digit", NULL) IS NULL
         AND array_to_string("two_digit", ',') ~ '^[0-9]{2}(,[0-9]{2})*$');
ALTER TABLE "dream" ADD CONSTRAINT "dream_three_digit_chk"
  CHECK (cardinality("three_digit") > 0 AND array_position("three_digit", NULL) IS NULL
         AND array_to_string("three_digit", ',') ~ '^[0-9]{3}(,[0-9]{3})*$');

-- Sample forecast scores are 0-100 inclusive.
ALTER TABLE "dream" ADD CONSTRAINT "dream_luck_money_chk" CHECK ("luck_money" BETWEEN 0 AND 100);
ALTER TABLE "dream" ADD CONSTRAINT "dream_luck_love_chk" CHECK ("luck_love" BETWEEN 0 AND 100);
ALTER TABLE "dream" ADD CONSTRAINT "dream_luck_health_chk" CHECK ("luck_health" BETWEEN 0 AND 100);
