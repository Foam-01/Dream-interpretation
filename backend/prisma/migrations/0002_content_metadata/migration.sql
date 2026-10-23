-- AlterEnum
ALTER TYPE "ContentStatus" ADD VALUE 'DRAFT';

-- AlterTable
ALTER TABLE "dream" ADD COLUMN     "aliases" TEXT[] DEFAULT ARRAY[]::TEXT[],
ADD COLUMN     "image_alt" VARCHAR(300),
ADD COLUMN     "image_credit" VARCHAR(300),
ADD COLUMN     "image_license" VARCHAR(100),
ADD COLUMN     "image_source_url" TEXT,
ADD COLUMN     "image_url" TEXT,
ADD COLUMN     "source_id" VARCHAR(64),
ADD COLUMN     "source_locator" VARCHAR(200),
ALTER COLUMN "advice" DROP NOT NULL,
ALTER COLUMN "is_good_omen" DROP NOT NULL,
ALTER COLUMN "luck_money" DROP NOT NULL,
ALTER COLUMN "luck_love" DROP NOT NULL,
ALTER COLUMN "luck_health" DROP NOT NULL;

-- CreateTable
CREATE TABLE "content_source" (
    "id" VARCHAR(64) NOT NULL,
    "title" VARCHAR(300) NOT NULL,
    "author" VARCHAR(200),
    "publisher" VARCHAR(200),
    "edition" VARCHAR(100),
    "year" SMALLINT,
    "url" TEXT,
    "note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "content_source_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "dream_source_id_idx" ON "dream"("source_id");

-- AddForeignKey
ALTER TABLE "dream" ADD CONSTRAINT "dream_source_id_fkey" FOREIGN KEY ("source_id") REFERENCES "content_source"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ---------------------------------------------------------------------------
-- Hand-written constraints (Prisma cannot express these).
-- Additive only: existing rows (10 SAMPLE dreams, all fields filled) satisfy every rule below.
-- ---------------------------------------------------------------------------

-- Aliases: never NULL, no NULL or blank elements.
UPDATE "dream" SET "aliases" = ARRAY[]::TEXT[] WHERE "aliases" IS NULL;
ALTER TABLE "dream" ALTER COLUMN "aliases" SET NOT NULL;
ALTER TABLE "dream" ADD CONSTRAINT "dream_aliases_chk"
  CHECK (array_position("aliases", NULL) IS NULL AND NOT ('' = ANY ("aliases")));

-- Digits may now be empty (printed sources often give only 2/3-digit numbers); format rules unchanged.
ALTER TABLE "dream" DROP CONSTRAINT "dream_digits_chk";
ALTER TABLE "dream" ADD CONSTRAINT "dream_digits_chk"
  CHECK (array_position("digits", NULL) IS NULL
         AND (cardinality("digits") = 0 OR array_to_string("digits", ',') ~ '^[0-9](,[0-9])*$'));

-- Forecast scores: all three or none (ranges are still checked by dream_luck_*_chk).
ALTER TABLE "dream" ADD CONSTRAINT "dream_luck_all_or_none_chk"
  CHECK (("luck_money" IS NULL) = ("luck_love" IS NULL) AND ("luck_love" IS NULL) = ("luck_health" IS NULL));

-- Images: https only; credit and license are required whenever there is an image; no orphan metadata.
ALTER TABLE "dream" ADD CONSTRAINT "dream_image_chk"
  CHECK (
    ("image_url" IS NULL AND "image_alt" IS NULL AND "image_credit" IS NULL
       AND "image_license" IS NULL AND "image_source_url" IS NULL)
    OR ("image_url" ~ '^https://[^\s]+$' AND "image_credit" IS NOT NULL AND "image_license" IS NOT NULL
        AND ("image_source_url" IS NULL OR "image_source_url" ~ '^https://[^\s]+$'))
  );

-- A locator (page/section) only makes sense with a source.
ALTER TABLE "dream" ADD CONSTRAINT "dream_source_locator_chk"
  CHECK ("source_locator" IS NULL OR "source_id" IS NOT NULL);

-- VERIFIED content must cite a source.
ALTER TABLE "dream" ADD CONSTRAINT "dream_verified_has_source_chk"
  CHECK ("content_status" <> 'VERIFIED' OR "source_id" IS NOT NULL);

-- Sources: slug ids, https URLs, plausible years (Buddhist Era years such as 2510 are allowed).
ALTER TABLE "content_source" ADD CONSTRAINT "content_source_id_slug_chk" CHECK ("id" ~ '^[a-z0-9-]{1,64}$');
ALTER TABLE "content_source" ADD CONSTRAINT "content_source_url_chk"
  CHECK ("url" IS NULL OR "url" ~ '^https://[^\s]+$');
ALTER TABLE "content_source" ADD CONSTRAINT "content_source_year_chk"
  CHECK ("year" IS NULL OR "year" BETWEEN 1000 AND 3000);
