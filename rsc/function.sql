alter table jaxsta_main_entity.work drop column creation_year;
--jaxsta_main_entity.mv_entity_work_contribution

CREATE OR REPLACE MATERIALIZED VIEW jaxsta_main_entity.mv_entity_work_contribution
(
  id,
  entity_id,
  entity_uuid,
  work_id,
  work_uuid,
  creation_year,
  work_title,
  iswc,
  role_ids
)
AS 
 SELECT row_number() OVER (ORDER BY t.entity_id) AS id,
    t.entity_id,
    e.jaxsta_uuid AS entity_uuid,
    w.id AS work_id,
    w.jaxsta_uuid AS work_uuid,
    create as creation_year,
    "left"(w.creation_year::text, 4) AS creation_year,
    w.work_title,
    w.iswc,
    t.role_ids
   FROM ( SELECT we.entity_id,
            we.work_id,
            jsonb_agg(DISTINCT we.entity_role_id) AS role_ids
           FROM jaxsta_main_entity.work_entity we
             JOIN jaxsta_main_entity.role r ON r.id = we.entity_role_id
          GROUP BY we.entity_id, we.work_id, we.entity_role_id) t
     JOIN jaxsta_main_entity.work w ON w.id = t.work_id
     JOIN jaxsta_main_entity.entity e ON e.id = t.entity_id;


CREATE INDEX idx__mv_entity_work_contribution_id ON jaxsta_main_entity.mv_entity_work_contribution USING btree (id);
CREATE INDEX idx__mv_entity_work_contribution__entity_id ON jaxsta_main_entity.mv_entity_work_contribution USING btree (entity_id);
CREATE INDEX idx__mv_entity_work_contribution__work_id ON jaxsta_main_entity.mv_entity_work_contribution USING btree (work_id);
CREATE INDEX idx__mv_entity_work_contribution__entity_id_work_id ON jaxsta_main_entity.mv_entity_work_contribution USING btree (entity_id, work_id);
CREATE INDEX idx__mv_entity_work_contribution__id_entity_id_work_id ON jaxsta_main_ecntity.mv_entity_work_contribution USING btree (id, entity_id, work_id);
CREATE INDEX idx__mv_entity_work_contribution__ids_and_uuids ON jaxsta_main_entity.mv_entity_work_contribution USING btree (id, entity_id, work_id, entity_uuid, work_uuid);




