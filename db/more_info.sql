--
-- Data for Name: footprint_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from footprint_reports;
COPY footprint_reports (id, deadline, title, more_info, phase, created_at, updated_at) FROM stdin;
1	2011-07-31	Footprint Report Phase One	<Placeholder for more info>	1	2010-09-22 13:25:54.302054	2010-09-22 13:25:54.302054
\.


--
-- Data for Name: other_fuels_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from other_fuels_tasks;
COPY other_fuels_tasks (id, status, footprint_report_id, more_info, created_at, updated_at) FROM stdin;
1	0	1	This section is used to report the supply of any fuels that do not appear in the fuels list	2010-09-22 13:25:55.36347	2010-09-22 14:44:18.65475
\.


--
-- Data for Name: reconfirmation_exemption_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from reconfirmation_exemption_tasks;
COPY reconfirmation_exemption_tasks (id, choice, status, footprint_report_id, more_info, created_at, updated_at) FROM stdin;
1	1	0	1	This section is used to reconfirm your CCA exemption status	2010-09-22 13:25:54.649862	2010-09-22 14:05:29.890041
\.


--
-- Data for Name: residual_emissions_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from residual_emissions_tasks;
COPY residual_emissions_tasks (id, footprint_report_id, status, more_info, created_at, updated_at) FROM stdin;
1	1	0	This section is used to report to any residual supplies	2010-09-22 13:25:55.080565	2010-09-22 14:22:00.026318
\.


--
-- Data for Name: calculation_check_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from calculation_check_tasks;
COPY calculation_check_tasks (id, status, in_order, more_info, footprint_report_id, created_at, updated_at) FROM stdin;
1	0	f	<Placeholder for more info>	1	2010-09-22 13:25:54.912908	2010-09-22 13:25:54.912908
\.


--
-- Data for Name: cca_exemptions_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from cca_exemptions_tasks;
COPY cca_exemptions_tasks (id, deadline, status, more_info, footprint_report_id, created_at, updated_at) FROM stdin;
1	2011-07-31	0	This section is used to review any CCA exemptions claimed at registration	1	2010-09-22 13:25:54.35653	2010-09-22 14:02:57.710321
\.


--
-- Data for Name: designated_changes_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from designated_changes_tasks;
COPY designated_changes_tasks (id, deadline, status, more_info, footprint_report_id, created_at, updated_at) FROM stdin;
1	2011-07-31	0	This section is used to report any large-scale organisational changes during the footprint year	1	2010-09-22 13:25:54.466495	2010-09-22 13:50:27.358449
\.

--
-- Data for Name: emission_metrics_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from emission_metrics_tasks;
COPY emission_metrics_tasks (id, "core_energy_ETS", "non_core_energy_ETS", cca_subsidiaries, cca_core_energy, cca_non_core_energy, electricity_generated_credit, renewables_generation, more_info, status, footprint_report_id, created_at, updated_at) FROM stdin;
1	0	0	0	0	0	0	0	This section is used to record your emissions which are to be deducted from your CRC emissions, such as total emissions from EU ETS and CCA sources	0	1	2010-09-22 13:25:54.833145	2010-09-22 14:19:45.003239
\.


--
-- Data for Name: energy_metrics_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--
Delete from energy_metrics_tasks;
COPY energy_metrics_tasks (id, footprint_report_id, core_electricity, core_gas, non_core_electricity, non_core_gas, aviation_spirit, blast_furnace_gas, burning_fuels, coke_oven_gas, colliery_methane, diesel, fuel_oil, gas_oil, industrial_coal, "LPG", lubricants, waste, naphtha, natural_gas, petrol_gas, petrol, more_info, status, created_at, updated_at) FROM stdin;
1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	This section is used to report your energy supplies of core electricity, gas and other fuels that are not already covered by EU ETS or CCA	0	2010-09-22 13:25:54.758025	2010-09-22 14:15:53.327532
\.
