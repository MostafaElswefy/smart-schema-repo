[
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "work",
    "object_name": "work_financial_routes.beneficiary_type",
    "definition": "COMMENT ON COLUMN work.work_financial_routes.beneficiary_type IS 'Determines who receives the money: \"payer\", \"payee\", \"both\", \"platform\".';"
  },
  {
    "object_type": "COMMENT",
    "schema_name": "work",
    "object_name": "idx_contract_participants_lookup",
    "definition": "COMMENT ON TABLE work.idx_contract_participants_lookup IS 'Accelerates role resolution for permission checks (active participants only).';"
  },
  {
    "object_type": "COMMENT",
    "schema_name": "work",
    "object_name": "idx_contract_permissions_entity",
    "definition": "COMMENT ON TABLE work.idx_contract_permissions_entity IS 'Used by check_contract_permission for direct RBAC lookups.';"
  },
  {
    "object_type": "COMMENT",
    "schema_name": "work",
    "object_name": "permission_evaluation_log",
    "definition": "COMMENT ON TABLE work.permission_evaluation_log IS 'Audit log for permission evaluation to resolve ambiguity between direct entity and role-based policies.';"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "approval_step_assignees_entity_id_fkey",
    "definition": "ALTER TABLE work.approval_step_assignees ADD CONSTRAINT approval_step_assignees_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "approval_step_assignees_pkey",
    "definition": "ALTER TABLE work.approval_step_assignees ADD CONSTRAINT approval_step_assignees_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "approval_step_assignees_workflow_step_id_fkey",
    "definition": "ALTER TABLE work.approval_step_assignees ADD CONSTRAINT approval_step_assignees_workflow_step_id_fkey FOREIGN KEY (workflow_step_id) REFERENCES work.approval_workflow_steps(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "approval_workflow_steps_pkey",
    "definition": "ALTER TABLE work.approval_workflow_steps ADD CONSTRAINT approval_workflow_steps_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "approval_workflow_steps_step_type_check",
    "definition": "ALTER TABLE work.approval_workflow_steps ADD CONSTRAINT approval_workflow_steps_step_type_check CHECK ((step_type = ANY (ARRAY['sequential'::text, 'parallel'::text, 'quorum'::text])));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "approval_workflow_steps_workflow_template_id_fkey",
    "definition": "ALTER TABLE work.approval_workflow_steps ADD CONSTRAINT approval_workflow_steps_workflow_template_id_fkey FOREIGN KEY (workflow_template_id) REFERENCES work.approval_workflow_templates(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "approval_workflow_templates_pkey",
    "definition": "ALTER TABLE work.approval_workflow_templates ADD CONSTRAINT approval_workflow_templates_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_allocation_percent_range",
    "definition": "ALTER TABLE work.contract_participants ADD CONSTRAINT chk_allocation_percent_range CHECK (((allocation_percent IS NULL) OR ((allocation_percent >= (0)::numeric) AND (allocation_percent <= (100)::numeric))));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_amount_or_percentage",
    "definition": "ALTER TABLE work.work_financial_routes ADD CONSTRAINT chk_amount_or_percentage CHECK (((amount IS NOT NULL) <> (percentage IS NOT NULL)));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_dispute_target",
    "definition": "ALTER TABLE work.dispute_cases ADD CONSTRAINT chk_dispute_target CHECK ((((execution_unit_id IS NOT NULL) AND (approval_id IS NULL)) OR ((execution_unit_id IS NULL) AND (approval_id IS NOT NULL)) OR ((execution_unit_id IS NULL) AND (approval_id IS NULL))));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_effective_not_before_creation",
    "definition": "ALTER TABLE work.work_ownership_transfers ADD CONSTRAINT chk_effective_not_before_creation CHECK ((effective_at >= created_at));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_effective_not_too_old",
    "definition": "ALTER TABLE work.work_ownership_transfers ADD CONSTRAINT chk_effective_not_too_old CHECK ((effective_at >= (created_at - '5 years'::interval)));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_financial_percent_range",
    "definition": "ALTER TABLE work.work_financial_routes ADD CONSTRAINT chk_financial_percent_range CHECK (((percentage IS NULL) OR ((percentage >= (0)::numeric) AND (percentage <= (100)::numeric))));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_milestone_amount",
    "definition": "ALTER TABLE work.work_execution_units ADD CONSTRAINT chk_milestone_amount CHECK ((((is_milestone = false) AND (milestone_amount IS NULL)) OR ((is_milestone = true) AND (milestone_amount IS NOT NULL))));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_progress_percent_range",
    "definition": "ALTER TABLE work.work_execution_units ADD CONSTRAINT chk_progress_percent_range CHECK (((progress_percent >= (0)::numeric) AND (progress_percent <= (100)::numeric)));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_total_amount_non_negative",
    "definition": "ALTER TABLE work.contracts ADD CONSTRAINT chk_total_amount_non_negative CHECK ((total_amount >= (0)::numeric));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_transfer_diff_entities",
    "definition": "ALTER TABLE work.work_ownership_transfers ADD CONSTRAINT chk_transfer_diff_entities CHECK ((from_entity_id <> to_entity_id));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "chk_transfer_percentage_scope",
    "definition": "ALTER TABLE work.work_ownership_transfers ADD CONSTRAINT chk_transfer_percentage_scope CHECK ((((transfer_scope = 'full'::work.transfer_scope) AND (percentage IS NULL)) OR ((transfer_scope = 'partial'::work.transfer_scope) AND (percentage IS NOT NULL) AND (percentage >= (0)::numeric) AND (percentage <= (100)::numeric))));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_approval_workflows_contract_id_fkey",
    "definition": "ALTER TABLE work.contract_approval_workflows ADD CONSTRAINT contract_approval_workflows_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_approval_workflows_pkey",
    "definition": "ALTER TABLE work.contract_approval_workflows ADD CONSTRAINT contract_approval_workflows_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_approval_workflows_workflow_template_id_fkey",
    "definition": "ALTER TABLE work.contract_approval_workflows ADD CONSTRAINT contract_approval_workflows_workflow_template_id_fkey FOREIGN KEY (workflow_template_id) REFERENCES work.approval_workflow_templates(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_approvals_pkey",
    "definition": "ALTER TABLE work.contract_approvals ADD CONSTRAINT contract_approvals_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_links_pkey",
    "definition": "ALTER TABLE work.contract_links ADD CONSTRAINT contract_links_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_messages_pkey",
    "definition": "ALTER TABLE work.contract_messages ADD CONSTRAINT contract_messages_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_ownership_history_contract_id_fkey",
    "definition": "ALTER TABLE work.contract_ownership_history ADD CONSTRAINT contract_ownership_history_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_ownership_history_pkey",
    "definition": "ALTER TABLE work.contract_ownership_history ADD CONSTRAINT contract_ownership_history_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_participants_pkey",
    "definition": "ALTER TABLE work.contract_participants ADD CONSTRAINT contract_participants_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contract_permissions_pkey",
    "definition": "ALTER TABLE work.contract_permissions ADD CONSTRAINT contract_permissions_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "contracts_pkey",
    "definition": "ALTER TABLE work.contracts ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_cases_against_entity_id_fkey",
    "definition": "ALTER TABLE work.dispute_cases ADD CONSTRAINT dispute_cases_against_entity_id_fkey FOREIGN KEY (against_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_cases_approval_id_fkey",
    "definition": "ALTER TABLE work.dispute_cases ADD CONSTRAINT dispute_cases_approval_id_fkey FOREIGN KEY (approval_id) REFERENCES work.contract_approvals(id) ON DELETE SET NULL;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_cases_contract_id_fkey",
    "definition": "ALTER TABLE work.dispute_cases ADD CONSTRAINT dispute_cases_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_cases_execution_unit_id_fkey",
    "definition": "ALTER TABLE work.dispute_cases ADD CONSTRAINT dispute_cases_execution_unit_id_fkey FOREIGN KEY (execution_unit_id) REFERENCES work.work_execution_units(id) ON DELETE SET NULL;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_cases_pkey",
    "definition": "ALTER TABLE work.dispute_cases ADD CONSTRAINT dispute_cases_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_cases_raised_by_entity_id_fkey",
    "definition": "ALTER TABLE work.dispute_cases ADD CONSTRAINT dispute_cases_raised_by_entity_id_fkey FOREIGN KEY (raised_by_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_cases_resolved_by_entity_id_fkey",
    "definition": "ALTER TABLE work.dispute_cases ADD CONSTRAINT dispute_cases_resolved_by_entity_id_fkey FOREIGN KEY (resolved_by_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_evidence_dispute_id_fkey",
    "definition": "ALTER TABLE work.dispute_evidence ADD CONSTRAINT dispute_evidence_dispute_id_fkey FOREIGN KEY (dispute_id) REFERENCES work.dispute_cases(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_evidence_pkey",
    "definition": "ALTER TABLE work.dispute_evidence ADD CONSTRAINT dispute_evidence_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_evidence_submitted_by_entity_id_fkey",
    "definition": "ALTER TABLE work.dispute_evidence ADD CONSTRAINT dispute_evidence_submitted_by_entity_id_fkey FOREIGN KEY (submitted_by_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_hearings_dispute_id_fkey",
    "definition": "ALTER TABLE work.dispute_hearings ADD CONSTRAINT dispute_hearings_dispute_id_fkey FOREIGN KEY (dispute_id) REFERENCES work.dispute_cases(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_hearings_pkey",
    "definition": "ALTER TABLE work.dispute_hearings ADD CONSTRAINT dispute_hearings_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_resolution_actions_dispute_id_fkey",
    "definition": "ALTER TABLE work.dispute_resolution_actions ADD CONSTRAINT dispute_resolution_actions_dispute_id_fkey FOREIGN KEY (dispute_id) REFERENCES work.dispute_cases(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "dispute_resolution_actions_pkey",
    "definition": "ALTER TABLE work.dispute_resolution_actions ADD CONSTRAINT dispute_resolution_actions_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "event_outbox_idempotency_key_unique",
    "definition": "ALTER TABLE work.event_outbox ADD CONSTRAINT event_outbox_idempotency_key_unique UNIQUE (idempotency_key);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "event_outbox_pkey",
    "definition": "ALTER TABLE work.event_outbox ADD CONSTRAINT event_outbox_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "event_outbox_processed_pkey",
    "definition": "ALTER TABLE work.event_outbox_processed ADD CONSTRAINT event_outbox_processed_pkey PRIMARY KEY (idempotency_key);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "execution_logs_pkey",
    "definition": "ALTER TABLE work.execution_logs ADD CONSTRAINT execution_logs_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_approvals_contract",
    "definition": "ALTER TABLE work.contract_approvals ADD CONSTRAINT fk_approvals_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_contract_asset",
    "definition": "ALTER TABLE work.contracts ADD CONSTRAINT fk_contract_asset FOREIGN KEY (asset_code) REFERENCES app_wallet.assets(code);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_contract_created_by",
    "definition": "ALTER TABLE work.contracts ADD CONSTRAINT fk_contract_created_by FOREIGN KEY (created_by_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_contract_owned_by",
    "definition": "ALTER TABLE work.contracts ADD CONSTRAINT fk_contract_owned_by FOREIGN KEY (owned_by_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_exec_logs_contract",
    "definition": "ALTER TABLE work.execution_logs ADD CONSTRAINT fk_exec_logs_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_exec_logs_performer",
    "definition": "ALTER TABLE work.execution_logs ADD CONSTRAINT fk_exec_logs_performer FOREIGN KEY (performed_by_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_exec_units_assignee",
    "definition": "ALTER TABLE work.work_execution_units ADD CONSTRAINT fk_exec_units_assignee FOREIGN KEY (assigned_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_financial_contract",
    "definition": "ALTER TABLE work.work_financial_routes ADD CONSTRAINT fk_financial_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_links_child",
    "definition": "ALTER TABLE work.contract_links ADD CONSTRAINT fk_links_child FOREIGN KEY (child_contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_links_parent",
    "definition": "ALTER TABLE work.contract_links ADD CONSTRAINT fk_links_parent FOREIGN KEY (parent_contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_messages_sender",
    "definition": "ALTER TABLE work.contract_messages ADD CONSTRAINT fk_messages_sender FOREIGN KEY (sender_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_participant_contract",
    "definition": "ALTER TABLE work.contract_participants ADD CONSTRAINT fk_participant_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_participant_entity",
    "definition": "ALTER TABLE work.contract_participants ADD CONSTRAINT fk_participant_entity FOREIGN KEY (entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_participant_parent",
    "definition": "ALTER TABLE work.contract_participants ADD CONSTRAINT fk_participant_parent FOREIGN KEY (parent_participant_id) REFERENCES work.contract_participants(id) ON DELETE SET NULL;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_permissions_contract",
    "definition": "ALTER TABLE work.contract_permissions ADD CONSTRAINT fk_permissions_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_versions_contract",
    "definition": "ALTER TABLE work.work_contract_versions ADD CONSTRAINT fk_versions_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "fk_visibility_contract",
    "definition": "ALTER TABLE work.work_visibility ADD CONSTRAINT fk_visibility_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "permission_evaluation_log_pkey",
    "definition": "ALTER TABLE work.permission_evaluation_log ADD CONSTRAINT permission_evaluation_log_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "permission_policies_pkey",
    "definition": "ALTER TABLE work.permission_policies ADD CONSTRAINT permission_policies_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "policy_assignments_pkey",
    "definition": "ALTER TABLE work.policy_assignments ADD CONSTRAINT policy_assignments_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "policy_assignments_policy_id_fkey",
    "definition": "ALTER TABLE work.policy_assignments ADD CONSTRAINT policy_assignments_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES work.permission_policies(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "policy_conditions_pkey",
    "definition": "ALTER TABLE work.policy_conditions ADD CONSTRAINT policy_conditions_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "policy_conditions_policy_id_fkey",
    "definition": "ALTER TABLE work.policy_conditions ADD CONSTRAINT policy_conditions_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES work.permission_policies(id) ON DELETE CASCADE;"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "state_machines_entity_type_key",
    "definition": "ALTER TABLE work.state_machines ADD CONSTRAINT state_machines_entity_type_key UNIQUE (entity_type);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "state_machines_pkey",
    "definition": "ALTER TABLE work.state_machines ADD CONSTRAINT state_machines_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "state_transition_history_pkey",
    "definition": "ALTER TABLE work.state_transition_history ADD CONSTRAINT state_transition_history_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "state_transition_rules_entity_type_from_state_to_state_key",
    "definition": "ALTER TABLE work.state_transition_rules ADD CONSTRAINT state_transition_rules_entity_type_from_state_to_state_key UNIQUE (entity_type, from_state, to_state);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "state_transition_rules_pkey",
    "definition": "ALTER TABLE work.state_transition_rules ADD CONSTRAINT state_transition_rules_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_contract_participant_role",
    "definition": "ALTER TABLE work.contract_participants ADD CONSTRAINT uq_contract_participant_role UNIQUE (contract_id, entity_id, role);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_contract_permission",
    "definition": "ALTER TABLE work.contract_permissions ADD CONSTRAINT uq_contract_permission UNIQUE (contract_id, entity_id, permission);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_contract_version",
    "definition": "ALTER TABLE work.work_contract_versions ADD CONSTRAINT uq_contract_version UNIQUE (contract_id, version_no);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_execution_log_event",
    "definition": "ALTER TABLE work.execution_logs ADD CONSTRAINT uq_execution_log_event UNIQUE (contract_id, event_type, target_entity_id, target_entity_type);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_execution_log_idempotent",
    "definition": "ALTER TABLE work.execution_logs ADD CONSTRAINT uq_execution_log_idempotent UNIQUE (idempotency_key);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_execution_unit_sequence",
    "definition": "ALTER TABLE work.work_execution_units ADD CONSTRAINT uq_execution_unit_sequence UNIQUE (contract_id, sequence_no);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_execution_unit_title_per_contract",
    "definition": "ALTER TABLE work.work_execution_units ADD CONSTRAINT uq_execution_unit_title_per_contract UNIQUE (contract_id, title);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_financial_route",
    "definition": "ALTER TABLE work.work_financial_routes ADD CONSTRAINT uq_financial_route UNIQUE (contract_id, payer_entity_id, payee_entity_id, beneficiary_type);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "uq_visibility_rule",
    "definition": "ALTER TABLE work.work_visibility ADD CONSTRAINT uq_visibility_rule UNIQUE (contract_id, viewer_entity_id, visible_entity_id, visibility_type);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "work_contract_versions_pkey",
    "definition": "ALTER TABLE work.work_contract_versions ADD CONSTRAINT work_contract_versions_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "work_execution_units_assigned_by_entity_id_fkey",
    "definition": "ALTER TABLE work.work_execution_units ADD CONSTRAINT work_execution_units_assigned_by_entity_id_fkey FOREIGN KEY (assigned_by_entity_id) REFERENCES ecosystem.entities(id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "work_execution_units_pkey",
    "definition": "ALTER TABLE work.work_execution_units ADD CONSTRAINT work_execution_units_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "work_financial_routes_pkey",
    "definition": "ALTER TABLE work.work_financial_routes ADD CONSTRAINT work_financial_routes_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers_pkey",
    "definition": "ALTER TABLE work.work_ownership_transfers ADD CONSTRAINT work_ownership_transfers_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers_propagation_status_check",
    "definition": "ALTER TABLE work.work_ownership_transfers ADD CONSTRAINT work_ownership_transfers_propagation_status_check CHECK ((propagation_status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'completed'::text, 'failed'::text])));"
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "work",
    "object_name": "work_visibility_pkey",
    "definition": "ALTER TABLE work.work_visibility ADD CONSTRAINT work_visibility_pkey PRIMARY KEY (id);"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_step_assignees.created_at",
    "definition": "ALTER TABLE work.approval_step_assignees ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_step_assignees.id",
    "definition": "ALTER TABLE work.approval_step_assignees ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_step_assignees.weight",
    "definition": "ALTER TABLE work.approval_step_assignees ALTER COLUMN weight SET DEFAULT 1;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_workflow_steps.completion_policy",
    "definition": "ALTER TABLE work.approval_workflow_steps ALTER COLUMN completion_policy SET DEFAULT 'all'::text;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_workflow_steps.created_at",
    "definition": "ALTER TABLE work.approval_workflow_steps ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_workflow_steps.id",
    "definition": "ALTER TABLE work.approval_workflow_steps ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_workflow_steps.is_mandatory",
    "definition": "ALTER TABLE work.approval_workflow_steps ALTER COLUMN is_mandatory SET DEFAULT true;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_workflow_templates.created_at",
    "definition": "ALTER TABLE work.approval_workflow_templates ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_workflow_templates.id",
    "definition": "ALTER TABLE work.approval_workflow_templates ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "approval_workflow_templates.is_default",
    "definition": "ALTER TABLE work.approval_workflow_templates ALTER COLUMN is_default SET DEFAULT false;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_approval_workflows.current_step_index",
    "definition": "ALTER TABLE work.contract_approval_workflows ALTER COLUMN current_step_index SET DEFAULT 1;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_approval_workflows.id",
    "definition": "ALTER TABLE work.contract_approval_workflows ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_approval_workflows.started_at",
    "definition": "ALTER TABLE work.contract_approval_workflows ALTER COLUMN started_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_approval_workflows.status",
    "definition": "ALTER TABLE work.contract_approval_workflows ALTER COLUMN status SET DEFAULT 'active'::text;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_approvals.created_at",
    "definition": "ALTER TABLE work.contract_approvals ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_approvals.id",
    "definition": "ALTER TABLE work.contract_approvals ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_approvals.status",
    "definition": "ALTER TABLE work.contract_approvals ALTER COLUMN status SET DEFAULT 'pending'::work.approval_status;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_approvals.updated_at",
    "definition": "ALTER TABLE work.contract_approvals ALTER COLUMN updated_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_links.created_at",
    "definition": "ALTER TABLE work.contract_links ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_links.id",
    "definition": "ALTER TABLE work.contract_links ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_messages.created_at",
    "definition": "ALTER TABLE work.contract_messages ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_messages.id",
    "definition": "ALTER TABLE work.contract_messages ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_messages.message_type",
    "definition": "ALTER TABLE work.contract_messages ALTER COLUMN message_type SET DEFAULT 'text'::work.message_type;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_ownership_history.created_at",
    "definition": "ALTER TABLE work.contract_ownership_history ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_ownership_history.id",
    "definition": "ALTER TABLE work.contract_ownership_history ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_ownership_history.updated_at",
    "definition": "ALTER TABLE work.contract_ownership_history ALTER COLUMN updated_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_participants.created_at",
    "definition": "ALTER TABLE work.contract_participants ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_participants.id",
    "definition": "ALTER TABLE work.contract_participants ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_participants.joined_at",
    "definition": "ALTER TABLE work.contract_participants ALTER COLUMN joined_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_participants.participation_mode",
    "definition": "ALTER TABLE work.contract_participants ALTER COLUMN participation_mode SET DEFAULT 'direct'::work.participation_mode;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_participants.status",
    "definition": "ALTER TABLE work.contract_participants ALTER COLUMN status SET DEFAULT 'active'::work.participant_status;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_participants.updated_at",
    "definition": "ALTER TABLE work.contract_participants ALTER COLUMN updated_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_participants.visibility_scope",
    "definition": "ALTER TABLE work.contract_participants ALTER COLUMN visibility_scope SET DEFAULT 'internal'::work.visibility_scope;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_permissions.created_at",
    "definition": "ALTER TABLE work.contract_permissions ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contract_permissions.id",
    "definition": "ALTER TABLE work.contract_permissions ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contracts.created_at",
    "definition": "ALTER TABLE work.contracts ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contracts.current_version_no",
    "definition": "ALTER TABLE work.contracts ALTER COLUMN current_version_no SET DEFAULT 1;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contracts.has_open_dispute",
    "definition": "ALTER TABLE work.contracts ALTER COLUMN has_open_dispute SET DEFAULT false;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contracts.id",
    "definition": "ALTER TABLE work.contracts ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contracts.status",
    "definition": "ALTER TABLE work.contracts ALTER COLUMN status SET DEFAULT 'draft'::work.contract_status;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contracts.total_amount",
    "definition": "ALTER TABLE work.contracts ALTER COLUMN total_amount SET DEFAULT 0;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contracts.updated_at",
    "definition": "ALTER TABLE work.contracts ALTER COLUMN updated_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "contracts.visibility_mode",
    "definition": "ALTER TABLE work.contracts ALTER COLUMN visibility_mode SET DEFAULT 'internal'::work.contract_visibility_mode;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_cases.created_at",
    "definition": "ALTER TABLE work.dispute_cases ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_cases.id",
    "definition": "ALTER TABLE work.dispute_cases ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_cases.raised_at",
    "definition": "ALTER TABLE work.dispute_cases ALTER COLUMN raised_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_cases.status",
    "definition": "ALTER TABLE work.dispute_cases ALTER COLUMN status SET DEFAULT 'open'::work.dispute_status;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_cases.updated_at",
    "definition": "ALTER TABLE work.dispute_cases ALTER COLUMN updated_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_evidence.id",
    "definition": "ALTER TABLE work.dispute_evidence ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_evidence.submitted_at",
    "definition": "ALTER TABLE work.dispute_evidence ALTER COLUMN submitted_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_hearings.created_at",
    "definition": "ALTER TABLE work.dispute_hearings ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_hearings.id",
    "definition": "ALTER TABLE work.dispute_hearings ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_hearings.is_online",
    "definition": "ALTER TABLE work.dispute_hearings ALTER COLUMN is_online SET DEFAULT false;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_resolution_actions.applied",
    "definition": "ALTER TABLE work.dispute_resolution_actions ALTER COLUMN applied SET DEFAULT false;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "dispute_resolution_actions.id",
    "definition": "ALTER TABLE work.dispute_resolution_actions ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "event_outbox.created_at",
    "definition": "ALTER TABLE work.event_outbox ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "event_outbox.event_version",
    "definition": "ALTER TABLE work.event_outbox ALTER COLUMN event_version SET DEFAULT 1;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "event_outbox.id",
    "definition": "ALTER TABLE work.event_outbox ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "event_outbox.idempotency_key",
    "definition": "ALTER TABLE work.event_outbox ALTER COLUMN idempotency_key SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "event_outbox.retry_count",
    "definition": "ALTER TABLE work.event_outbox ALTER COLUMN retry_count SET DEFAULT 0;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "event_outbox.status",
    "definition": "ALTER TABLE work.event_outbox ALTER COLUMN status SET DEFAULT 'pending'::text;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "event_outbox_processed.processed_at",
    "definition": "ALTER TABLE work.event_outbox_processed ALTER COLUMN processed_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "execution_logs.created_at",
    "definition": "ALTER TABLE work.execution_logs ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "execution_logs.id",
    "definition": "ALTER TABLE work.execution_logs ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "execution_logs.idempotency_key",
    "definition": "ALTER TABLE work.execution_logs ALTER COLUMN idempotency_key SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "permission_evaluation_log.evaluated_at",
    "definition": "ALTER TABLE work.permission_evaluation_log ALTER COLUMN evaluated_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "permission_evaluation_log.id",
    "definition": "ALTER TABLE work.permission_evaluation_log ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "permission_policies.effect",
    "definition": "ALTER TABLE work.permission_policies ALTER COLUMN effect SET DEFAULT 'allow'::text;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "permission_policies.enabled",
    "definition": "ALTER TABLE work.permission_policies ALTER COLUMN enabled SET DEFAULT true;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "permission_policies.id",
    "definition": "ALTER TABLE work.permission_policies ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "permission_policies.priority",
    "definition": "ALTER TABLE work.permission_policies ALTER COLUMN priority SET DEFAULT 0;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "policy_assignments.id",
    "definition": "ALTER TABLE work.policy_assignments ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "policy_conditions.created_at",
    "definition": "ALTER TABLE work.policy_conditions ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "policy_conditions.id",
    "definition": "ALTER TABLE work.policy_conditions ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "state_machines.created_at",
    "definition": "ALTER TABLE work.state_machines ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "state_machines.id",
    "definition": "ALTER TABLE work.state_machines ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "state_transition_history.created_at",
    "definition": "ALTER TABLE work.state_transition_history ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "state_transition_history.id",
    "definition": "ALTER TABLE work.state_transition_history ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "state_transition_rules.created_at",
    "definition": "ALTER TABLE work.state_transition_rules ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "state_transition_rules.id",
    "definition": "ALTER TABLE work.state_transition_rules ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "state_transition_rules.priority",
    "definition": "ALTER TABLE work.state_transition_rules ALTER COLUMN priority SET DEFAULT 0;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_contract_versions.created_at",
    "definition": "ALTER TABLE work.work_contract_versions ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_contract_versions.id",
    "definition": "ALTER TABLE work.work_contract_versions ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_execution_units.created_at",
    "definition": "ALTER TABLE work.work_execution_units ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_execution_units.id",
    "definition": "ALTER TABLE work.work_execution_units ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_execution_units.is_milestone",
    "definition": "ALTER TABLE work.work_execution_units ALTER COLUMN is_milestone SET DEFAULT false;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_execution_units.progress_percent",
    "definition": "ALTER TABLE work.work_execution_units ALTER COLUMN progress_percent SET DEFAULT 0;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_execution_units.status",
    "definition": "ALTER TABLE work.work_execution_units ALTER COLUMN status SET DEFAULT 'pending'::work.execution_unit_status;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_execution_units.unit_type",
    "definition": "ALTER TABLE work.work_execution_units ALTER COLUMN unit_type SET DEFAULT 'task'::work.unit_type;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_execution_units.updated_at",
    "definition": "ALTER TABLE work.work_execution_units ALTER COLUMN updated_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_financial_routes.created_at",
    "definition": "ALTER TABLE work.work_financial_routes ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_financial_routes.id",
    "definition": "ALTER TABLE work.work_financial_routes ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_financial_routes.is_hidden",
    "definition": "ALTER TABLE work.work_financial_routes ALTER COLUMN is_hidden SET DEFAULT false;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_financial_routes.priority",
    "definition": "ALTER TABLE work.work_financial_routes ALTER COLUMN priority SET DEFAULT 0;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers.apply_effects",
    "definition": "ALTER TABLE work.work_ownership_transfers ALTER COLUMN apply_effects SET DEFAULT true;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers.created_at",
    "definition": "ALTER TABLE work.work_ownership_transfers ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers.effective_at",
    "definition": "ALTER TABLE work.work_ownership_transfers ALTER COLUMN effective_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers.id",
    "definition": "ALTER TABLE work.work_ownership_transfers ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers.propagation_status",
    "definition": "ALTER TABLE work.work_ownership_transfers ALTER COLUMN propagation_status SET DEFAULT 'pending'::text;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers.transfer_scope",
    "definition": "ALTER TABLE work.work_ownership_transfers ALTER COLUMN transfer_scope SET DEFAULT 'full'::work.transfer_scope;"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_ownership_transfers.updated_at",
    "definition": "ALTER TABLE work.work_ownership_transfers ALTER COLUMN updated_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_visibility.created_at",
    "definition": "ALTER TABLE work.work_visibility ALTER COLUMN created_at SET DEFAULT now();"
  },
  {
    "object_type": "DEFAULT",
    "schema_name": "work",
    "object_name": "work_visibility.id",
    "definition": "ALTER TABLE work.work_visibility ALTER COLUMN id SET DEFAULT gen_random_uuid();"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "action_type",
    "definition": "CREATE TYPE work.action_type AS ENUM ('create', 'update', 'status_change', 'approve', 'reject', 'assign', 'transfer_ownership', 'add_participant', 'remove_participant', 'milestone_complete', 'payment_initiated');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "approval_status",
    "definition": "CREATE TYPE work.approval_status AS ENUM ('pending', 'approved', 'rejected');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "approval_type",
    "definition": "CREATE TYPE work.approval_type AS ENUM ('signature', 'funding', 'release', 'change', 'termination');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "beneficiary_type",
    "definition": "CREATE TYPE work.beneficiary_type AS ENUM ('payer', 'payee', 'both', 'platform');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "contract_status",
    "definition": "CREATE TYPE work.contract_status AS ENUM ('draft', 'active', 'paused', 'completed', 'cancelled', 'pending_approval', 'rejected', 'expired', 'disputed', 'archived');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "contract_visibility_mode",
    "definition": "CREATE TYPE work.contract_visibility_mode AS ENUM ('internal', 'external', 'client_only');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "dispute_status",
    "definition": "CREATE TYPE work.dispute_status AS ENUM ('open', 'under_investigation', 'mediation', 'arbitration', 'resolved', 'rejected', 'escalated');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "dispute_type",
    "definition": "CREATE TYPE work.dispute_type AS ENUM ('payment', 'delay', 'quality', 'scope_creep', 'termination', 'compliance', 'other');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "entity_type_enum",
    "definition": "CREATE TYPE work.entity_type_enum AS ENUM ('contract', 'milestone', 'execution_unit', 'approval');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "event_type",
    "definition": "CREATE TYPE work.event_type AS ENUM ('create', 'update', 'status_change', 'delete', 'assign', 'approve', 'reject', 'transfer_ownership', 'add_participant', 'remove_participant', 'milestone_complete', 'payment_initiated', 'pause', 'resume');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "execution_unit_status",
    "definition": "CREATE TYPE work.execution_unit_status AS ENUM ('pending', 'in_progress', 'completed', 'cancelled');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "link_type",
    "definition": "CREATE TYPE work.link_type AS ENUM ('subcontract', 'amendment', 'supersedes', 'references');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "message_type",
    "definition": "CREATE TYPE work.message_type AS ENUM ('text', 'image', 'voice', 'system', 'approval', 'payment', 'milestone');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "milestone_status",
    "definition": "CREATE TYPE work.milestone_status AS ENUM ('pending', 'in_progress', 'completed', 'cancelled');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "participant_function",
    "definition": "CREATE TYPE work.participant_function AS ENUM ('signatory', 'financial_manager', 'execution_manager', 'legal_representative', 'observer');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "participant_role",
    "definition": "CREATE TYPE work.participant_role AS ENUM ('client', 'prime_contractor', 'subcontractor', 'assignee', 'auditor', 'other');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "participant_status",
    "definition": "CREATE TYPE work.participant_status AS ENUM ('active', 'left', 'removed');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "participation_mode",
    "definition": "CREATE TYPE work.participation_mode AS ENUM ('direct', 'indirect', 'nominal');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "permission_type",
    "definition": "CREATE TYPE work.permission_type AS ENUM ('view', 'edit', 'approve', 'fund', 'release', 'manage');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "transfer_scope",
    "definition": "CREATE TYPE work.transfer_scope AS ENUM ('full', 'partial');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "transfer_type",
    "definition": "CREATE TYPE work.transfer_type AS ENUM ('full', 'partial', 'temporary', 'permanent');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "unit_type",
    "definition": "CREATE TYPE work.unit_type AS ENUM ('phase', 'deliverable', 'task', 'subtask', 'milestone');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "visibility_scope",
    "definition": "CREATE TYPE work.visibility_scope AS ENUM ('internal', 'external', 'client_only');"
  },
  {
    "object_type": "ENUM",
    "schema_name": "work",
    "object_name": "visibility_type",
    "definition": "CREATE TYPE work.visibility_type AS ENUM ('full', 'financial_only', 'timeline_only', 'restricted');"
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "extensions",
    "object_name": "pg_stat_statements",
    "definition": "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "extensions",
    "object_name": "pgcrypto",
    "definition": "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "pg_catalog",
    "object_name": "plpgsql",
    "definition": "CREATE EXTENSION IF NOT EXISTS plpgsql;"
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "vault",
    "object_name": "supabase_vault",
    "definition": "CREATE EXTENSION IF NOT EXISTS supabase_vault;"
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "extensions",
    "object_name": "uuid-ossp",
    "definition": "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "apply_ownership_transfer_to_permissions",
    "definition": "CREATE OR REPLACE FUNCTION work.apply_ownership_transfer_to_permissions(p_transfer_id uuid)\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_contract_id uuid;\r\n    v_from_entity_id uuid;\r\n    v_to_entity_id uuid;\r\n    v_transfer_scope work.transfer_scope;\r\n    v_percentage numeric;\r\n    v_old_owner_id uuid;\r\n    v_now timestamptz := now();\r\nBEGIN\r\n    SELECT contract_id, from_entity_id, to_entity_id, transfer_scope, percentage\r\n    INTO v_contract_id, v_from_entity_id, v_to_entity_id, v_transfer_scope, v_percentage\r\n    FROM work.work_ownership_transfers\r\n    WHERE id = p_transfer_id;\r\n    \r\n    IF NOT FOUND THEN RETURN; END IF;\r\n\r\n    -- الحصول على المالك الحالي قبل التغيير (للتسجيل)\r\n    SELECT owned_by_entity_id INTO v_old_owner_id\r\n    FROM work.contracts WHERE id = v_contract_id;\r\n\r\n    -- Full transfer\r\n    IF v_transfer_scope = 'full' THEN\r\n        -- تحديث الصلاحيات\r\n        INSERT INTO work.contract_permissions (contract_id, entity_id, permission, granted_by_entity_id)\r\n        VALUES (v_contract_id, v_to_entity_id, 'manage'::work.permission_type, v_from_entity_id)\r\n        ON CONFLICT (contract_id, entity_id, permission) DO NOTHING;\r\n        \r\n        DELETE FROM work.contract_permissions\r\n        WHERE contract_id = v_contract_id\r\n          AND entity_id = v_from_entity_id\r\n          AND permission = 'manage'::work.permission_type;\r\n        \r\n        -- تحديث عقد المالك\r\n        UPDATE work.contracts SET owned_by_entity_id = v_to_entity_id WHERE id = v_contract_id;\r\n\r\n        -- تسجيل نهاية فترة المالك القديم في جدول التاريخ\r\n        UPDATE work.contract_ownership_history\r\n        SET ended_at = v_now\r\n        WHERE contract_id = v_contract_id AND ended_at IS NULL;\r\n\r\n        -- إدخال فترة المالك الجديد\r\n        INSERT INTO work.contract_ownership_history (contract_id, owner_entity_id, transfer_id, started_at)\r\n        VALUES (v_contract_id, v_to_entity_id, p_transfer_id, v_now);\r\n    END IF;\r\n    \r\n    -- Partial transfer (only update allocation_percent – no full ownership change, but still log? optional)\r\n    -- هنا لا نغير المالك، لذا قد لا نضيف تاريخاً. إذا أردت تسجيل النقل الجزئي، يمكنك إضافة سجل منفصل.\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "auto_apply_ownership_transfer",
    "definition": "CREATE OR REPLACE FUNCTION work.auto_apply_ownership_transfer()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    IF NEW.apply_effects THEN\r\n        PERFORM work.apply_ownership_transfer_to_permissions(NEW.id);\r\n        INSERT INTO work.execution_logs (\r\n            contract_id, performed_by_entity_id, event_type,\r\n            target_entity_type, target_entity_id, old_state, new_state\r\n        ) VALUES (\r\n            NEW.contract_id, NEW.from_entity_id, 'transfer_ownership',\r\n            'contract', NEW.contract_id,\r\n            jsonb_build_object('owned_by', (SELECT owned_by_entity_id FROM work.contracts WHERE id = NEW.contract_id)),\r\n            jsonb_build_object('owned_by', NEW.to_entity_id)\r\n        );\r\n        UPDATE work.work_ownership_transfers\r\n        SET applied_at = now(), propagation_status = 'completed'\r\n        WHERE id = NEW.id;\r\n    END IF;\r\n    RETURN NEW;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "can_transition",
    "definition": "CREATE OR REPLACE FUNCTION work.can_transition(p_entity_type work.entity_type_enum, p_from_state text, p_to_state text, p_entity_id uuid DEFAULT NULL::uuid)\n RETURNS boolean\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nDECLARE\r\n    v_rule work.state_transition_rules%ROWTYPE;\r\n    v_condition jsonb;\r\n    v_entity_json jsonb;\r\n    v_field text;\r\n    v_operator text;\r\n    v_value jsonb;\r\n    v_actual_value text;\r\n    v_ok boolean := true;\r\nBEGIN\r\n    -- Get transition rule\r\n    SELECT * INTO v_rule\r\n    FROM work.state_transition_rules\r\n    WHERE entity_type = p_entity_type\r\n      AND from_state = p_from_state\r\n      AND to_state = p_to_state;\r\n    \r\n    IF NOT FOUND THEN\r\n        RETURN false;\r\n    END IF;\r\n    \r\n    -- No condition or no entity -> allowed\r\n    IF v_rule.condition IS NULL OR p_entity_id IS NULL THEN\r\n        RETURN true;\r\n    END IF;\r\n    \r\n    v_condition := v_rule.condition;\r\n    \r\n    -- Fetch the current entity as JSON (only if condition exists)\r\n    CASE p_entity_type\r\n        WHEN 'contract' THEN\r\n            SELECT row_to_json(c) INTO v_entity_json\r\n            FROM work.contracts c WHERE id = p_entity_id;\r\n        WHEN 'execution_unit' THEN\r\n            SELECT row_to_json(e) INTO v_entity_json\r\n            FROM work.work_execution_units e WHERE id = p_entity_id;\r\n        WHEN 'approval' THEN\r\n            SELECT row_to_json(a) INTO v_entity_json\r\n            FROM work.contract_approvals a WHERE id = p_entity_id;\r\n        ELSE\r\n            RAISE EXCEPTION 'Unknown entity_type: %', p_entity_type;\r\n    END CASE;\r\n    \r\n    IF v_entity_json IS NULL THEN\r\n        RETURN false;\r\n    END IF;\r\n    \r\n    -- Extract condition parts\r\n    v_field := v_condition->>'field';\r\n    v_operator := v_condition->>'operator';\r\n    v_value := v_condition->'value';\r\n    \r\n    IF v_field IS NULL OR v_operator IS NULL OR v_value IS NULL THEN\r\n        RAISE WARNING 'Invalid condition in rule %: %', v_rule.id, v_condition;\r\n        RETURN false;\r\n    END IF;\r\n    \r\n    -- Get actual value from entity JSON\r\n    v_actual_value := v_entity_json->>v_field;\r\n    IF v_actual_value IS NULL THEN\r\n        -- field does not exist in entity\r\n        RAISE WARNING 'Field % does not exist in entity %', v_field, p_entity_type;\r\n        RETURN false;\r\n    END IF;\r\n    \r\n    -- Evaluate condition based on operator (whitelist)\r\n    IF v_operator = '=' THEN\r\n        v_ok := (v_actual_value = v_value#>>'{}');\r\n    ELSIF v_operator = '!=' THEN\r\n        v_ok := (v_actual_value <> v_value#>>'{}');\r\n    ELSIF v_operator = '<' THEN\r\n        v_ok := (v_actual_value::numeric < v_value#>>'{}'::numeric);\r\n    ELSIF v_operator = '>' THEN\r\n        v_ok := (v_actual_value::numeric > v_value#>>'{}'::numeric);\r\n    ELSIF v_operator = '<=' THEN\r\n        v_ok := (v_actual_value::numeric <= v_value#>>'{}'::numeric);\r\n    ELSIF v_operator = '>=' THEN\r\n        v_ok := (v_actual_value::numeric >= v_value#>>'{}'::numeric);\r\n    ELSIF v_operator = 'LIKE' THEN\r\n        v_ok := (v_actual_value LIKE v_value#>>'{}');\r\n    ELSIF v_operator = 'IN' THEN\r\n        -- check if actual value is in the array\r\n        v_ok := EXISTS (\r\n            SELECT 1 FROM jsonb_array_elements_text(v_value) AS elem\r\n            WHERE elem = v_actual_value\r\n        );\r\n    ELSE\r\n        RAISE WARNING 'Unsupported operator: %', v_operator;\r\n        RETURN false;\r\n    END IF;\r\n    \r\n    RETURN v_ok;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "check_contract_permission",
    "definition": "CREATE OR REPLACE FUNCTION work.check_contract_permission(p_entity_id uuid, p_contract_id uuid, p_permission work.permission_type, p_resource_type text DEFAULT NULL::text, p_resource_id uuid DEFAULT NULL::uuid)\n RETURNS boolean\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nDECLARE\r\n    v_has_direct boolean;\r\n    v_direct_effect boolean;\r\n    v_matched_policies record;\r\n    v_matched_policy_ids uuid[] := '{}';\r\n    v_applied_policy_id uuid;\r\n    v_applied_priority int;\r\n    v_final_result boolean := false;\r\n    v_rule_type text := 'default_deny';\r\n    v_details jsonb := '{}'::jsonb;\r\n    v_row record;\r\n    v_role_list text[];\r\nBEGIN\r\n    -- 1. Direct RBAC permission? (if found, it overrides everything)\r\n    SELECT true INTO v_has_direct\r\n    FROM work.contract_permissions cp\r\n    WHERE cp.entity_id = p_entity_id\r\n      AND cp.contract_id = p_contract_id\r\n      AND cp.permission = p_permission;\r\n    \r\n    IF v_has_direct THEN\r\n        v_final_result := true;\r\n        v_rule_type := 'direct_permission';\r\n        v_details := jsonb_build_object('direct_match', true);\r\n        PERFORM work.log_permission_evaluation(\r\n            p_entity_id, p_contract_id, p_permission, v_final_result,\r\n            ARRAY[]::uuid[], v_rule_type, NULL, NULL, v_details\r\n        );\r\n        RETURN true;\r\n    END IF;\r\n\r\n    -- 2. Get roles of the entity in this contract (for ABAC policies)\r\n    SELECT array_agg(DISTINCT role::text) INTO v_role_list\r\n    FROM work.contract_participants\r\n    WHERE contract_id = p_contract_id AND entity_id = p_entity_id;\r\n    \r\n    v_details := jsonb_build_object('roles', COALESCE(v_role_list, '{}'));\r\n\r\n    -- 3. Evaluate ABAC policies ordered by priority\r\n    FOR v_row IN\r\n        SELECT pp.id, pp.priority, pp.effect\r\n        FROM work.permission_policies pp\r\n        JOIN work.policy_assignments pa ON pa.policy_id = pp.id\r\n        WHERE pp.enabled = true\r\n          AND pp.permission_type = p_permission\r\n          AND (\r\n              pa.entity_id = p_entity_id \r\n              OR (pa.role IS NOT NULL AND pa.role::text = ANY(v_role_list))\r\n          )\r\n        ORDER BY pp.priority DESC\r\n    LOOP\r\n        v_matched_policy_ids := array_append(v_matched_policy_ids, v_row.id);\r\n        v_details := jsonb_set(v_details, '{policies}', \r\n            COALESCE(v_details->'policies', '[]'::jsonb) || \r\n            jsonb_build_object('id', v_row.id, 'priority', v_row.priority, 'effect', v_row.effect)\r\n        );\r\n        \r\n        IF v_row.effect = 'deny' THEN\r\n            v_final_result := false;\r\n            v_rule_type := 'policy_deny';\r\n            v_applied_policy_id := v_row.id;\r\n            v_applied_priority := v_row.priority;\r\n            EXIT;  -- deny immediately\r\n        ELSIF v_row.effect = 'allow' THEN\r\n            v_final_result := true;\r\n            v_rule_type := 'policy_allow';\r\n            v_applied_policy_id := v_row.id;\r\n            v_applied_priority := v_row.priority;\r\n            -- continue to check if there is any deny with higher priority? already ordered by priority, so first match (highest priority) wins.\r\n            EXIT;\r\n        END IF;\r\n    END LOOP;\r\n\r\n    -- If no policy matched, default deny (already false)\r\n    IF v_rule_type = 'default_deny' AND array_length(v_matched_policy_ids, 1) IS NULL THEN\r\n        v_details := jsonb_set(v_details, '{no_policy_matched}', 'true');\r\n    END IF;\r\n\r\n    -- Log evaluation (only if logging is enabled)\r\n    PERFORM work.log_permission_evaluation(\r\n        p_entity_id, p_contract_id, p_permission, v_final_result,\r\n        v_matched_policy_ids, v_rule_type, v_applied_policy_id, v_applied_priority, v_details\r\n    );\r\n    \r\n    RETURN v_final_result;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "check_contract_permission_simple",
    "definition": "CREATE OR REPLACE FUNCTION work.check_contract_permission_simple(p_entity_id uuid, p_contract_id uuid, p_permission work.permission_type)\n RETURNS boolean\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nBEGIN\r\n    RETURN work.check_contract_permission(p_entity_id, p_contract_id, p_permission, NULL, NULL);\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "claim_next_event",
    "definition": "CREATE OR REPLACE FUNCTION work.claim_next_event(p_service_name text, p_limit integer DEFAULT 1)\n RETURNS SETOF work.event_outbox\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_now timestamptz := now();\r\n    v_lock_timeout interval := interval '5 minutes';\r\n    v_row work.event_outbox%ROWTYPE;\r\nBEGIN\r\n    FOR v_row IN\r\n        SELECT * FROM work.event_outbox\r\n        WHERE status = 'pending'\r\n          AND (locked_until IS NULL OR locked_until < v_now)\r\n        ORDER BY created_at\r\n        LIMIT p_limit\r\n        FOR UPDATE SKIP LOCKED\r\n    LOOP\r\n        UPDATE work.event_outbox\r\n        SET locked_until = v_now + v_lock_timeout,\r\n            processed_by = p_service_name,\r\n            status = 'processing'\r\n        WHERE id = v_row.id;\r\n        \r\n        RETURN NEXT v_row;\r\n    END LOOP;\r\n    RETURN;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "complete_event",
    "definition": "CREATE OR REPLACE FUNCTION work.complete_event(p_idempotency_key uuid, p_service_name text, p_result text DEFAULT 'success'::text)\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_event work.event_outbox%ROWTYPE;\r\nBEGIN\r\n    SELECT * INTO v_event FROM work.event_outbox WHERE idempotency_key = p_idempotency_key;\r\n    IF NOT FOUND THEN\r\n        RAISE EXCEPTION 'Event with idempotency_key % not found', p_idempotency_key;\r\n    END IF;\r\n\r\n    INSERT INTO work.event_outbox_processed (idempotency_key, event_type, entity_type, entity_id, service_name, result, processed_at)\r\n    VALUES (v_event.idempotency_key, v_event.event_type, v_event.entity_type, v_event.entity_id, p_service_name, p_result, now())\r\n    ON CONFLICT (idempotency_key) DO UPDATE\r\n    SET service_name = EXCLUDED.service_name, result = EXCLUDED.result, processed_at = EXCLUDED.processed_at;\r\n\r\n    UPDATE work.event_outbox\r\n    SET status = 'completed', processed_at = now(), retry_count = retry_count + 1\r\n    WHERE idempotency_key = p_idempotency_key;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "contract_ownership_history_init",
    "definition": "CREATE OR REPLACE FUNCTION work.contract_ownership_history_init()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    INSERT INTO work.contract_ownership_history (contract_id, owner_entity_id, started_at)\r\n    VALUES (NEW.id, NEW.owned_by_entity_id, NEW.created_at)\r\n    ON CONFLICT DO NOTHING;\r\n    RETURN NEW;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "contract_state_transition_trigger",
    "definition": "CREATE OR REPLACE FUNCTION work.contract_state_transition_trigger()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    IF OLD.status IS DISTINCT FROM NEW.status THEN\r\n        IF NOT work.can_transition('contract'::work.entity_type_enum, OLD.status::text, NEW.status::text, NEW.id) THEN\r\n            RAISE EXCEPTION 'Invalid state transition from % to % for contract %', OLD.status, NEW.status, NEW.id;\r\n        END IF;\r\n        INSERT INTO work.state_transition_history (entity_type, entity_id, from_state, to_state, triggered_by_entity_id, created_at)\r\n        VALUES ('contract', NEW.id, OLD.status::text, NEW.status::text, current_setting('app.current_entity_id', true)::uuid, now());\r\n    END IF;\r\n    RETURN NEW;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "contracts_search_vector_update",
    "definition": "CREATE OR REPLACE FUNCTION work.contracts_search_vector_update()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    NEW.search_vector :=\r\n        setweight(to_tsvector('simple', COALESCE(NEW.title, '')), 'A') ||\r\n        setweight(to_tsvector('simple', COALESCE(NEW.description, '')), 'B') ||\r\n        setweight(to_tsvector('simple', COALESCE(NEW.asset_code, '')), 'C');\r\n    RETURN NEW;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "disable_permission_logging",
    "definition": "CREATE OR REPLACE FUNCTION work.disable_permission_logging()\n RETURNS text\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    PERFORM set_config('work.log_permissions', 'off', false);\r\n    RETURN 'Permission logging disabled.';\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "enable_permission_logging",
    "definition": "CREATE OR REPLACE FUNCTION work.enable_permission_logging()\n RETURNS text\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    PERFORM set_config('work.log_permissions', 'on', false);\r\n    RETURN 'Permission logging enabled for this session.';\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "fail_event",
    "definition": "CREATE OR REPLACE FUNCTION work.fail_event(p_idempotency_key uuid, p_error text)\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    UPDATE work.event_outbox\r\n    SET status = 'pending',\r\n        last_error = p_error,\r\n        retry_count = retry_count + 1,\r\n        locked_until = NULL,\r\n        processed_by = NULL\r\n    WHERE idempotency_key = p_idempotency_key;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "log_permission_evaluation",
    "definition": "CREATE OR REPLACE FUNCTION work.log_permission_evaluation(p_entity_id uuid, p_contract_id uuid, p_permission work.permission_type, p_result boolean, p_matched_policy_ids uuid[], p_matched_rule_type text, p_applied_policy_id uuid, p_priority_applied integer, p_details jsonb)\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    -- فقط إذا كان متغير الجلسة 'work.log_permissions' = 'on'\r\n    IF current_setting('work.log_permissions', true) = 'on' THEN\r\n        INSERT INTO work.permission_evaluation_log (\r\n            entity_id, contract_id, permission, result,\r\n            matched_policy_ids, matched_rule_type, applied_policy_id,\r\n            priority_applied, evaluation_details, triggered_by_setting\r\n        ) VALUES (\r\n            p_entity_id, p_contract_id, p_permission, p_result,\r\n            p_matched_policy_ids, p_matched_rule_type, p_applied_policy_id,\r\n            p_priority_applied, p_details, 'on'\r\n        );\r\n    END IF;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "notify_dispute_event",
    "definition": "CREATE OR REPLACE FUNCTION work.notify_dispute_event()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    INSERT INTO work.event_outbox (\r\n        idempotency_key, event_type, entity_type, entity_id, payload, status\r\n    ) VALUES (\r\n        gen_random_uuid(),\r\n        CASE TG_OP\r\n            WHEN 'INSERT' THEN 'dispute.created'\r\n            WHEN 'UPDATE' THEN 'dispute.updated'\r\n        END,\r\n        'dispute',\r\n        NEW.id,\r\n        jsonb_build_object(\r\n            'dispute_id', NEW.id,\r\n            'contract_id', NEW.contract_id,\r\n            'status', NEW.status,\r\n            'dispute_type', NEW.dispute_type,\r\n            'raised_by', NEW.raised_by_entity_id,\r\n            'against', NEW.against_entity_id\r\n        ),\r\n        'pending'\r\n    );\r\n    RETURN NEW;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "propagate_ownership_transfer_event",
    "definition": "CREATE OR REPLACE FUNCTION work.propagate_ownership_transfer_event()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    IF (TG_OP = 'INSERT' AND NEW.apply_effects = true) OR\r\n       (TG_OP = 'UPDATE' AND NEW.applied_at IS DISTINCT FROM OLD.applied_at AND NEW.applied_at IS NOT NULL) THEN\r\n       \r\n       INSERT INTO work.event_outbox (\r\n           idempotency_key, event_type, entity_type, entity_id, payload, status\r\n       ) VALUES (\r\n           gen_random_uuid(),\r\n           'ownership.transferred',\r\n           'contract',\r\n           NEW.contract_id,\r\n           jsonb_build_object(\r\n               'transfer_id', NEW.id,\r\n               'from_entity_id', NEW.from_entity_id,\r\n               'to_entity_id', NEW.to_entity_id,\r\n               'transfer_scope', NEW.transfer_scope,\r\n               'percentage', NEW.percentage,\r\n               'effective_at', NEW.effective_at\r\n           ),\r\n           'pending'\r\n       );\r\n    END IF;\r\n    RETURN NEW;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "transition_entity_state",
    "definition": "CREATE OR REPLACE FUNCTION work.transition_entity_state(p_entity_type work.entity_type_enum, p_entity_id uuid, p_new_state text, p_triggered_by_entity_id uuid DEFAULT NULL::uuid, p_metadata jsonb DEFAULT NULL::jsonb)\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_old_state text;\r\n    v_table_name text;\r\nBEGIN\r\n    CASE p_entity_type\r\n        WHEN 'contract' THEN\r\n            v_table_name := 'contracts';\r\n            SELECT status::text INTO v_old_state FROM work.contracts WHERE id = p_entity_id;\r\n        WHEN 'execution_unit' THEN\r\n            v_table_name := 'work_execution_units';\r\n            SELECT status::text INTO v_old_state FROM work.work_execution_units WHERE id = p_entity_id;\r\n        WHEN 'approval' THEN\r\n            v_table_name := 'contract_approvals';\r\n            SELECT status::text INTO v_old_state FROM work.contract_approvals WHERE id = p_entity_id;\r\n        ELSE\r\n            RETURN false;\r\n    END CASE;\r\n    \r\n    IF NOT FOUND THEN\r\n        RETURN false;\r\n    END IF;\r\n    \r\n    IF NOT work.can_transition(p_entity_type, v_old_state, p_new_state, p_entity_id) THEN\r\n        RETURN false;\r\n    END IF;\r\n    \r\n    EXECUTE format('UPDATE work.%I SET status = $1, updated_at = now() WHERE id = $2', v_table_name)\r\n    USING p_new_state, p_entity_id;\r\n    \r\n    INSERT INTO work.state_transition_history (\r\n        entity_type, entity_id, from_state, to_state, triggered_by_entity_id, metadata, created_at\r\n    ) VALUES (\r\n        p_entity_type, p_entity_id, v_old_state, p_new_state, p_triggered_by_entity_id, p_metadata, now()\r\n    );\r\n    \r\n    INSERT INTO work.event_outbox (\r\n        idempotency_key, event_type, entity_type, entity_id, payload, status\r\n    ) VALUES (\r\n        gen_random_uuid(),\r\n        'state.changed',\r\n        p_entity_type::text,\r\n        p_entity_id,\r\n        jsonb_build_object('old_state', v_old_state, 'new_state', p_new_state, 'triggered_by', p_triggered_by_entity_id),\r\n        'pending'\r\n    );\r\n    \r\n    RETURN true;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "update_contract_dispute_flag",
    "definition": "CREATE OR REPLACE FUNCTION work.update_contract_dispute_flag()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    UPDATE work.contracts\r\n    SET has_open_dispute = EXISTS (\r\n        SELECT 1 FROM work.dispute_cases\r\n        WHERE contract_id = NEW.contract_id\r\n          AND status NOT IN ('resolved', 'rejected')\r\n    )\r\n    WHERE id = NEW.contract_id;\r\n    RETURN NEW;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "FUNCTION",
    "schema_name": "work",
    "object_name": "update_updated_at_column",
    "definition": "CREATE OR REPLACE FUNCTION work.update_updated_at_column()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    NEW.updated_at = now();\r\n    RETURN NEW;\r\nEND;\r\n$function$\n"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "approval_step_assignees_pkey",
    "definition": "CREATE UNIQUE INDEX approval_step_assignees_pkey ON work.approval_step_assignees USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "approval_workflow_steps_pkey",
    "definition": "CREATE UNIQUE INDEX approval_workflow_steps_pkey ON work.approval_workflow_steps USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "approval_workflow_templates_pkey",
    "definition": "CREATE UNIQUE INDEX approval_workflow_templates_pkey ON work.approval_workflow_templates USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "contract_approval_workflows_pkey",
    "definition": "CREATE UNIQUE INDEX contract_approval_workflows_pkey ON work.contract_approval_workflows USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "contract_approvals_pkey",
    "definition": "CREATE UNIQUE INDEX contract_approvals_pkey ON work.contract_approvals USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "contract_links_pkey",
    "definition": "CREATE UNIQUE INDEX contract_links_pkey ON work.contract_links USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "contract_messages_pkey",
    "definition": "CREATE UNIQUE INDEX contract_messages_pkey ON work.contract_messages USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "contract_ownership_history_pkey",
    "definition": "CREATE UNIQUE INDEX contract_ownership_history_pkey ON work.contract_ownership_history USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "contract_participants_pkey",
    "definition": "CREATE UNIQUE INDEX contract_participants_pkey ON work.contract_participants USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "contract_permissions_pkey",
    "definition": "CREATE UNIQUE INDEX contract_permissions_pkey ON work.contract_permissions USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "contracts_pkey",
    "definition": "CREATE UNIQUE INDEX contracts_pkey ON work.contracts USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "dispute_cases_pkey",
    "definition": "CREATE UNIQUE INDEX dispute_cases_pkey ON work.dispute_cases USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "dispute_evidence_pkey",
    "definition": "CREATE UNIQUE INDEX dispute_evidence_pkey ON work.dispute_evidence USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "dispute_hearings_pkey",
    "definition": "CREATE UNIQUE INDEX dispute_hearings_pkey ON work.dispute_hearings USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "dispute_resolution_actions_pkey",
    "definition": "CREATE UNIQUE INDEX dispute_resolution_actions_pkey ON work.dispute_resolution_actions USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "event_outbox_idempotency_key_unique",
    "definition": "CREATE UNIQUE INDEX event_outbox_idempotency_key_unique ON work.event_outbox USING btree (idempotency_key);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "event_outbox_pkey",
    "definition": "CREATE UNIQUE INDEX event_outbox_pkey ON work.event_outbox USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "event_outbox_processed_pkey",
    "definition": "CREATE UNIQUE INDEX event_outbox_processed_pkey ON work.event_outbox_processed USING btree (idempotency_key);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "execution_logs_pkey",
    "definition": "CREATE UNIQUE INDEX execution_logs_pkey ON work.execution_logs USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_approvals_snapshot",
    "definition": "CREATE INDEX idx_contract_approvals_snapshot ON work.contract_approvals USING gin (approval_snapshot);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_approvals_status",
    "definition": "CREATE INDEX idx_contract_approvals_status ON work.contract_approvals USING btree (status);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_approvals_workflow",
    "definition": "CREATE INDEX idx_contract_approvals_workflow ON work.contract_approvals USING btree (workflow_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_participants_entity",
    "definition": "CREATE INDEX idx_contract_participants_entity ON work.contract_participants USING btree (entity_id, contract_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_participants_lookup",
    "definition": "CREATE INDEX idx_contract_participants_lookup ON work.contract_participants USING btree (contract_id, entity_id, status) WHERE (status = 'active'::work.participant_status);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_participants_role",
    "definition": "CREATE INDEX idx_contract_participants_role ON work.contract_participants USING btree (contract_id, role);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_permissions_entity",
    "definition": "CREATE INDEX idx_contract_permissions_entity ON work.contract_permissions USING btree (contract_id, entity_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_permissions_lookup",
    "definition": "CREATE INDEX idx_contract_permissions_lookup ON work.contract_permissions USING btree (contract_id, entity_id, permission);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_permissions_permission",
    "definition": "CREATE INDEX idx_contract_permissions_permission ON work.contract_permissions USING btree (permission);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_workflows_contract",
    "definition": "CREATE INDEX idx_contract_workflows_contract ON work.contract_approval_workflows USING btree (contract_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contract_workflows_status",
    "definition": "CREATE INDEX idx_contract_workflows_status ON work.contract_approval_workflows USING btree (status);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contracts_created_at",
    "definition": "CREATE INDEX idx_contracts_created_at ON work.contracts USING btree (created_at DESC);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contracts_owned_status",
    "definition": "CREATE INDEX idx_contracts_owned_status ON work.contracts USING btree (owned_by_entity_id, status) WHERE (status = ANY (ARRAY['active'::work.contract_status, 'paused'::work.contract_status]));"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contracts_project_task",
    "definition": "CREATE INDEX idx_contracts_project_task ON work.contracts USING btree (project_id, task_id) WHERE (project_id IS NOT NULL);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contracts_search_vector",
    "definition": "CREATE INDEX idx_contracts_search_vector ON work.contracts USING gin (search_vector);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_contracts_status",
    "definition": "CREATE INDEX idx_contracts_status ON work.contracts USING btree (status);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_dispute_against",
    "definition": "CREATE INDEX idx_dispute_against ON work.dispute_cases USING btree (against_entity_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_dispute_contract",
    "definition": "CREATE INDEX idx_dispute_contract ON work.dispute_cases USING btree (contract_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_dispute_raised_by",
    "definition": "CREATE INDEX idx_dispute_raised_by ON work.dispute_cases USING btree (raised_by_entity_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_dispute_status",
    "definition": "CREATE INDEX idx_dispute_status ON work.dispute_cases USING btree (status);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_event_outbox_entity",
    "definition": "CREATE INDEX idx_event_outbox_entity ON work.event_outbox USING btree (entity_type, entity_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_event_outbox_idempotency",
    "definition": "CREATE INDEX idx_event_outbox_idempotency ON work.event_outbox USING btree (idempotency_key);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_event_outbox_pending",
    "definition": "CREATE INDEX idx_event_outbox_pending ON work.event_outbox USING btree (status, created_at) WHERE (status = 'pending'::text);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_event_outbox_status_locked",
    "definition": "CREATE INDEX idx_event_outbox_status_locked ON work.event_outbox USING btree (status, locked_until) WHERE ((status = 'pending'::text) OR (status = 'processing'::text));"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_evidence_dispute",
    "definition": "CREATE INDEX idx_evidence_dispute ON work.dispute_evidence USING btree (dispute_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_execution_logs_contract",
    "definition": "CREATE INDEX idx_execution_logs_contract ON work.execution_logs USING btree (contract_id, created_at);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_execution_units_milestone",
    "definition": "CREATE INDEX idx_execution_units_milestone ON work.work_execution_units USING btree (contract_id, is_milestone) WHERE (is_milestone = true);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_execution_units_milestone_amount",
    "definition": "CREATE INDEX idx_execution_units_milestone_amount ON work.work_execution_units USING btree (milestone_amount) WHERE (is_milestone = true);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_hearings_dispute",
    "definition": "CREATE INDEX idx_hearings_dispute ON work.dispute_hearings USING btree (dispute_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_one_active_full_transfer",
    "definition": "CREATE UNIQUE INDEX idx_one_active_full_transfer ON work.work_ownership_transfers USING btree (contract_id) WHERE ((transfer_scope = 'full'::work.transfer_scope) AND (transfer_type = 'permanent'::work.transfer_type));"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_outbox_processed_lookup",
    "definition": "CREATE INDEX idx_outbox_processed_lookup ON work.event_outbox_processed USING btree (idempotency_key, service_name);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_ownership_history_contract",
    "definition": "CREATE INDEX idx_ownership_history_contract ON work.contract_ownership_history USING btree (contract_id, started_at DESC);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_ownership_history_owner",
    "definition": "CREATE INDEX idx_ownership_history_owner ON work.contract_ownership_history USING btree (owner_entity_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_permission_log_contract",
    "definition": "CREATE INDEX idx_permission_log_contract ON work.permission_evaluation_log USING btree (contract_id, evaluated_at);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_permission_log_entity",
    "definition": "CREATE INDEX idx_permission_log_entity ON work.permission_evaluation_log USING btree (entity_id, evaluated_at);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_permission_log_result",
    "definition": "CREATE INDEX idx_permission_log_result ON work.permission_evaluation_log USING btree (result);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_policy_assignments_role",
    "definition": "CREATE INDEX idx_policy_assignments_role ON work.policy_assignments USING btree (role) WHERE (role IS NOT NULL);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_resolution_actions_dispute",
    "definition": "CREATE INDEX idx_resolution_actions_dispute ON work.dispute_resolution_actions USING btree (dispute_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_state_history_entity",
    "definition": "CREATE INDEX idx_state_history_entity ON work.state_transition_history USING btree (entity_type, entity_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_state_transition_rules_lookup",
    "definition": "CREATE INDEX idx_state_transition_rules_lookup ON work.state_transition_rules USING btree (entity_type, from_state, to_state) INCLUDE (condition, action, priority);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_step_assignees_step_id",
    "definition": "CREATE INDEX idx_step_assignees_step_id ON work.approval_step_assignees USING btree (workflow_step_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_work_financial_routes_payee",
    "definition": "CREATE INDEX idx_work_financial_routes_payee ON work.work_financial_routes USING btree (contract_id, payee_entity_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_work_financial_routes_payer",
    "definition": "CREATE INDEX idx_work_financial_routes_payer ON work.work_financial_routes USING btree (contract_id, payer_entity_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_work_ownership_transfers_type",
    "definition": "CREATE INDEX idx_work_ownership_transfers_type ON work.work_ownership_transfers USING btree (transfer_type);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_work_visibility_type",
    "definition": "CREATE INDEX idx_work_visibility_type ON work.work_visibility USING btree (visibility_type);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_workflow_steps_template_id",
    "definition": "CREATE INDEX idx_workflow_steps_template_id ON work.approval_workflow_steps USING btree (workflow_template_id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "idx_workflow_templates_target_type",
    "definition": "CREATE INDEX idx_workflow_templates_target_type ON work.approval_workflow_templates USING btree (target_type);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "permission_evaluation_log_pkey",
    "definition": "CREATE UNIQUE INDEX permission_evaluation_log_pkey ON work.permission_evaluation_log USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "permission_policies_pkey",
    "definition": "CREATE UNIQUE INDEX permission_policies_pkey ON work.permission_policies USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "policy_assignments_pkey",
    "definition": "CREATE UNIQUE INDEX policy_assignments_pkey ON work.policy_assignments USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "policy_conditions_pkey",
    "definition": "CREATE UNIQUE INDEX policy_conditions_pkey ON work.policy_conditions USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "state_machines_entity_type_key",
    "definition": "CREATE UNIQUE INDEX state_machines_entity_type_key ON work.state_machines USING btree (entity_type);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "state_machines_pkey",
    "definition": "CREATE UNIQUE INDEX state_machines_pkey ON work.state_machines USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "state_transition_history_pkey",
    "definition": "CREATE UNIQUE INDEX state_transition_history_pkey ON work.state_transition_history USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "state_transition_rules_entity_type_from_state_to_state_key",
    "definition": "CREATE UNIQUE INDEX state_transition_rules_entity_type_from_state_to_state_key ON work.state_transition_rules USING btree (entity_type, from_state, to_state);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "state_transition_rules_pkey",
    "definition": "CREATE UNIQUE INDEX state_transition_rules_pkey ON work.state_transition_rules USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_contract_participant_role",
    "definition": "CREATE UNIQUE INDEX uq_contract_participant_role ON work.contract_participants USING btree (contract_id, entity_id, role);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_contract_permission",
    "definition": "CREATE UNIQUE INDEX uq_contract_permission ON work.contract_permissions USING btree (contract_id, entity_id, permission);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_contract_version",
    "definition": "CREATE UNIQUE INDEX uq_contract_version ON work.work_contract_versions USING btree (contract_id, version_no);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_execution_log_event",
    "definition": "CREATE UNIQUE INDEX uq_execution_log_event ON work.execution_logs USING btree (contract_id, event_type, target_entity_id, target_entity_type);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_execution_log_idempotent",
    "definition": "CREATE UNIQUE INDEX uq_execution_log_idempotent ON work.execution_logs USING btree (idempotency_key);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_execution_unit_sequence",
    "definition": "CREATE UNIQUE INDEX uq_execution_unit_sequence ON work.work_execution_units USING btree (contract_id, sequence_no);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_execution_unit_title_per_contract",
    "definition": "CREATE UNIQUE INDEX uq_execution_unit_title_per_contract ON work.work_execution_units USING btree (contract_id, title);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_financial_route",
    "definition": "CREATE UNIQUE INDEX uq_financial_route ON work.work_financial_routes USING btree (contract_id, payer_entity_id, payee_entity_id, beneficiary_type);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "uq_visibility_rule",
    "definition": "CREATE UNIQUE INDEX uq_visibility_rule ON work.work_visibility USING btree (contract_id, viewer_entity_id, visible_entity_id, visibility_type);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "work_contract_versions_pkey",
    "definition": "CREATE UNIQUE INDEX work_contract_versions_pkey ON work.work_contract_versions USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "work_execution_units_pkey",
    "definition": "CREATE UNIQUE INDEX work_execution_units_pkey ON work.work_execution_units USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "work_financial_routes_pkey",
    "definition": "CREATE UNIQUE INDEX work_financial_routes_pkey ON work.work_financial_routes USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "work_ownership_transfers_pkey",
    "definition": "CREATE UNIQUE INDEX work_ownership_transfers_pkey ON work.work_ownership_transfers USING btree (id);"
  },
  {
    "object_type": "INDEX",
    "schema_name": "work",
    "object_name": "work_visibility_pkey",
    "definition": "CREATE UNIQUE INDEX work_visibility_pkey ON work.work_visibility USING btree (id);"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "approval_step_assignees",
    "definition": "ALTER TABLE work.approval_step_assignees ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "approval_workflow_steps",
    "definition": "ALTER TABLE work.approval_workflow_steps ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "approval_workflow_templates",
    "definition": "ALTER TABLE work.approval_workflow_templates ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "contract_approval_workflows",
    "definition": "ALTER TABLE work.contract_approval_workflows ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "contract_approvals",
    "definition": "ALTER TABLE work.contract_approvals ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "contract_links",
    "definition": "ALTER TABLE work.contract_links ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "contract_messages",
    "definition": "ALTER TABLE work.contract_messages ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "contract_ownership_history",
    "definition": "ALTER TABLE work.contract_ownership_history ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "contract_participants",
    "definition": "ALTER TABLE work.contract_participants ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "contract_permissions",
    "definition": "ALTER TABLE work.contract_permissions ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "contracts",
    "definition": "ALTER TABLE work.contracts ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "dispute_cases",
    "definition": "ALTER TABLE work.dispute_cases ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "dispute_evidence",
    "definition": "ALTER TABLE work.dispute_evidence ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "dispute_hearings",
    "definition": "ALTER TABLE work.dispute_hearings ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "dispute_resolution_actions",
    "definition": "ALTER TABLE work.dispute_resolution_actions ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "event_outbox",
    "definition": "ALTER TABLE work.event_outbox ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "event_outbox_processed",
    "definition": "ALTER TABLE work.event_outbox_processed ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "execution_logs",
    "definition": "ALTER TABLE work.execution_logs ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "permission_evaluation_log",
    "definition": "ALTER TABLE work.permission_evaluation_log ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "permission_policies",
    "definition": "ALTER TABLE work.permission_policies ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "policy_assignments",
    "definition": "ALTER TABLE work.policy_assignments ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "policy_conditions",
    "definition": "ALTER TABLE work.policy_conditions ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "state_machines",
    "definition": "ALTER TABLE work.state_machines ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "state_transition_history",
    "definition": "ALTER TABLE work.state_transition_history ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "state_transition_rules",
    "definition": "ALTER TABLE work.state_transition_rules ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "work_contract_versions",
    "definition": "ALTER TABLE work.work_contract_versions ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "work_execution_units",
    "definition": "ALTER TABLE work.work_execution_units ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "work_financial_routes",
    "definition": "ALTER TABLE work.work_financial_routes ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "work_ownership_transfers",
    "definition": "ALTER TABLE work.work_ownership_transfers ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "RLS",
    "schema_name": "work",
    "object_name": "work_visibility",
    "definition": "ALTER TABLE work.work_visibility ENABLE ROW LEVEL SECURITY;"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "approval_step_assignees",
    "definition": "id uuid,\nworkflow_step_id uuid,\nentity_id uuid,\nrole_in_step text,\nweight integer,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "approval_workflow_steps",
    "definition": "id uuid,\nworkflow_template_id uuid,\nstep_order integer,\nname text,\ndescription text,\nstep_type text,\ncondition jsonb,\nquorum_count integer,\ncompletion_policy text,\ntimeout_hours integer,\nis_mandatory boolean,\nmetadata jsonb,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "approval_workflow_templates",
    "definition": "id uuid,\nname text,\ndescription text,\ntarget_type text,\napplicable_approval_types ARRAY,\nis_default boolean,\nmetadata jsonb,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "contract_approval_workflows",
    "definition": "id uuid,\ncontract_id uuid,\nworkflow_template_id uuid,\nstatus text,\ncurrent_step_index integer,\nstarted_at timestamp with time zone,\ncompleted_at timestamp with time zone,\nmetadata jsonb"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "contract_approvals",
    "definition": "id uuid,\ncontract_id uuid,\nrequested_by_entity_id uuid,\nrequested_from_entity_id uuid,\napproval_type USER-DEFINED,\nstatus USER-DEFINED,\napproved_at timestamp with time zone,\nrejected_at timestamp with time zone,\nmetadata jsonb,\ncreated_at timestamp with time zone,\nupdated_at timestamp with time zone,\nworkflow_id uuid,\nworkflow_step_id uuid,\nstep_order integer,\napproval_snapshot jsonb,\nstep_name text,\nstep_order_snapshot integer"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "contract_links",
    "definition": "id uuid,\nparent_contract_id uuid,\nchild_contract_id uuid,\nlink_type USER-DEFINED,\nmetadata jsonb,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "contract_messages",
    "definition": "id uuid,\ncontract_id uuid,\nsender_entity_id uuid,\nmessage_type USER-DEFINED,\nbody text,\nmetadata jsonb,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "contract_ownership_history",
    "definition": "id uuid,\ncontract_id uuid,\nowner_entity_id uuid,\ntransfer_id uuid,\nstarted_at timestamp with time zone,\nended_at timestamp with time zone,\ncreated_at timestamp with time zone,\nupdated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "contract_participants",
    "definition": "id uuid,\ncontract_id uuid,\nentity_id uuid,\nrole USER-DEFINED,\nparticipation_mode USER-DEFINED,\nvisibility_scope USER-DEFINED,\nfinancial_role USER-DEFINED,\nexecution_role USER-DEFINED,\nparent_participant_id uuid,\nallocation_percent numeric,\nstatus USER-DEFINED,\njoined_at timestamp with time zone,\nleft_at timestamp with time zone,\nmetadata jsonb,\ncreated_at timestamp with time zone,\nupdated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "contract_permissions",
    "definition": "id uuid,\ncontract_id uuid,\nentity_id uuid,\npermission USER-DEFINED,\ngranted_by_entity_id uuid,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "contracts",
    "definition": "id uuid,\nproject_id uuid,\ntask_id uuid,\ntitle text,\ndescription text,\nstatus USER-DEFINED,\nasset_code text,\ntotal_amount numeric,\ncurrent_version_no integer,\ncreated_by_entity_id uuid,\nowned_by_entity_id uuid,\nvisibility_mode USER-DEFINED,\nstarted_at timestamp with time zone,\ncompleted_at timestamp with time zone,\ncancelled_at timestamp with time zone,\nmetadata jsonb,\ncreated_at timestamp with time zone,\nupdated_at timestamp with time zone,\nsearch_vector tsvector,\nhas_open_dispute boolean"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "dispute_cases",
    "definition": "id uuid,\ncontract_id uuid,\nexecution_unit_id uuid,\napproval_id uuid,\ndispute_type USER-DEFINED,\nstatus USER-DEFINED,\nraised_by_entity_id uuid,\nagainst_entity_id uuid,\nraised_at timestamp with time zone,\ntitle text,\ndescription text,\nclaimed_amount numeric,\nrequested_action text,\nresolved_at timestamp with time zone,\nresolution_summary text,\nresolved_by_entity_id uuid,\nmetadata jsonb,\ncreated_at timestamp with time zone,\nupdated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "dispute_evidence",
    "definition": "id uuid,\ndispute_id uuid,\nsubmitted_by_entity_id uuid,\nevidence_type text,\ntitle text,\ndescription text,\nfile_url text,\ncontent_hash text,\nmetadata jsonb,\nsubmitted_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "dispute_hearings",
    "definition": "id uuid,\ndispute_id uuid,\nhearing_date timestamp with time zone,\nlocation text,\nis_online boolean,\nmeeting_link text,\ndecision text,\nnotes text,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "dispute_resolution_actions",
    "definition": "id uuid,\ndispute_id uuid,\naction_type text,\ndescription text,\napplied boolean,\napplied_at timestamp with time zone,\nmetadata jsonb"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "event_outbox",
    "definition": "id uuid,\nevent_type text,\nentity_type text,\nentity_id uuid,\npayload jsonb,\nstatus text,\nretry_count integer,\nlast_error text,\ncreated_at timestamp with time zone,\nprocessed_at timestamp with time zone,\nrouting_key text,\ntarget_services ARRAY,\nidempotency_key uuid,\nevent_version integer,\nprocessed_by text,\nlocked_until timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "event_outbox_processed",
    "definition": "idempotency_key uuid,\nevent_type text,\nentity_type text,\nentity_id uuid,\nservice_name text,\nprocessed_at timestamp with time zone,\nresult text,\nmetadata jsonb"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "execution_logs",
    "definition": "id uuid,\ncontract_id uuid,\nperformed_by_entity_id uuid,\nevent_type USER-DEFINED,\ncreated_at timestamp with time zone,\ntarget_entity_type text,\ntarget_entity_id uuid,\nold_state jsonb,\nnew_state jsonb,\nidempotency_key uuid"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "permission_evaluation_log",
    "definition": "id uuid,\nentity_id uuid,\ncontract_id uuid,\npermission USER-DEFINED,\nevaluated_at timestamp with time zone,\nresult boolean,\nmatched_policy_ids ARRAY,\nmatched_rule_type text,\napplied_policy_id uuid,\npriority_applied integer,\nevaluation_details jsonb,\ntriggered_by_setting text"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "permission_policies",
    "definition": "id uuid,\nname text,\ndescription text,\npermission_type USER-DEFINED,\npriority integer,\neffect text,\nenabled boolean,\nmetadata jsonb"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "policy_assignments",
    "definition": "id uuid,\npolicy_id uuid,\nentity_id uuid,\nrole USER-DEFINED,\ncondition_expression jsonb"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "policy_conditions",
    "definition": "id uuid,\npolicy_id uuid,\nattribute_path text,\noperator text,\nvalue jsonb,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "state_machines",
    "definition": "id uuid,\nentity_type USER-DEFINED,\nname text,\ndescription text,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "state_transition_history",
    "definition": "id uuid,\nentity_type USER-DEFINED,\nentity_id uuid,\nfrom_state text,\nto_state text,\ntriggered_by_entity_id uuid,\nmetadata jsonb,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "state_transition_rules",
    "definition": "id uuid,\nentity_type USER-DEFINED,\nfrom_state text,\nto_state text,\ncondition jsonb,\naction text,\npriority integer,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "work_contract_versions",
    "definition": "id uuid,\ncontract_id uuid,\nversion_no integer,\nsnapshot jsonb,\ncreated_by_entity_id uuid,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "work_execution_units",
    "definition": "id uuid,\ncontract_id uuid,\nparent_unit_id uuid,\ntitle text,\ndescription text,\nassigned_entity_id uuid,\nstatus USER-DEFINED,\nprogress_percent numeric,\nallocated_amount numeric,\nstart_at timestamp with time zone,\ncompleted_at timestamp with time zone,\nmetadata jsonb,\ncreated_at timestamp with time zone,\nupdated_at timestamp with time zone,\nsequence_no integer,\nunit_type USER-DEFINED,\nassigned_by_entity_id uuid,\nis_milestone boolean,\nmilestone_amount numeric"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "work_financial_routes",
    "definition": "id uuid,\ncontract_id uuid,\npayer_entity_id uuid,\npayee_entity_id uuid,\nbeneficiary_type USER-DEFINED,\namount numeric,\npercentage numeric,\npriority integer,\nis_hidden boolean,\nmetadata jsonb,\ncreated_at timestamp with time zone"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "work_ownership_transfers",
    "definition": "id uuid,\ncontract_id uuid,\nfrom_entity_id uuid,\nto_entity_id uuid,\ntransfer_type USER-DEFINED,\ntransfer_scope USER-DEFINED,\nnotes text,\neffective_at timestamp with time zone,\ncreated_at timestamp with time zone,\npercentage numeric,\nupdated_at timestamp with time zone,\napplied_at timestamp with time zone,\npropagation_status text,\napply_effects boolean"
  },
  {
    "object_type": "TABLE",
    "schema_name": "work",
    "object_name": "work_visibility",
    "definition": "id uuid,\ncontract_id uuid,\nviewer_entity_id uuid,\nvisible_entity_id uuid,\nvisibility_type USER-DEFINED,\ncreated_at timestamp with time zone,\nmetadata jsonb"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trg_contract_state_transition",
    "definition": "CREATE TRIGGER trg_contract_state_transition BEFORE UPDATE OF status ON work.contracts FOR EACH ROW EXECUTE FUNCTION work.contract_state_transition_trigger();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_contract_approvals_updated_at",
    "definition": "CREATE TRIGGER trigger_contract_approvals_updated_at BEFORE UPDATE ON work.contract_approvals FOR EACH ROW EXECUTE FUNCTION work.update_updated_at_column();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_contract_ownership_init",
    "definition": "CREATE TRIGGER trigger_contract_ownership_init AFTER INSERT ON work.contracts FOR EACH ROW EXECUTE FUNCTION work.contract_ownership_history_init();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_contract_participants_updated_at",
    "definition": "CREATE TRIGGER trigger_contract_participants_updated_at BEFORE UPDATE ON work.contract_participants FOR EACH ROW EXECUTE FUNCTION work.update_updated_at_column();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_contracts_search_vector",
    "definition": "CREATE TRIGGER trigger_contracts_search_vector BEFORE INSERT OR UPDATE OF title, description, asset_code ON work.contracts FOR EACH ROW EXECUTE FUNCTION work.contracts_search_vector_update();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_contracts_updated_at",
    "definition": "CREATE TRIGGER trigger_contracts_updated_at BEFORE UPDATE ON work.contracts FOR EACH ROW EXECUTE FUNCTION work.update_updated_at_column();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_dispute_cases_updated_at",
    "definition": "CREATE TRIGGER trigger_dispute_cases_updated_at BEFORE UPDATE ON work.dispute_cases FOR EACH ROW EXECUTE FUNCTION work.update_updated_at_column();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_dispute_event",
    "definition": "CREATE TRIGGER trigger_dispute_event AFTER INSERT OR UPDATE OF status ON work.dispute_cases FOR EACH ROW EXECUTE FUNCTION work.notify_dispute_event();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_dispute_flag",
    "definition": "CREATE TRIGGER trigger_dispute_flag AFTER INSERT OR UPDATE OF status ON work.dispute_cases FOR EACH ROW EXECUTE FUNCTION work.update_contract_dispute_flag();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_ownership_transfer_auto_apply",
    "definition": "CREATE TRIGGER trigger_ownership_transfer_auto_apply AFTER INSERT ON work.work_ownership_transfers FOR EACH ROW EXECUTE FUNCTION work.auto_apply_ownership_transfer();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_ownership_transfer_event",
    "definition": "CREATE TRIGGER trigger_ownership_transfer_event AFTER INSERT OR UPDATE ON work.work_ownership_transfers FOR EACH ROW EXECUTE FUNCTION work.propagate_ownership_transfer_event();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_work_execution_units_updated_at",
    "definition": "CREATE TRIGGER trigger_work_execution_units_updated_at BEFORE UPDATE ON work.work_execution_units FOR EACH ROW EXECUTE FUNCTION work.update_updated_at_column();"
  },
  {
    "object_type": "TRIGGER",
    "schema_name": "work",
    "object_name": "trigger_work_ownership_transfers_updated_at",
    "definition": "CREATE TRIGGER trigger_work_ownership_transfers_updated_at BEFORE UPDATE ON work.work_ownership_transfers FOR EACH ROW EXECUTE FUNCTION work.update_updated_at_column();"
  }
]