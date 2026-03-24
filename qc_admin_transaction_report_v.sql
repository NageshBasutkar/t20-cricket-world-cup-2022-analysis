-- public.qc_admin_transaction_report_v source

CREATE OR REPLACE VIEW public.qc_admin_transaction_report_v
AS SELECT ( SELECT fd.value
           FROM form_fill_data fd
          WHERE fd.form_fill_metadata_id = 163 AND fd.transaction_id = t.id) AS title,
    gp.email,
    gp.mobile_number,
    to_char(to_timestamp((wfd.expire_on::numeric / 1000.0)::double precision), 'DD-MON-YYYY'::text) AS expires_on,
    to_char(wfd.created_date, 'DD-MON-YYYY'::text) AS created_date,
    wfd.transaction_id,
    (t.transaction_type::text || '-'::text) || t.template_id AS type,
    wfd.status,
    ( SELECT tx.id
           FROM transaction tx
          WHERE tx.chain_transaction_id = t.id) AS child_transaction_id,
    ( SELECT wx.status
           FROM transaction tx,
            work_flow_data wx
          WHERE tx.id = wx.transaction_id AND tx.chain_transaction_id = t.id) AS qc_esign_status,
    'Yes'::text AS user_verified,
    f1.value AS entity_type,
        CASE
            WHEN f2.value = 'Other'::text OR f2.value IS NULL OR f2.value = ''::text THEN ( SELECT b.value
               FROM form_fill_metadata c,
                form_fill_data b
              WHERE c.id = b.form_fill_metadata_id AND b.transaction_id = t.id AND b.form_fill_metadata_id = 273)
            ELSE f2.value
        END AS category,
    f3.validation_status AS pan_verifed,
    f4.validation_status AS bank_verified,
    ( SELECT to_char(to_timestamp((d.candidate_documentsigned_date::numeric / 1000.0)::double precision), 'DD-MON-YYYY'::text) AS to_char
           FROM document d
          WHERE d.work_flow_data_id = wfd.id AND d.document_type_id = 4 AND d.is_deleted = false
          ORDER BY d.id DESC
         LIMIT 1) AS master_agreement_signed,
        CASE
            WHEN wfd.status::text = 'ACCEPTED'::text THEN 'Yes'::text
            WHEN wfd.status::text = 'AWAITING_APPROVAL'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS submited_form,
    ( SELECT tp.status
           FROM transaction_participant tp
          WHERE tp.transaction_id = t.id AND tp.approval_order = 1) AS sales_approval_status,
    ( SELECT tp.status
           FROM transaction_participant tp
          WHERE tp.transaction_id = t.id AND tp.approval_order = 2) AS legal_approval_status,
    t.attr2 AS product_url,
    t.attr3 AS redeem_url,
    t.attr4 AS email_date
   FROM transaction t,
    work_flow_data wfd,
    generic_party gp,
    form_fill_data f1,
    form_fill_data f2,
    form_fill_data f3,
    form_fill_data f4
  WHERE t.id = wfd.transaction_id AND t.generic_party_id = gp.id AND f1.transaction_id = t.id AND f2.transaction_id = t.id AND f3.transaction_id = t.id AND f4.transaction_id = t.id AND t.template_id = 3 AND f1.form_fill_metadata_id = 164 AND f2.form_fill_metadata_id = 165 AND f3.form_fill_metadata_id = 172 AND f4.form_fill_metadata_id = 182 AND (wfd.status::text = ANY (ARRAY['ACCEPTED'::character varying::text, 'AWAITING_APPROVAL'::character varying::text, 'SENT_TO_SECOND_PARTY'::character varying::text]))
  ORDER BY wfd.transaction_id DESC;