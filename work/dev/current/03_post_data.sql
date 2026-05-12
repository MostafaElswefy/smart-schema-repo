--
-- PostgreSQL database dump
--

\restrict m1yOf4Uw2LGZdCfAMyYFMclIrCRmGNnxBfkVTiZxLgmrKRKY25v6iySAm6TXthc

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: contract_approvals contract_approvals_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_approvals
    ADD CONSTRAINT contract_approvals_pkey PRIMARY KEY (id);


--
-- Name: contract_links contract_links_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_links
    ADD CONSTRAINT contract_links_pkey PRIMARY KEY (id);


--
-- Name: contract_messages contract_messages_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_messages
    ADD CONSTRAINT contract_messages_pkey PRIMARY KEY (id);


--
-- Name: contract_milestones contract_milestones_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_milestones
    ADD CONSTRAINT contract_milestones_pkey PRIMARY KEY (id);


--
-- Name: contract_participants contract_participants_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_participants
    ADD CONSTRAINT contract_participants_pkey PRIMARY KEY (id);


--
-- Name: contract_permissions contract_permissions_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_permissions
    ADD CONSTRAINT contract_permissions_pkey PRIMARY KEY (id);


--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);


--
-- Name: execution_logs execution_logs_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.execution_logs
    ADD CONSTRAINT execution_logs_pkey PRIMARY KEY (id);


--
-- Name: work_contract_versions uq_contract_version; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.work_contract_versions
    ADD CONSTRAINT uq_contract_version UNIQUE (contract_id, version_no);


--
-- Name: work_assignments work_assignments_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.work_assignments
    ADD CONSTRAINT work_assignments_pkey PRIMARY KEY (id);


--
-- Name: work_contract_versions work_contract_versions_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.work_contract_versions
    ADD CONSTRAINT work_contract_versions_pkey PRIMARY KEY (id);


--
-- Name: work_execution_units work_execution_units_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.work_execution_units
    ADD CONSTRAINT work_execution_units_pkey PRIMARY KEY (id);


--
-- Name: work_financial_routes work_financial_routes_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.work_financial_routes
    ADD CONSTRAINT work_financial_routes_pkey PRIMARY KEY (id);


--
-- Name: work_ownership_transfers work_ownership_transfers_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.work_ownership_transfers
    ADD CONSTRAINT work_ownership_transfers_pkey PRIMARY KEY (id);


--
-- Name: work_visibility work_visibility_pkey; Type: CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.work_visibility
    ADD CONSTRAINT work_visibility_pkey PRIMARY KEY (id);


--
-- Name: work_assignments fk_assignment_contract; Type: FK CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.work_assignments
    ADD CONSTRAINT fk_assignment_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;


--
-- Name: contracts fk_contract_asset; Type: FK CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contracts
    ADD CONSTRAINT fk_contract_asset FOREIGN KEY (asset_code) REFERENCES app_wallet.assets(code);


--
-- Name: contracts fk_contract_created_by; Type: FK CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contracts
    ADD CONSTRAINT fk_contract_created_by FOREIGN KEY (created_by_entity_id) REFERENCES ecosystem.entities(id);


--
-- Name: contracts fk_contract_owned_by; Type: FK CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contracts
    ADD CONSTRAINT fk_contract_owned_by FOREIGN KEY (owned_by_entity_id) REFERENCES ecosystem.entities(id);


--
-- Name: contract_participants fk_participant_contract; Type: FK CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_participants
    ADD CONSTRAINT fk_participant_contract FOREIGN KEY (contract_id) REFERENCES work.contracts(id) ON DELETE CASCADE;


--
-- Name: contract_participants fk_participant_entity; Type: FK CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_participants
    ADD CONSTRAINT fk_participant_entity FOREIGN KEY (entity_id) REFERENCES ecosystem.entities(id);


--
-- Name: contract_participants fk_participant_parent; Type: FK CONSTRAINT; Schema: work; Owner: -
--

ALTER TABLE ONLY work.contract_participants
    ADD CONSTRAINT fk_participant_parent FOREIGN KEY (parent_participant_id) REFERENCES work.contract_participants(id) ON DELETE SET NULL;


--
-- Name: contract_approvals; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.contract_approvals ENABLE ROW LEVEL SECURITY;

--
-- Name: contract_links; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.contract_links ENABLE ROW LEVEL SECURITY;

--
-- Name: contract_messages; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.contract_messages ENABLE ROW LEVEL SECURITY;

--
-- Name: contract_milestones; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.contract_milestones ENABLE ROW LEVEL SECURITY;

--
-- Name: contract_participants; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.contract_participants ENABLE ROW LEVEL SECURITY;

--
-- Name: contract_permissions; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.contract_permissions ENABLE ROW LEVEL SECURITY;

--
-- Name: contracts; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.contracts ENABLE ROW LEVEL SECURITY;

--
-- Name: execution_logs; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.execution_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: work_assignments; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.work_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: work_contract_versions; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.work_contract_versions ENABLE ROW LEVEL SECURITY;

--
-- Name: work_execution_units; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.work_execution_units ENABLE ROW LEVEL SECURITY;

--
-- Name: work_financial_routes; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.work_financial_routes ENABLE ROW LEVEL SECURITY;

--
-- Name: work_ownership_transfers; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.work_ownership_transfers ENABLE ROW LEVEL SECURITY;

--
-- Name: work_visibility; Type: ROW SECURITY; Schema: work; Owner: -
--

ALTER TABLE work.work_visibility ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

\unrestrict m1yOf4Uw2LGZdCfAMyYFMclIrCRmGNnxBfkVTiZxLgmrKRKY25v6iySAm6TXthc

