
set search_path to jaxsta_main_entity;

UPDATE work
   SET rank = a.rank
FROM (
    SELECT 
        b.work_id,
        sum(b.count_no) AS rank
    FROM (
            SELECT 
                wr.work_id,
                count(recording_id) * 20  AS count_no
            FROM work_recording wr
            GROUP BY work_id
        UNION
            SELECT 
                work_entity.work_id,
                count(entity_id)         AS count_no
            FROM work_entity
            WHERE entity_id IS NOT NULL
            GROUP BY work_id
        UNION
            SELECT 
                work.id                 AS work_id,
                count(iswc_code) * 5    AS count_no
            FROM work
            WHERE iswc_code IS NOT NULL
            GROUP BY work_id
    ) b
    GROUP BY b.work_id
) a 
WHERE work.id = a.work_id
AND   work.rank IS NULL;

--child entity should have 0 rank
UPDATE work
   SET rank = 0
WHERE primary_id IS NOT NULL 
AND rank > 0;

-- ADD RECORDING RANK (Needs to run nightly, need to incorporate iTunes popularity data)
UPDATE recording
   SET rank = a.rank
FROM (SELECT b.recording_id,
             sum(b.count_no) AS rank
      FROM (SELECT work_recording.recording_id,
                   ((count(work_id))*20) AS count_no
            FROM work_recording
            GROUP BY recording_id
            UNION
            SELECT recording_entity.recording_id,
                   ((count(entity_id))*1) AS count_no
            FROM recording_entity
            WHERE entity_id IS NOT NULL
            GROUP BY recording_id
            UNION
            SELECT 
                rvr.recording_id,
                count(release_variant_id)      AS count_no
            FROM release_variant_recording rvr
            WHERE release_variant_id IS NOT NULL
            GROUP BY recording_id
            UNION
            SELECT recording.id                AS recording_id,
                   count(isrc_code) * 5        AS count_no
            FROM recording
            WHERE isrc_code IS NOT NULL
            GROUP BY recording_id) b
      GROUP BY b.recording_id) a
WHERE recording.id = a.recording_id
AND   recording.rank IS NULL;

UPDATE recording
   SET rank = 0
WHERE primary_id IS NOT NULL
AND   rank > 0;

-- ADD ENTITY RANK (Needs to run nightly, need to incorporate iTunes popularity data)
-- 'UPDATED for jaxsta_main_entity'
-- 'Needs to add in Apple EPF calculations for true rank'
UPDATE entity
   SET rank = a.rank
FROM (SELECT b.entity_id,
             sum(b.count_no) AS rank
      FROM (SELECT DISTINCT entity_image.entity_id,
                   ((count(DISTINCT entity_id))*5000) AS count_no
            FROM entity_image
            WHERE entity_id IS NOT NULL
            GROUP BY entity_id
            UNION
            SELECT rvc.entity_id,
                   ((count(rvi.id))*500) AS count_no
            FROM release_variant_entity rvc
              LEFT JOIN release_variant_image rvi ON rvi.release_variant_id = rvc.release_variant_id
            WHERE rvc.entity_id IS NOT NULL
            GROUP BY rvc.entity_id
            UNION
            SELECT release_group_entity.entity_id,
                   ((count(DISTINCT entity_id))*1000) AS count_no
            FROM release_group_entity
            WHERE entity_id IS NOT NULL
            AND   entity_role_id = 433
            GROUP BY entity_id
            UNION
            SELECT release_group_entity.entity_id,
                   ((count(id))*2) AS count_no
            FROM release_group_entity
            WHERE entity_id IS NOT NULL
            GROUP BY entity_id
            UNION
            SELECT release_variant_entity.entity_id,
                   ((count(id))*2) AS count_no
            FROM release_variant_entity
            WHERE entity_id IS NOT NULL
            GROUP BY entity_id
            UNION
            SELECT recording_entity.entity_id,
                   ((count(id))*2) AS count_no
            FROM recording_entity
            WHERE entity_id IS NOT NULL
            GROUP BY entity_id
            UNION
            SELECT work_entity.entity_id,
                   count(id) AS count_no
            FROM work_entity
            WHERE entity_id IS NOT NULL
            GROUP BY entity_id
            UNION
            SELECT entity.id,
                   '20000' AS count_no
            FROM entity
            WHERE id::TEXT NOT LIKE '61%'
            AND   primary_id IS NULL
            GROUP BY id
            UNION
            SELECT entity.id,
                   '10000' AS count_no
            FROM entity
            WHERE id::TEXT LIKE '99%'
            AND   primary_id IS NULL
            GROUP BY id) b
      GROUP BY b.entity_id) a
WHERE entity.id = a.entity_id
AND   entity.rank IS NULL;

UPDATE entity
   SET rank = 0
WHERE primary_id IS NOT NULL
AND   rank > 0;

-- ADD RELEASE GROUP RANK  (Needs to run nightly, need to incorporate iTunes popularity data)
UPDATE release_group rg
   SET rank = a.rank
FROM (SELECT b.release_group_id,
             sum(b.count_no) AS rank
      FROM (SELECT release_variant.release_group_id,
                   ((count(release_variant_image.image_id))*1000) AS count_no
            FROM release_variant_image
              LEFT JOIN release_variant ON release_variant.id = release_variant_image.release_variant_id
            GROUP BY release_variant.release_group_id
            UNION
            SELECT release_group_entity.release_group_id,
                   ((count(entity_id))*10) AS count_no
            FROM release_group_entity
            WHERE entity_id IS NOT NULL
            GROUP BY release_group_id) b
      GROUP BY b.release_group_id) a
WHERE rg.id = a.release_group_id
AND   rg.rank IS NULL;

UPDATE release_group
   SET rank = 0
WHERE id NOT IN (SELECT rv.release_group_id
                 FROM release_variant rv);

UPDATE release_group
   SET rank = 0
WHERE primary_id IS NOT NULL;

-- ADD RELEASE VARIANT RANK  (Needs to run nightly, need to incorporate iTunes popularity data)
UPDATE release_variant rv
   SET rank = a.rank
FROM (SELECT b.release_variant_id,
             sum(b.count_no) AS rank
      FROM (SELECT DISTINCT ON (release_variant_image.release_variant_id) release_variant_image.release_variant_id,
                   ((count(image_id))*1000) AS count_no
            FROM release_variant_image
            GROUP BY release_variant_id
            UNION
            SELECT release_variant_entity.release_variant_id,
                   ((count(entity_id))*10) AS count_no
            FROM release_variant_entity
            WHERE entity_id IS NOT NULL
            GROUP BY release_variant_id
            UNION
            SELECT release_variant.id AS release_variant_id,
                   ((count(upc_a))*5) AS count_no
            FROM release_variant
            WHERE upc_a IS NOT NULL
            GROUP BY release_variant_id
            UNION
            SELECT release_variant.id AS release_variant_id,
                   ((count(release_variant.id))*1) AS count_no
            FROM release_variant
            GROUP BY release_variant_id
            UNION
            SELECT release_variant_recording.release_variant_id,
                   ((count(recording_id))*1) AS count_no
            FROM release_variant_recording
            WHERE recording_id IS NOT NULL
            GROUP BY release_variant_id) b
      GROUP BY b.release_variant_id) a
WHERE rv.id = a.release_variant_id
AND   rv.rank IS NULL;

UPDATE release_variant
   SET rank = 1
WHERE id NOT IN (SELECT a.id
                 FROM (SELECT DISTINCT ON (rv.release_group_id) rv.release_group_id,
                              rv.id,
                              rv.rank
                       FROM release_variant rv
                       GROUP BY rv.release_group_id,
                                rv.id
                       ORDER BY rv.release_group_id ASC,
                                rv.rank DESC) a);

UPDATE release_variant
   SET rank = 0
WHERE primary_id IS NOT NULL
AND   rank > 0;

