/*
|--------------------------------------------------------------------------
| FILE: 03_indexes.sql
|--------------------------------------------------------------------------
|
| PURPOSE:
| يحتوي على جميع الـ Indexes الخاصة بتحسين الأداء.
|
| CONTENTS:
| - CREATE INDEX
| - CREATE UNIQUE INDEX
| - GIN Indexes
| - BTREE Indexes
|
| EXAMPLES:
| - search indexes
| - foreign key indexes
|
| WHY IMPORTANT:
| يحسن سرعة البحث والاستعلامات بشكل كبير.
|
|--------------------------------------------------------------------------
*/

CREATE UNIQUE INDEX work_assignments_pkey ON ecosystem.work_assignments USING btree (id);
CREATE UNIQUE INDEX work_participants_pkey ON ecosystem.work_participants USING btree (id);
CREATE INDEX idx_entities_status ON ecosystem.entities USING btree (status);
CREATE INDEX idx_entities_type ON ecosystem.entities USING btree (type);
CREATE UNIQUE INDEX entities_pkey ON ecosystem.entities USING btree (id);
CREATE UNIQUE INDEX entity_execution_participants_pkey ON ecosystem.entity_execution_participants USING btree (id);
CREATE UNIQUE INDEX entity_members_pkey ON ecosystem.entity_members USING btree (id);
CREATE INDEX idx_entity_relations_child ON ecosystem.entity_relations USING btree (child_entity_id);
CREATE INDEX idx_entity_relations_context ON ecosystem.entity_relations USING btree (context_type, context_id);
CREATE INDEX idx_entity_relations_parent ON ecosystem.entity_relations USING btree (parent_entity_id);
CREATE INDEX idx_entity_relations_parent_type ON ecosystem.entity_relations USING btree (parent_entity_id, relation_type);
CREATE INDEX idx_entity_relations_validity ON ecosystem.entity_relations USING btree (valid_from, valid_until);
CREATE UNIQUE INDEX entity_relations_pkey ON ecosystem.entity_relations USING btree (id);
CREATE UNIQUE INDEX entity_relationships_pkey ON ecosystem.entity_relationships USING btree (id);
CREATE UNIQUE INDEX user_entity_membership_pkey ON ecosystem.user_entity_membership USING btree (user_id, entity_id);