-- public.qc_account_validation_consent_v source

CREATE OR REPLACE VIEW public.qc_account_validation_consent_v
AS SELECT t.id AS transaction_id,
    wfd.title,
    to_char(wfd.created_date, 'DD-MON-YYYY HH24:MI:SS'::text) AS created_date,
    to_char(wfd.last_update, 'DD-MON-YYYY HH24:MI:SS'::text) AS last_update,
    wfd.status,
    au.email AS created_by_email_id,
        CASE
            WHEN f0.encrypt_value = true THEN encode(decrypt_iv(decode(f0.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f0.id, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f0.value
        END AS mobile_number,
    f1.value AS customer_name,
    f2.value AS beneficiary_name,
    f3.value AS ifsc,
    f4.value AS bank_account_number,
    f5.value AS beneficiary_name_from_bank,
    f6.value AS bank_name,
    f7.value AS branch_name,
    f8.value AS account_no,
    f9.value AS fund_account_type,
    f10.value AS payout_mode,
    f11.value AS contact_type,
    f12.value AS contact_type1,
    f13.value AS contact_name,
    f14.value AS email,
    f15.value AS notes_place,
    f16.value AS notes_corporate_name,
    f17.value AS validated_account_status,
    f18.value AS failure_reason
   FROM transaction t
     JOIN work_flow_data wfd ON t.id = wfd.transaction_id
     JOIN app_user au ON au.id = t.created_by_id
     JOIN form_fill_data f0 ON t.id = f0.transaction_id
     JOIN form_fill_data f1 ON t.id = f1.transaction_id
     JOIN form_fill_data f2 ON t.id = f2.transaction_id
     JOIN form_fill_data f3 ON t.id = f3.transaction_id
     JOIN form_fill_data f4 ON t.id = f4.transaction_id
     JOIN form_fill_data f5 ON t.id = f5.transaction_id
     JOIN form_fill_data f6 ON t.id = f6.transaction_id
     JOIN form_fill_data f7 ON t.id = f7.transaction_id
     JOIN form_fill_data f8 ON t.id = f8.transaction_id
     JOIN form_fill_data f9 ON t.id = f9.transaction_id
     JOIN form_fill_data f10 ON t.id = f10.transaction_id
     JOIN form_fill_data f11 ON t.id = f11.transaction_id
     JOIN form_fill_data f12 ON t.id = f12.transaction_id
     JOIN form_fill_data f13 ON t.id = f13.transaction_id
     JOIN form_fill_data f14 ON t.id = f14.transaction_id
     JOIN form_fill_data f15 ON t.id = f15.transaction_id
     JOIN form_fill_data f16 ON t.id = f16.transaction_id
     JOIN form_fill_data f17 ON t.id = f17.transaction_id
     JOIN form_fill_data f18 ON t.id = f18.transaction_id
  WHERE t.template_id = 6 AND f0.form_fill_metadata_id = 277 AND f1.form_fill_metadata_id = 285 AND f2.form_fill_metadata_id = 278 AND f3.form_fill_metadata_id = 279 AND f4.form_fill_metadata_id = 280 AND f5.form_fill_metadata_id = 281 AND f6.form_fill_metadata_id = 282 AND f7.form_fill_metadata_id = 283 AND f8.form_fill_metadata_id = 284 AND f9.form_fill_metadata_id = 286 AND f10.form_fill_metadata_id = 287 AND f11.form_fill_metadata_id = 288 AND f12.form_fill_metadata_id = 289 AND f13.form_fill_metadata_id = 290 AND f14.form_fill_metadata_id = 291 AND f15.form_fill_metadata_id = 292 AND f16.form_fill_metadata_id = 293 AND f17.form_fill_metadata_id = 294 AND f18.form_fill_metadata_id = 295
  ORDER BY t.id DESC;