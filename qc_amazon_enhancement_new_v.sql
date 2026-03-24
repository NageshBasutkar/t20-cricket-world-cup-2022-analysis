-- public.qc_amazon_enhancement_new_v source

CREATE OR REPLACE VIEW public.qc_amazon_enhancement_new_v
AS WITH ffmds AS (
         SELECT dt.company_id,
            dt.template_id,
            ffm1.id AS m1,
            ffm2.id AS m2,
            ffm3.id AS m3,
            ffm4.id AS m4,
            ffm5.id AS m5,
            ffm6.id AS m6,
            ffm7.id AS m7,
            ffm8.id AS m8,
            ffm9.id AS m9,
            ffm10.id AS m10,
            ffm11.id AS m11,
            ffm12.id AS m12,
            ffm13.id AS m13,
            ffm14.id AS m14,
            ffm15.id AS m15,
            ffm16.id AS m16,
            ffm17.id AS m17,
            ffm18.id AS m18,
            ffm19.id AS m19,
            ffm20.id AS m20
           FROM document_type dt
             LEFT JOIN form_fill_metadata ffm1 ON ffm1.sign_metadata_id = dt.sign_metadata_id AND ffm1.variable_name::text = '_typeState_'::text AND ffm1.deleted = false
             LEFT JOIN form_fill_metadata ffm2 ON ffm2.sign_metadata_id = dt.sign_metadata_id AND ffm2.variable_name::text = '_execdate_'::text AND ffm2.deleted = false
             LEFT JOIN form_fill_metadata ffm3 ON ffm3.sign_metadata_id = dt.sign_metadata_id AND ffm3.variable_name::text = '_entityName_'::text AND ffm3.deleted = false
             LEFT JOIN form_fill_metadata ffm4 ON ffm4.sign_metadata_id = dt.sign_metadata_id AND ffm4.variable_name::text = '_orgType_'::text AND ffm4.deleted = false
             LEFT JOIN form_fill_metadata ffm5 ON ffm5.sign_metadata_id = dt.sign_metadata_id AND ffm5.variable_name::text = '_gst_'::text AND ffm5.deleted = false
             LEFT JOIN form_fill_metadata ffm6 ON ffm6.sign_metadata_id = dt.sign_metadata_id AND ffm6.variable_name::text = '_title_'::text AND ffm6.deleted = false
             LEFT JOIN form_fill_metadata ffm7 ON ffm7.sign_metadata_id = dt.sign_metadata_id AND ffm7.variable_name::text = '_cin_'::text AND ffm7.deleted = false
             LEFT JOIN form_fill_metadata ffm8 ON ffm8.sign_metadata_id = dt.sign_metadata_id AND ffm8.variable_name::text = '_regAdr_'::text AND ffm8.deleted = false
             LEFT JOIN form_fill_metadata ffm9 ON ffm9.sign_metadata_id = dt.sign_metadata_id AND ffm9.variable_name::text = '_city1_'::text AND ffm9.deleted = false
             LEFT JOIN form_fill_metadata ffm10 ON ffm10.sign_metadata_id = dt.sign_metadata_id AND ffm10.variable_name::text = '_state1_'::text AND ffm10.deleted = false
             LEFT JOIN form_fill_metadata ffm11 ON ffm11.sign_metadata_id = dt.sign_metadata_id AND ffm11.variable_name::text = '_pin1_'::text AND ffm11.deleted = false
             LEFT JOIN form_fill_metadata ffm12 ON ffm12.sign_metadata_id = dt.sign_metadata_id AND ffm12.variable_name::text = '_biladdr_'::text AND ffm12.deleted = false
             LEFT JOIN form_fill_metadata ffm13 ON ffm13.sign_metadata_id = dt.sign_metadata_id AND ffm13.variable_name::text = '_city2_'::text AND ffm13.deleted = false
             LEFT JOIN form_fill_metadata ffm14 ON ffm14.sign_metadata_id = dt.sign_metadata_id AND ffm14.variable_name::text = '_state2_'::text AND ffm14.deleted = false
             LEFT JOIN form_fill_metadata ffm15 ON ffm15.sign_metadata_id = dt.sign_metadata_id AND ffm15.variable_name::text = '_pin2_'::text AND ffm15.deleted = false
             LEFT JOIN form_fill_metadata ffm16 ON ffm16.sign_metadata_id = dt.sign_metadata_id AND ffm16.variable_name::text = '_name_'::text AND ffm16.deleted = false
             LEFT JOIN form_fill_metadata ffm17 ON ffm17.sign_metadata_id = dt.sign_metadata_id AND ffm17.variable_name::text = '_designation_'::text AND ffm17.deleted = false
             LEFT JOIN form_fill_metadata ffm18 ON ffm18.sign_metadata_id = dt.sign_metadata_id AND ffm18.variable_name::text = '_tele1_'::text AND ffm18.deleted = false
             LEFT JOIN form_fill_metadata ffm19 ON ffm19.sign_metadata_id = dt.sign_metadata_id AND ffm19.variable_name::text = '_email1_'::text AND ffm19.deleted = false
             LEFT JOIN form_fill_metadata ffm20 ON ffm20.sign_metadata_id = dt.sign_metadata_id AND ffm20.variable_name::text = '_decPan_'::text AND ffm20.deleted = false
          WHERE dt.template_id = 46 AND dt.form_fill_enabled = true AND dt.id = 103 AND dt.is_deleted = false
        )
 SELECT t.id AS transaction_id,
    to_char(wfd.created_date, 'DD-MON-YYYY'::text) AS created_date,
        CASE
            WHEN f1.encrypt_value = true THEN encode(decrypt_iv(decode(f1.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f1.id, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f1.value
        END AS merchant_name,
    f2.value AS agreement_execution_date,
    f3.value AS name_of_the_entity,
    f4.value AS type_of_organisation,
    f5.value AS gst_registration_no,
        CASE
            WHEN f6.encrypt_value = true THEN encode(decrypt_iv(decode(f6.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f6.id, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f6.value
        END AS permanent_account_number,
    f7.value AS cin_llp_number,
    f8.value AS registered_address,
    f9.value AS registered_city,
    f10.value AS registered_state,
    f11.value AS registered_pin_code,
    f12.value AS billing_address,
    f13.value AS billing_city,
    f14.value AS billing_state,
    f15.value AS billing_pin_code,
    f16.value AS authorised_signatory_name,
    f17.value AS authorised_signatory_designation,
    f18.value AS authorised_signatory_mobile,
    f19.value AS authorised_signatory_email_id,
        CASE
            WHEN f20.encrypt_value = true THEN encode(decrypt_iv(decode(f20.value, 'base64'::text), digest('QiBL46cGKVfocnUl'::text || f20.id, 'sha256'::text), '\x4e716e6f617574617679596d61575056'::bytea, 'aes-cbc/pad:pkcs'::text), 'escape'::text)
            ELSE f20.value
        END AS pan
   FROM transaction t
     JOIN work_flow_data wfd ON wfd.transaction_id = t.id
     JOIN ffmds ON ffmds.template_id = t.template_id
     LEFT JOIN form_fill_data f1 ON f1.transaction_id = t.id AND f1.form_fill_metadata_id = ffmds.m1
     LEFT JOIN form_fill_data f2 ON f2.transaction_id = t.id AND f2.form_fill_metadata_id = ffmds.m2
     LEFT JOIN form_fill_data f3 ON f3.transaction_id = t.id AND f3.form_fill_metadata_id = ffmds.m3
     LEFT JOIN form_fill_data f4 ON f4.transaction_id = t.id AND f4.form_fill_metadata_id = ffmds.m4
     LEFT JOIN form_fill_data f5 ON f5.transaction_id = t.id AND f5.form_fill_metadata_id = ffmds.m5
     LEFT JOIN form_fill_data f6 ON f6.transaction_id = t.id AND f6.form_fill_metadata_id = ffmds.m6
     LEFT JOIN form_fill_data f7 ON f7.transaction_id = t.id AND f7.form_fill_metadata_id = ffmds.m7
     LEFT JOIN form_fill_data f8 ON f8.transaction_id = t.id AND f8.form_fill_metadata_id = ffmds.m8
     LEFT JOIN form_fill_data f9 ON f9.transaction_id = t.id AND f9.form_fill_metadata_id = ffmds.m9
     LEFT JOIN form_fill_data f10 ON f10.transaction_id = t.id AND f10.form_fill_metadata_id = ffmds.m10
     LEFT JOIN form_fill_data f11 ON f11.transaction_id = t.id AND f11.form_fill_metadata_id = ffmds.m11
     LEFT JOIN form_fill_data f12 ON f12.transaction_id = t.id AND f12.form_fill_metadata_id = ffmds.m12
     LEFT JOIN form_fill_data f13 ON f13.transaction_id = t.id AND f13.form_fill_metadata_id = ffmds.m13
     LEFT JOIN form_fill_data f14 ON f14.transaction_id = t.id AND f14.form_fill_metadata_id = ffmds.m14
     LEFT JOIN form_fill_data f15 ON f15.transaction_id = t.id AND f15.form_fill_metadata_id = ffmds.m15
     LEFT JOIN form_fill_data f16 ON f16.transaction_id = t.id AND f16.form_fill_metadata_id = ffmds.m16
     LEFT JOIN form_fill_data f17 ON f17.transaction_id = t.id AND f17.form_fill_metadata_id = ffmds.m17
     LEFT JOIN form_fill_data f18 ON f18.transaction_id = t.id AND f18.form_fill_metadata_id = ffmds.m18
     LEFT JOIN form_fill_data f19 ON f19.transaction_id = t.id AND f19.form_fill_metadata_id = ffmds.m19
     LEFT JOIN form_fill_data f20 ON f20.transaction_id = t.id AND f20.form_fill_metadata_id = ffmds.m20
  WHERE wfd.last_update::date >= (CURRENT_DATE - '1 day'::interval) AND wfd.last_update::date <= CURRENT_DATE AND wfd.status::text = 'ACCEPTED'::text AND t.internal_attr1 IS NULL;