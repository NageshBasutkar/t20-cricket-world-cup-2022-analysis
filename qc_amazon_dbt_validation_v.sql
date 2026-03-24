-- public.qc_amazon_dbt_validation_v source

CREATE OR REPLACE VIEW public.qc_amazon_dbt_validation_v
AS WITH ffmds AS (
         SELECT dt.company_id,
            dt.template_id,
            ffm1.id AS m1,
            ffm2.id AS m2,
            ffm3.id AS m3,
            ffm4.id AS m4,
            ffm5.id AS m5,
            ffm6.id AS m6,
            ffm8.id AS m8,
            ffm9.id AS m9
           FROM document_type dt
             LEFT JOIN form_fill_metadata ffm1 ON ffm1.sign_metadata_id = dt.sign_metadata_id AND ffm1.variable_name::text = '_mobile_'::text AND ffm1.deleted = false
             LEFT JOIN form_fill_metadata ffm2 ON ffm2.sign_metadata_id = dt.sign_metadata_id AND ffm2.variable_name::text = '_benname_'::text AND ffm2.deleted = false
             LEFT JOIN form_fill_metadata ffm3 ON ffm3.sign_metadata_id = dt.sign_metadata_id AND ffm3.variable_name::text = '_ifsc_'::text AND ffm3.deleted = false
             LEFT JOIN form_fill_metadata ffm4 ON ffm4.sign_metadata_id = dt.sign_metadata_id AND ffm4.variable_name::text = '_bankcc_'::text AND ffm4.deleted = false
             LEFT JOIN form_fill_metadata ffm5 ON ffm5.sign_metadata_id = dt.sign_metadata_id AND ffm5.variable_name::text = '_bankname_'::text AND ffm5.deleted = false
             LEFT JOIN form_fill_metadata ffm6 ON ffm6.sign_metadata_id = dt.sign_metadata_id AND ffm6.variable_name::text = '_branchname_'::text AND ffm6.deleted = false
             LEFT JOIN form_fill_metadata ffm8 ON ffm8.sign_metadata_id = dt.sign_metadata_id AND ffm8.variable_name::text = '_tc_'::text AND ffm8.deleted = false
             LEFT JOIN form_fill_metadata ffm9 ON ffm9.sign_metadata_id = dt.sign_metadata_id AND ffm9.variable_name::text = '_otp85_'::text AND ffm9.deleted = false
          WHERE dt.template_id = 44 AND dt.company_id = 1 AND dt.id = 98 AND dt.form_fill_enabled = true AND dt.is_deleted = false
        )
 SELECT t.id AS transaction_id,
    wfd.status AS transaction_status,
    to_char(wfd.created_date, 'DD-MON-YYYY'::text) AS created_date,
    to_char(t.last_update, 'DD-MON-YYYY'::text) AS last_update_date,
        CASE
            WHEN f1.encrypt_value = true THEN encode(decrypt_iv(decode(f1.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f1.id, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f1.value
        END AS mobile_number,
    f2.value AS customer_name,
    f3.value AS ifsc,
    f4.value AS bank_account_number,
    f5.value AS bank_name,
    f6.value AS branch_name,
    to_char(eal_bank_ifsc.created_date, 'DD-MON-YYYY HH24:MI:SS'::text) AS bank_ifsc_log_date,
        CASE
            WHEN (eal_bank_ifsc.response_body::json ->> 'status'::text) IS NULL THEN 'NA'::text
            ELSE eal_bank_ifsc.response_body::json ->> 'status'::text
        END AS bank_ifsc_status,
    to_char(eal_bank_ifsc_status.created_date, 'DD-MON-YYYY HH24:MI:SS'::text) AS bank_ifsc_status_log_date,
        CASE
            WHEN (eal_bank_ifsc_status.response_body::json ->> 'status'::text) IS NULL THEN 'NA'::text
            ELSE eal_bank_ifsc_status.response_body::json ->> 'status'::text
        END AS bank_ifsc_status1,
    f8.value AS consent_log,
    ffoa.last_update AS otp_verified_date_and_time
   FROM transaction t
     JOIN work_flow_data wfd ON wfd.transaction_id = t.id
     JOIN ffmds ON ffmds.template_id = t.template_id
     LEFT JOIN form_fill_data f1 ON f1.transaction_id = t.id AND f1.form_fill_metadata_id = ffmds.m1
     LEFT JOIN form_fill_data f2 ON f2.transaction_id = t.id AND f2.form_fill_metadata_id = ffmds.m2
     LEFT JOIN form_fill_data f3 ON f3.transaction_id = t.id AND f3.form_fill_metadata_id = ffmds.m3
     LEFT JOIN form_fill_data f4 ON f4.transaction_id = t.id AND f4.form_fill_metadata_id = ffmds.m4
     LEFT JOIN form_fill_data f5 ON f5.transaction_id = t.id AND f5.form_fill_metadata_id = ffmds.m5
     LEFT JOIN form_fill_data f6 ON f6.transaction_id = t.id AND f6.form_fill_metadata_id = ffmds.m6
     LEFT JOIN form_fill_data f8 ON f8.transaction_id = t.id AND f8.form_fill_metadata_id = ffmds.m8
     LEFT JOIN form_fill_data f9 ON f9.transaction_id = t.id AND f9.form_fill_metadata_id = ffmds.m9
     LEFT JOIN external_api_log eal_bank_ifsc ON eal_bank_ifsc.transaction_id = t.id AND eal_bank_ifsc.parameter_type::text = 'BANK_IFSC_AC_NUMBER'::text AND eal_bank_ifsc.api_provider::text = 'FRS'::text
     LEFT JOIN external_api_log eal_bank_ifsc_status ON eal_bank_ifsc_status.transaction_id = t.id AND eal_bank_ifsc_status.parameter_type::text = 'BANK_IFSC_AC_NUMBER_STATUS'::text AND eal_bank_ifsc_status.api_provider::text = 'FRS'::text
     LEFT JOIN form_fill_data_otp_auth ffoa ON ffoa.form_fill_data_id = f9.id AND ffoa.valid = true
  WHERE wfd.status::text = 'ACCEPTED'::text
  ORDER BY t.id DESC;